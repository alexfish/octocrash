//
//  AEFCrashCollector.h
//  OctoCrash
//
//  Created by Alex Fish on 17/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLCrashReport;


/**
 The crash collector collects crash reports, the interface 
 provides methods to return any reports that have been 
 collected. Crashes are collected using PLCrashReporter
 */
@interface AEFCrashCollector : NSObject

/**
 Start collecting crashes
 */
- (void)startCollecting;

/**
 Return a pending crash report if any are present, if there
 are no pending reports then nil will be returned.
 @returns A pending crash report
 */
- (PLCrashReport *)pendingReport;

/**
 Purge any pending crash reports never to be seen again.
 */
- (void)purge;

@end
