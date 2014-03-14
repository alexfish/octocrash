//
//  AEFCrashReporter_Private.h
//  OctoCrash
//
//  Created by Alex Fish on 14/03/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFCrashReporter.h"

/**
 *  Private class extension
 */
@interface AEFCrashReporter ()

/**
 The collector collects crashes..
 */
@property (nonatomic, strong) AEFCrashCollector *collector;

/**
 The client sends crash reports to Github
 */
@property (nonatomic, strong) AEFClient *client;

/**
 Protocol properties
 */
@property (nonatomic, copy) NSString    *repo;
@property (nonatomic, copy) NSString    *clientID;
@property (nonatomic, copy) NSString    *clientSecret;

/**
 *  Send a crash report to GitHub creating an issue, if the report
 *  has already been reported then a comment will be added to the existing
 *  issue.
 *
 *  @param report The report to send to GitHub
 */
- (void)sendReport:(PLCrashReport *)report;

@end
