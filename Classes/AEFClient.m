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
    // if there is no user/pass stored then
    [self displayLogin];
}

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
    __unused NSString *username = [[alertView textFieldAtIndex:0] text];
    __unused NSString *password = [[alertView textFieldAtIndex:1] text];
    
    [OCTClient setClientID:self.clientID clientSecret:self.clientSecret];
}

@end
