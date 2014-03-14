//
//  AEFCrashReporter.h
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocol
#import "AEFCrashReporting.h"


@class AEFCrashCollector;

/**
 The front of house of OctoCrash, all IO should go through this class via the 
 available interface.
 */
@interface AEFCrashReporter : NSObject <AEFCrashReporting>

/**
 *  An array of labels to attach to any crash reports, these labels
 *  will be attached to each new GitHub issue created for a report
 */
@property (nonatomic, copy) NSArray *labels;

/**
 Returns the default crash reporter
 @returns A Singleton instance of the crash reporter
 */
+ (id)sharedReporter __attribute__((const));

/**
 Configure the reporter ready for crash reporting, this method should
 be called before starting the reporter
 
 @param repo The repo to send crash reports to, in the format user/name org/name
 @param clientID The Github OAuth application client ID
 @param clientSecret The Github OAuth application client secret
 */
- (void)setRepo:(NSString *)repo
       clientID:(NSString *)clientID
   clientSecret:(NSString *)clientSecret;

/**
 Starts the crash reporter sending any pending crash reports
 to GitHub as well as listening for new crashes. Configuration
 options should be set before starting any reporting.
 */
- (void)startReporting;

@end
