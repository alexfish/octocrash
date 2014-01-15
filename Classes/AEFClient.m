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


// Types
NS_ENUM(NSInteger, AEFAlertViewType)
{
    AEFAlertViewTypeDefault         = 0,
    AEFAlertViewTypeOneTimePassword = 1,
};


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


#pragma mark - Reports (Private)

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
    AEFUser *cachedUser = [AEFUserCache cachedUser];
    if (cachedUser)
    {
        // Use the cached user token to autenticate
        OCTUser *user = [OCTUser userWithLogin:cachedUser.login server:OCTServer.dotComServer];
        OCTClient *client = [OCTClient authenticatedClientWithUser:user token:cachedUser.token];
        
        completion(YES, client);
    }
    else
    {
        [self setAuthenticated:completion];
        [self displayLogin];
    }
}

- (void)authenticateLogin:(NSString *)login
                 password:(NSString *)password
          oneTimePassword:(NSString *)oneTimePassword
{
    OCTUser *user = [OCTUser userWithLogin:login
                                    server:OCTServer.dotComServer];
    
    __weak typeof(self) weakSelf = self;
    [OCTClient setClientID:self.clientID clientSecret:self.clientSecret];
    [[OCTClient signInAsUser:user
                    password:password
             oneTimePassword:oneTimePassword
                      scopes:OCTClientAuthorizationScopesUser]
     subscribeNext:^(OCTClient *authenticatedClient) {
         
         AEFUser *authenticatedUser = [[AEFUser alloc] initWithLogin:login token:authenticatedClient.token];
         [AEFUserCache cacheUser:authenticatedUser];
         
         typeof (self) __strong strongSelf = weakSelf;
         if (!strongSelf) return;
         
         if (strongSelf.authenticated)
         {
             strongSelf.authenticated(YES, authenticatedClient);
         }
     } error:^(NSError *error) {
         typeof (self) __strong strongSelf = weakSelf;
         if (!strongSelf) return;
         
         if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired)
         {
             [strongSelf displayOneTimePasswordLogin];
         }
         else
         {
            [AEFUserCache clearCache];
            [strongSelf displayAuthError];
         }
     }];
}


#pragma mark - Login UI (Private)

- (void)displayOneTimePasswordLogin
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alertView setDelegate:self];
    [alertView setTitle:NSLocalizedString(@"LOGIN_OTP_TITLE", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"LOGIN_ALERT_BUTTON_TITLE", nil)];
    [alertView setTag:AEFAlertViewTypeOneTimePassword];
    [alertView show];

}

- (void)displayLogin
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView setDelegate:self];
    [alertView setTitle:NSLocalizedString(@"LOGIN_ALERT_TITLE", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"LOGIN_ALERT_BUTTON_TITLE", nil)];
    [alertView setTag:AEFAlertViewTypeDefault];
    [alertView show];
}

- (void)displayAuthError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGIN_FAILED_TITLE", nil)
                                                        message:NSLocalizedString(@"LOGIN_FAILED_MESSAGE", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"LOGIN_OK_TITLE", nil), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    static NSString *login = nil;
    static NSString *password = nil;
    
    // if there is a text field at this index then we know it's a normal
    // login UI
    if (alertView.tag == AEFAlertViewTypeDefault)
    {
        login     = [[alertView textFieldAtIndex:0] text];
        password  = [[alertView textFieldAtIndex:1] text];
        
        [self authenticateLogin:login password:password oneTimePassword:nil];
    }
    else
    {
        NSString *oneTimePassword = [[alertView textFieldAtIndex:0] text];
        
        [self authenticateLogin:login password:password oneTimePassword:oneTimePassword];
    }
    
}

@end
