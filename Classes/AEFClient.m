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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AEFUserCache.h"
#import "AEFUser.h"
#import "NSError+AEFErrors.h"

// Extensions
#import "EXTScope.h"
#import "PLCrashReport+Issues.h"
#import "NSArray+Issues.h"
#import "AEFClient+Login.h"
#import "AEFClient_Private.h"

// Strings
static NSString *const kAEFGETMethod    = @"GET";
static NSString *const kAEFPOSTMethod   = @"POST";


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

- (RACSignal *)createReport:(PLCrashReport *)report client:(OCTClient *)client
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        if (client.authenticated)
        {
            [self requestWithClient:client
                               path:self.issuesPath
                             method:kAEFPOSTMethod
                         parameters:report.parameters
                          completed:^(id response) {
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
        }
        else
        {
            [subscriber sendError:[NSError errorWithCode:AEFErrorCodeAuthFailed]];
        }
        
        return nil;
    }];
}

- (RACSignal *)loadReport:(PLCrashReport *)report client:(OCTClient *)client
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (client.authenticated)
        {
            [self requestWithClient:client
                               path:self.issuesPath
                             method:kAEFGETMethod
                         parameters:nil
                          completed:^(id response) {
                              
                [subscriber sendNext:[response reportURL:report]];
                [subscriber sendCompleted];
                
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
        }
        else
        {
            [subscriber sendError:[NSError errorWithCode:AEFErrorCodeAuthFailed]];
        }
        
        return nil;
    }];
}

- (RACSignal *)updateReport:(PLCrashReport *)report
                       path:(NSString *)path
                     client:(OCTClient *)client
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self requestWithClient:client
                           path:[self commentsPathWithReportPath:path]
                         method:kAEFPOSTMethod
                     parameters:report.commentParameters
                      completed:^(id response) {
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
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

static NSString *const kAEFFormattedIssuesPath = @"repos/%@/issues";

- (NSString *)issuesPath
{
    return [NSString stringWithFormat:kAEFFormattedIssuesPath, self.repo];
}

static NSString *const kAEFReposPath    = @"repos/";
static NSString *const kAEFCommentsPath = @"/comments";

- (NSString *)commentsPathWithReportPath:(NSString *)reportPath
{
    NSString *apiPath = [reportPath stringByReplacingOccurrencesOfString:kAEFGithubBaseURL
                                                              withString:kAEFReposPath];
    apiPath = [apiPath stringByAppendingString:kAEFCommentsPath];
    
    return apiPath;
}


#pragma mark - Authentication

- (RACSignal *)authenticate
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AEFUser *cachedUser = [AEFUserCache cachedUser];
        if (cachedUser)
        {
            // Use the cached user token to autenticate
            OCTUser *user = [OCTUser userWithLogin:cachedUser.login server:OCTServer.dotComServer];
            OCTClient *client = [OCTClient authenticatedClientWithUser:user token:cachedUser.token];
            
            [subscriber sendNext:client];
            [subscriber sendCompleted];
        }
        else
        {
            [self displayLogin];
            [self setSubscriber:subscriber];
        }
        
        return nil;
    }];
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
         
         if (self.subscriber)
         {
             [self.subscriber sendNext:authenticatedClient];
             [self.subscriber sendCompleted];
             
             self.subscriber = nil;
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
    
    if (self.subscriber)
    {
        [self.subscriber sendError:error];
        self.subscriber = nil;
    }
}


@end
