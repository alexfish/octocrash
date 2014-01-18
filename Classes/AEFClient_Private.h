//
//  AEFClient_Private.h
//  OctoCrash
//
//  Created by Alex Fish on 1/15/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFClient.h"


@class OCTClient;


static NSString * const kAEFGithubBaseURL = @"https://github.com/";


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
 *  Send a request to Github via an authentivated OCTIstance.
 *
 *  @param client         An authenticaed OCTClient instance, this method will fail
 *                        if the client isn't previously authenticated.
 *  @param path           The path to request relative to the base API URL
 *  @param method         The HTTP method to use
 *  @param paramaters     A dictionary of paramaters to send with the request
 *  @param completedBlock A completion block containing the response
 *  @param errorBlock     A completion block containing any errors
 */
- (void)requestWithClient:(OCTClient *)client
                     path:(NSString *)path
                   method:(NSString *)method
               parameters:(NSDictionary *)paramaters
                completed:(void (^)(id response))completedBlock
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

/**
 *  The API path for Github issues
 *
 *  @return The API path ready to use with OCTClient requests for issues
 */
- (NSString *)issuesPath;

/**
 *  Convert a report's URL to a Github API ready comments path, this will use elements
 *  of the reports existing path to generate an API URL for adding comments to the report
 *
 *  @param reportPath The report full github path to a github issue
 *  to generate a comments path with
 *
 *  @return A path for comments based on the report path.
 */
- (NSString *)commentsPathWithReportPath:(NSString *)reportPath;

@end
