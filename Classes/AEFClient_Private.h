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
 *  @param report The crash report to send
 *  @param completed A completion block called on successful issue creation
 *  @param error An error block called on failure, contains the error
 */
- (void)sendRequestWithClient:(OCTClient *)client
                       report:(PLCrashReport *)report
                    completed:(void (^)(void))completedBlock
                        error:(void (^)(NSError *error))errorBlock;

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
 *  Handles any NSError object  in an elegant manor, this can be
 *  UI feedback to the user or another attempt at authenticating
 *  with a different authentication method.
 *
 *  @param error The error to handle gracefully
 */
- (void)handleError:(NSError *)error;

@end
