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
@class RACSignal;


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
 *
 *  @return An RACSignal that will create the report then complete on success or error on
 *          faiure.
 */
- (RACSignal *)createReport:(PLCrashReport *)report client:(OCTClient *)client;

/**
 *  Load an existing report from Github, this method is used to query Github
 *  for an existing crash report, if one is found then the report ID will be
 *  returned in the completion block
 *
 *  @param report     The crash report to use to find if the report is already reported
 *  @param client     An authenticated client instance
 *
 *  @return An RACSignal that will send the report then complete on success or error on 
 *          faiure.
 */
- (RACSignal *)loadReport:(PLCrashReport *)report
                   client:(OCTClient *)client;

/**
 *  Update a report with an existing issue at a given path, this can be useful if a crash already
 *  exists so that a duplicate issue is not created.
 *
 *  @param report         The crash report to update
 *  @param path           The full Github URL path of the report to update,
 *                        e.g: https://github.com/alexfish/octocrash/issues/1
 *  @param client         An authenticated client instance
 *
 *  @retrun An RACSignal what will complete on succes or error on failure.
 */
- (RACSignal *)updateReport:(PLCrashReport *)report
                       path:(NSString *)path
                     client:(OCTClient *)client;

/**
 *  Authenticate with the Github API, this method will also check the user cache for
 *  any previously authenticated users, if you do not wish to authenticate with the
 *  the cached user then clear the cache before calling this method.
 *
 *  @return An RACSignal that will send an authenticated OCTClient instance then complete
 *          on success or error on failure
 */
- (RACSignal *)authenticate;

@end
