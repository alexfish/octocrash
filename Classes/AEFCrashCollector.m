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

- (PLCrashReport *)pendingReport
{
    PLCrashReporter *reporter = [PLCrashReporter sharedReporter];
    PLCrashReport *pendingReport = nil;
    
    if ([reporter hasPendingCrashReport])
    {
        NSData *crashData = [reporter loadPendingCrashReportData];
        pendingReport = [[PLCrashReport alloc] initWithData:crashData error:nil];
    }
    
    return pendingReport;
}

- (void)purge
{
    [[PLCrashReporter sharedReporter] purgePendingCrashReport];
}

@end
