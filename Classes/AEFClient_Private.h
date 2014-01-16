//
//  AEFClient_Private.h
//  OctoCrash
//
//  Created by Alex Fish on 1/15/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFClient.h"


@class OCTClient;


/**
 *  AEFClient's private method declarations, shhh.
 */
@interface AEFClient ()

/**
 Protocol properties
 */
@property (nonatomic, copy) NSString *repo;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;

/**
 Callback block fired when the client has authenticated
 */
@property (nonatomic, copy) void (^authenticated)(OCTClient *client);

/**
 *  Send a crash report request to Github via an OCTClient instance,
 *  the OCTClient should be authenticated.
 *
 *  @param client An authenticaed OCTClient instance, this method will fail
 *         if the client isn't previously authenticated.
 *
 *  @param report The crash report to send
 *  @param completion A completion block called on successful issue creation
 */
- (void)sendRequestWithClient:(OCTClient *)client
                       report:(PLCrashReport *)report
                   completion:(void (^)(BOOL sent))completion;

/**
 *  Authenticate with a login, password and one time password, it is possible to pass
 *  nil for the one time password as it is optional.
 *
 *  @param login           The users Github login
 *  @param password        The users Github password
 *  @param oneTimePassword The users Github One Time Password (Optional)
 */
- (void)authenticateLogin:(NSString *)login
                 password:(NSString *)password
          oneTimePassword:(NSString *)oneTimePassword;

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

/**
 *  Handles any NSError object  in an elegant manor, this can be 
 *  UI feedback to the user or another attempt at authenticating
 *  with a different authentication method.
 *
 *  @param error The error to handle gracefully
 */
- (void)handleError:(NSError *)error;

@end
