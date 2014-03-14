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
#import "EXTScope.h"
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

- (void)createReport:(PLCrashReport *)report
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
        @weakify(completedBlock);
        @weakify(errorBlock);
        [self requestWithClient:client path:[self issuesPath] method:@"GET" parameters:nil completed:^(id response) {
            @strongify(completedBlock);
            @strongify(errorBlock);
            
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
                path:(NSString *)path
              client:(OCTClient *)client
           completed:(void (^)())completedBlock
               error:(void (^)(NSError *))errorBlock
{
    
    if (client.authenticated)
    {
        [self requestWithClient:client
                           path:[self commentsPathWithReportPath:path]
                         method:@"POST"
                     parameters:report.commentParameters
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
    
    @weakify(completedBlock);
    @weakify(errorBlock);
    RACSignal *signal = [client enqueueRequest:request resultClass:[OCTIssue class]];
    [[signal collect] subscribeNext:^(id response) {
        @strongify(completedBlock);
        
        if (completedBlock)
        {
            completedBlock(response);
        }
    } error:^(NSError *error) {
        @strongify(errorBlock);
        
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

- (NSString *)commentsPathWithReportPath:(NSString *)reportPath
{
    NSString *apiPath = [reportPath stringByReplacingOccurrencesOfString:kAEFGithubBaseURL withString:@"repos/"];
    apiPath = [apiPath stringByAppendingString:@"/comments"];
    
    return apiPath;
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
    
    @weakify(self);
    [[OCTClient signInAsUser:user
                    password:password
             oneTimePassword:oneTimePassword
                      scopes:OCTClientAuthorizationScopesRepository]
     subscribeNext:^(OCTClient *authenticatedClient) {
         @strongify(self);

         AEFUser *authenticatedUser = [[AEFUser alloc] initWithLogin:login
                                                               token:authenticatedClient.token];
         [AEFUserCache cacheUser:authenticatedUser];
         
         if (self.authenticated)
         {
             self.authenticated(authenticatedClient);
             self.authenticated = nil;
         }
     } error:^(NSError *error) {
         @strongify(self);
         
         [self handleError:error];
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
