//
//  AEFCrashReporter.h
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AEFCrashCollector;


/**
 The front of house of OctoCrash, all IO should go through this class via the 
 available interface.
 */
@interface AEFCrashReporter : NSObject

/**
 The Github repository to report crashes to, in the format org/name or user/name
 E.g alexfish/octocrash
 */
@property (nonatomic, copy, readonly) NSString *repo;

/**
 Github OAuth application client ID
 */
@property (nonatomic, copy, readonly) NSString *clientID;

/**
 Githuv OAuth application client secret
 */
@property (nonatomic, copy, readonly) NSString *clientSecret;

/**
 Returns the default crash reporter
 @returns A Singleton instance of the crash reporter
 */
+ (id)sharedReporter;

/**
 Configure the reporter ready for crash reporting, this method should
 be called before starting the reporter
 
 @param repo The repo to send crash reports to, in the format user/name org/name
 @param clientID The Github OAuth application client ID
 @param clientSecret The Github OAuth application client secret
 */
- (void)configureRepo:(NSString *)repo
             clientID:(NSString *)clientID
         clientSecret:(NSString *)clientSecret;

/**
 Starts the crash reporter sending any pending crash reports
 to GitHub as well as listening for new crashes. Configuration
 options should be set before starting any reporting.
 */
- (void)startReporting;

@end
