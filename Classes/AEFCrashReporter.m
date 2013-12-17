//
//  AEFCrashReporter.m
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "AEFCrashReporter.h"

// Models
#import <CrashReporter/CrashReporter.h>


@implementation AEFCrashReporter


#pragma mark - Init

+ (id)sharedReporter
{
    static AEFCrashReporter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startReporting
{
    NSLog(@"Started");
}


#pragma mark - Setup

- (void)setRepo:(NSString *)repo
{
    NSLog(@"%@", repo);
}

@end
