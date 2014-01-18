//
//  PLCrashReport+Issues
//  OctoCrash
//
//  Created by Alex Fish on 1/14/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <CrashReporter/CrashReporter.h>


@class OCTIssue;


extern NSString * const AEFIssueTitleKey;
extern NSString * const AEFIssueBodyKey;


/**
 A catergory on PLCrashReport to provide some additional
 functionality to handle the repoting of PLCrashReport objects
 as github issues
 */
@interface PLCrashReport (Issues)

/**
 The crash report represented as a dictionary of paramaters,
 this is useful for sending requests. 
 */
@property (nonatomic, copy, readonly) NSDictionary *parameters;

/**
 *  The crash report represented as a dictionary of paramters for a comment,
 *  this is useful for sending requests that need less information
 */
@property (nonatomic, copy, readonly) NSDictionary *commentParameters;

/**
 *  The crash reports user friendly title, contains the excaption name and reason.
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 *  The crash reports user friedly body, contains a lot of crash information and
 *  stack trace.
 */
@property (nonatomic, copy, readonly) NSString *body;

/**
 *  Returns a BOOL indicator if the OCTIssue object matches the crash report 
 *  and represents the same crash.
 *
 *  @param issue The issue object to query for a match
 *
 *  @return A BOOL indicating if there is a match
 */
- (BOOL)isEqualToIssue:(OCTIssue *)issue;

@end
