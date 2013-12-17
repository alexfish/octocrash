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

@end
