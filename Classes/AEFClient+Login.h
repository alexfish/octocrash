//
//  AEFClient+Login.h
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFClient.h"


// Types
NS_ENUM(NSInteger, AEFAlertViewType)
{
    AEFAlertViewTypeDefault         = 0,
    AEFAlertViewTypeOneTimePassword = 1,
};


/**
 *  A category to provide additional Login functionality to AEFClient
 */
@interface AEFClient (Login)

/**
 *  Display the UI for a user to enter their one time password.
 */
- (void)displayOneTimePasswordLogin;

/**
 *  Display the UI for a user to enter their standard Github login
 *  and password.
 */
- (void)displayLogin;

/**
 *  Display the UI for an authentication error, containing imformation
 *  as to why the authentication failed.
 */
- (void)displayAuthError;

@end
