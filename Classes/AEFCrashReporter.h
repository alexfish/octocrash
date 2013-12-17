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
 Returns the default crash reporter
 @returns A Singleton instance of the crash reporter
 */
+ (id)sharedReporter;

/**
 Starts the crash reporter sending any pending crash reports
 to GitHub as well as listening for new crashes
 */
- (void)startReporting;

/**
 Set the repository to send crash reports to
 @param repo The name of the repo in Github format, eg org/repo
 */
- (void)setRepo:(NSString *)repo;

@end
