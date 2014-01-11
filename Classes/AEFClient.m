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


// Class extension
@interface AEFClient () <UIAlertViewDelegate>

/**
 Protocol properties
 */
@property (nonatomic, copy) NSString *repo;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;

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
        
        [self authenticate];
    }
    
    return self;
}


#pragma mark - Reports

- (void)sendReport:(PLCrashReport *)report
{}


#pragma mark - Authentication (Private)

- (void)authenticate
{
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
    
    [OCTClient setClientID:self.clientID clientSecret:self.clientSecret];
    [[OCTClient signInAsUser:octoUser
                    password:user.password
             oneTimePassword:nil
                      scopes:OCTClientAuthorizationScopesUser]
     subscribeNext:^(OCTClient *authenticatedClient) {
         // Authentication was successful. Do something with the created client.
         NSLog(@"Signed in!");
     } error:^(NSError *error) {
         // Authentication failed.
         NSLog(@"Error: %@", error);
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
