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

// Extensions
#import "PLCrashReport+Issue.h"


// Class extension
@interface AEFClient () <UIAlertViewDelegate>

/**
 Protocol properties
 */
@property (nonatomic, copy) NSString *repo;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;

/**
 Callback block fired when the client has authenticated
 */
@property (nonatomic, copy) void (^authenticated)(BOOL authenticated, OCTClient *client);

@end


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
    }
    
    return self;
}


#pragma mark - Reports

- (void)sendReport:(PLCrashReport *)report
{
    __weak typeof(self) weakSelf = self;
    [self authenticate:^(BOOL authenticated, OCTClient *client) {
        if (authenticated)
        {
            typeof (self) __strong strongSelf = weakSelf;
            if (!strongSelf) return;
            
            strongSelf.authenticated = nil;
            [strongSelf sendRequest:client report:report];
        }
    }];
}

- (void)sendRequest:(OCTClient *)client report:(PLCrashReport *)report
{
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                        path:[NSString stringWithFormat:@"repos/%@/issues", self.repo]
                                                  parameters:report.parameters notMatchingEtag:nil];
    
    RACSignal *signal = [client enqueueRequest:request resultClass:[OCTIssue class]];
    [signal subscribeNext:^(OCTIssue *issue) {
        NSLog(@"%@", issue);
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"COMPLETE");
    }];
}


#pragma mark - Authentication (Private)

- (void)authenticate:(void (^)(BOOL authenticated, OCTClient *client))completion
{
    // Ready the completion block
    [self setAuthenticated:completion];
    
    AEFUser *user = [AEFUserCache cachedUser];
    if (user)
    {
        [self authenticateUser:user];
    }
    else
    {
        [self displayLogin];
    }
}

- (void)authenticateUser:(AEFUser *)user
{
    OCTUser *octoUser = [OCTUser userWithLogin:user.username
                                        server:OCTServer.dotComServer];
    
    __weak typeof(self) weakSelf = self;
    [OCTClient setClientID:self.clientID clientSecret:self.clientSecret];
    [[OCTClient signInAsUser:octoUser
                    password:user.password
             oneTimePassword:nil
                      scopes:OCTClientAuthorizationScopesUser]
     subscribeNext:^(OCTClient *authenticatedClient) {
         [AEFUserCache cacheUser:user];
         
         typeof (self) __strong strongSelf = weakSelf;
         if (!strongSelf) return;
         
         if (strongSelf.authenticated)
         {
             strongSelf.authenticated(YES, authenticatedClient);
         }
     } error:^(NSError *error) {
         [AEFUserCache clearCache];
         
         typeof (self) __strong strongSelf = weakSelf;
         if (!strongSelf) return;
         
         [strongSelf displayLogin];
     }];
}


#pragma mark - Login UI (Private)

- (void)displayLogin
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView setDelegate:self];
    [alertView setTitle:NSLocalizedString(@"LOGIN_ALERT_TITLE", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"LOGIN_ALERT_BUTTON_TITLE", nil)];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *username = [[alertView textFieldAtIndex:0] text];
    NSString *password = [[alertView textFieldAtIndex:1] text];
    
    AEFUser *user = [[AEFUser alloc] initWithUsername:username password:password];
    
    [self authenticateUser:user];
}

@end
