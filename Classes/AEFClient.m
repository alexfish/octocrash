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
         completed:(void (^)(id response))completedBlock
             error:(void (^)(NSError *error))errorBlock
{
    if (client.authenticated)
    {
        [self requestWithClient:client
                           path:[self issuesPath]
                         method:@"POST"
                     parameters:report.parameters
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
        [self requestWithClient:client path:[self issuesPath] method:@"GET" parameters:nil completed:^(id response) {
            
            typeof (self) __strong strongSelf = weakSelf;
            if (!strongSelf) return;
            
            NSURL *URL = [response reportURL:report];
            
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
        } error:errorBlock];
    }
    else
    {
        if (errorBlock)
        {
            errorBlock([NSError errorWithCode:AEFErrorCodeAuthFailed]);
        }
    }
}

- (void)updateReport:(PLCrashReport *)report
                path:(NSURL *)path
              client:(OCTClient *)client
           completed:(void (^)())completedBlock
               error:(void (^)(NSError *))errorBlock
{
    
}


#pragma mark - Request (Private)


- (void)requestWithClient:(OCTClient *)client
                     path:(NSString *)path
                   method:(NSString *)method
               parameters:(NSDictionary *)paramaters
                completed:(void (^)(id response))completedBlock
                    error:(void (^)(NSError *error))errorBlock
{
    
    NSURLRequest *request = [client requestWithMethod:method
                                                 path:path
                                           parameters:paramaters
                                      notMatchingEtag:nil];
    
    RACSignal *signal = [client enqueueRequest:request resultClass:[OCTIssue class]];
    [[signal collect] subscribeNext:^(id response) {
        if (completedBlock)
        {
            completedBlock(response);
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
