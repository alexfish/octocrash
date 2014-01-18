//
//  AEFClient.m
//  OctoCrash
//
//  Created by Alex Fish on 17/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "AEFClient.h"

// Models
#import <OctoKit/OctoKit.h>
#import <CrashReporter/PLCrashReport.h>
#import "AEFUserCache.h"
#import "AEFUser.h"
#import "NSError+AEFErrors.h"

// Extensions
#import "PLCrashReport+Issues.h"
#import "NSArray+Issues.h"
#import "AEFClient+Login.h"
#import "AEFClient_Private.h"


@implementation AEFClient


#pragma mark - Init

- (id)initWithRepo:(NSString *)repo
          clientID:(NSString *)clientID
      clientSecret:(NSString *)clientSecret
{
    self = [super init];
    if (self)
    {
        self.repo = repo;
        self.clientID = clientID;
        self.clientSecret = clientSecret;
        
        [OCTClient setClientID:clientID clientSecret:clientSecret];
    }
    
    return self;
}


#pragma mark - Reports

- (void)sendReport:(PLCrashReport *)report
            client:(OCTClient *)client
         completed:(void (^)(void))completedBlock
             error:(void (^)(NSError *error))errorBlock
{
    if (client.authenticated)
    {
        [self sendRequestWithClient:client
                             report:report
                          completed:completedBlock
                              error:errorBlock];
    }
    else
    {
        if (errorBlock)
        {
            errorBlock([NSError errorWithCode:AEFErrorCodeAuthFailed]);
        }
    }
}

- (void)getReport:(PLCrashReport *)report
           client:(OCTClient *)client
        completed:(void (^)(NSURL *reportURL))completedBlock
            error:(void (^)(NSError *error))errorBlock
{
    if (client.authenticated)
    {
        __weak typeof(self) weakSelf = self;
        [self getRequestWithClient:client completed:^(NSArray *issues) {
            typeof (self) __strong strongSelf = weakSelf;
            if (!strongSelf) return;
            
            NSURL *URL = [issues reportURL:report];
            
            if (URL)
            {
                if (completedBlock)
                {
                    completedBlock(URL);
                }
            }
            else
            {
                if (errorBlock)
                {
                    errorBlock([NSError errorWithCode:AEFErrorCodeNotFound]);
                }
            }
        } error:^(NSError *error) {
            if (errorBlock)
            {
                errorBlock(error);
            }
        }];
    }
    else
    {
        if (errorBlock)
        {
            errorBlock([NSError errorWithCode:AEFErrorCodeAuthFailed]);
        }
    }
}

- (NSURL *)matchedURLForReport:(PLCrashReport *)report inArray:(NSArray *)array
{
    NSURL *URL = nil;
    
    for (OCTResponse *response in array)
    {
        OCTIssue *issue = response.parsedResult;
        if ([report isEqualToIssue:issue])
        {
            URL = issue.HTMLURL;
            break;
        }
    }
    
    return URL;
}


#pragma mark - Request (Private)

- (void)sendRequestWithClient:(OCTClient *)client
                       report:(PLCrashReport *)report
                    completed:(void (^)(void))completedBlock
                        error:(void (^)(NSError *error))errorBlock
{
    
    NSURLRequest *request = [client requestWithMethod:@"POST"
                                                 path:[self issuesPath]
                                           parameters:report.parameters
                                      notMatchingEtag:nil];
    
    RACSignal *signal = [client enqueueRequest:request resultClass:[OCTIssue class]];
    [[signal collect] subscribeNext:^(id x) {
        if (completedBlock)
        {
            completedBlock();
        }
    } error:^(NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
}

- (void)getRequestWithClient:(OCTClient *)client
                   completed:(void (^)(NSArray *issues))completedBlock
                       error:(void (^)(NSError *error))errorBlock
{
    NSURLRequest *request = [client requestWithMethod:@"GET"
                                                 path:[self issuesPath]
                                           parameters:nil
                                      notMatchingEtag:nil];
    
    RACSignal *signal = [client enqueueRequest:request resultClass:[OCTIssue class]];
    [[signal collect] subscribeNext:^(NSArray *issues) {
        if (completedBlock)
        {
            completedBlock(issues);
        }
    } error:^(NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
}

- (NSString *)issuesPath
{
    return [NSString stringWithFormat:@"repos/%@/issues", self.repo];
}


#pragma mark - Authentication

- (void)authenticate:(void (^)(OCTClient *client))completedBlock
{
    AEFUser *cachedUser = [AEFUserCache cachedUser];
    if (cachedUser)
    {
        // Use the cached user token to autenticate
        OCTUser *user = [OCTUser userWithLogin:cachedUser.login server:OCTServer.dotComServer];
        OCTClient *client = [OCTClient authenticatedClientWithUser:user token:cachedUser.token];
        
        if (completedBlock)
        {
            completedBlock(client);
        }
    }
    else
    {
        [self setAuthenticated:completedBlock];
        [self displayLogin];
    }
}


#pragma mark - Authentication (Private)

- (void)authenticateLogin:(NSString *)login
                 password:(NSString *)password
          oneTimePassword:(NSString *)oneTimePassword
{
    OCTUser *user = [OCTUser userWithLogin:login
                                    server:OCTServer.dotComServer];
    
    __weak typeof(self) weakSelf = self;
    [[OCTClient signInAsUser:user
                    password:password
             oneTimePassword:oneTimePassword
                      scopes:OCTClientAuthorizationScopesRepository]
     subscribeNext:^(OCTClient *authenticatedClient) {
         
         AEFUser *authenticatedUser = [[AEFUser alloc] initWithLogin:login token:authenticatedClient.token];
         [AEFUserCache cacheUser:authenticatedUser];
         
         typeof (self) __strong strongSelf = weakSelf;
         if (!strongSelf) return;
         
         if (strongSelf.authenticated)
         {
             strongSelf.authenticated(authenticatedClient);
             strongSelf.authenticated = nil;
         }
     } error:^(NSError *error) {
         typeof (self) __strong strongSelf = weakSelf;
         if (!strongSelf) return;
         
         [strongSelf handleError:error];
     }];
}


#pragma mark - Errors (Private)

- (void)handleError:(NSError *)error
{
    if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayOneTimePasswordLogin];
        });
    }
    else
    {
        [AEFUserCache clearCache];
        [self displayAuthError];
    }
}


@end
