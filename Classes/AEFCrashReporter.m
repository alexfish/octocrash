//
//  AEFCrashReporter.m
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "AEFCrashReporter.h"

// Models
#import "AEFCrashCollector.h"


// Class Extension
@interface AEFCrashReporter ()
/**
 The collector collects crashes..
 */
@property (nonatomic, strong) AEFCrashCollector *collector;
@end


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

- (id)init
{
    self = [super init];
    if (self)
    {
        self.collector = [[AEFCrashCollector alloc] init];
    }
    
    return self;
}

#pragma mark - Reporting

- (void)startReporting
{
    [self.collector startCollecting];
}


#pragma mark - Setup

- (void)setRepo:(NSString *)repo
{
    NSLog(@"%@", repo);
}

@end
