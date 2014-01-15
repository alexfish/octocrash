//
//  PLCrashReport+Issue
//  OctoCrash
//
//  Created by Alex Fish on 1/14/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <CrashReporter/CrashReporter.h>

/**
 A catergory on PLCrashReport to provide some additional
 functionality to handle the repoting of PLCrashReport objects
 as github issues
 */
@interface PLCrashReport (Issue)

/**
 The crash report represented as a dictionary of paramaters,
 this is useful for sending requests. 
 */
@property (nonatomic, copy, readonly) NSDictionary *parameters;

@end
