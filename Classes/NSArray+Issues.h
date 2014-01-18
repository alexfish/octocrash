//
//  NSArray+Issues.h
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PLCrashReport;


/**
 *  A Category to provide issue specific functionality to arrays
 */
@interface NSArray (Issues)


/**
 *  Search an array for a crash report's URL, the array should contain
 *  OCTIssue objects for the best chance of finding a valid URL
 *
 *  @param report A crash report object to check the array for
 *
 *  @return A NSURL for the report on an external service
 */
- (NSURL *)reportURL:(PLCrashReport *)report;

@end
