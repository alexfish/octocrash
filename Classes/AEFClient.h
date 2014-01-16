//
//  AEFClient.h
//  OctoCrash
//
//  Created by Alex Fish on 17/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol
#import "AEFCrashReporting.h"


@class PLCrashReport;
@class OCTClient;


/**
 Sends/Recieves requests between octocrash and the Github API via it's
 interface.
 */
@interface AEFClient : NSObject <AEFCrashReporting>

/**
 *  Initialize a new client instance with a repo, client id and client secret
 *
 *  @param repo         A Github repo and org or user in the format "org/repo"
 *  @param clientID     Github application client ID to use for authentication
 *  @param clientSecret Github application client secret to use for authentication
 *
 *  @return A new AEFClient instance
 */
- (id)initWithRepo:(NSString *)repo
          clientID:(NSString *)clientID
      clientSecret:(NSString *)clientSecret;

/**
 *  Send a crash report to Github, creating an issue on the client's
 *  repo, the client will attempt to authenticate itself before sending
 *
 *  @param report     The crash report to send to Github
 *  @param client     An authenticated client instance 
 *  @param completion A completion block called on success or failure
 */
- (void)sendReport:(PLCrashReport *)report
            client:(OCTClient *)client
        completion:(void (^)(BOOL sent))completion;


/**
 *  Authenticate with the Github API, this method will also check the user cache for
 *  any previously authenticated users, if you do not wish to authenticate with the
 *  the cached user then clear the cache before calling this method.
 *
 *  @param completion A completion callback which contains an authenticated instance
 *         of an OCTClient, you can query the OCTClient using it's authenticated method
 *         to check it really is authenticated.
 */
- (void)authenticate:(void (^)(OCTClient *client))completion;

@end
