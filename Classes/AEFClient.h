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


/**
 Sends/Recieves requests between octocrash and the Github API via it's
 interface.
 */
@interface AEFClient : NSObject <AEFCrashReporting>

/**
 Initialize a new client instance with a repo, client id and client secret
 @param repo
 @returns A new AEFClient instance
 */
- (id)initWithRepo:(NSString *)repo
          clientID:(NSString *)clientID
      clientSecret:(NSString *)clientSecret;

/**
 Send a crash report to Github, creating an issue on the client's
 repo, the client will attempt to authenticate itself before sending
 @param report The crash report to send to Github
 */
- (void)sendReport:(PLCrashReport *)report;

@end
