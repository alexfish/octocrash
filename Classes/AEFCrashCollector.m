//
//  AEFCrashCollector.m
//  OctoCrash
//
//  Created by Alex Fish on 17/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "AEFCrashCollector.h"

// Models
#import <CrashReporter/CrashReporter.h>


@implementation AEFCrashCollector


#pragma mark - Collecting

- (void)startCollecting
{
    [[PLCrashReporter sharedReporter] enableCrashReporter];
}

@end
