//
//  AEFClient+Login.m
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFClient+Login.h"
#import "AEFClient_Private.h"
#import <UIKit/UIKit.h>


@implementation AEFClient (Login)


#pragma mark - Login UI (Private)

- (void)displayOneTimePasswordLogin
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alertView setDelegate:self];
    [alertView setTitle:AEFLocalizedString(@"LOGIN_OTP_TITLE", nil)];
    [alertView addButtonWithTitle:AEFLocalizedString(@"LOGIN_CANCEL_TITLE", nil)];
    [alertView addButtonWithTitle:AEFLocalizedString(@"LOGIN_ALERT_BUTTON_TITLE", nil)];
    [alertView setTag:AEFAlertViewTypeOneTimePassword];
    [alertView show];
    
}

- (void)displayLogin
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView setDelegate:self];
    [alertView setTitle:AEFLocalizedString(@"LOGIN_ALERT_TITLE", nil)];
    [alertView setMessage:AEFLocalizedString(@"LOGIN_ALERT_MESSAGE", nil)];
    [alertView addButtonWithTitle:AEFLocalizedString(@"LOGIN_CANCEL_TITLE", nil)];
    [alertView addButtonWithTitle:AEFLocalizedString(@"LOGIN_ALERT_BUTTON_TITLE", nil)];
    [alertView setTag:AEFAlertViewTypeDefault];
    [alertView show];
}

- (void)displayAuthError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AEFLocalizedString(@"LOGIN_FAILED_TITLE", nil)
                                                        message:AEFLocalizedString(@"LOGIN_FAILED_MESSAGE", nil)
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:AEFLocalizedString(@"LOGIN_OK_TITLE", nil), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return; // Cancel button
    
    static NSString *login = nil;
    static NSString *password = nil;
    
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
