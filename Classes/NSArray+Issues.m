//
//  NSArray+Issues.m
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "NSArray+Issues.h"

// Extensions
#import "PLCrashReport+Issues.h"

// Models
#import <OctoKit/OctoKit.h>


@implementation NSArray (Issues)


#pragma mark - Issues

- (NSURL *)reportURL:(PLCrashReport *)report
{
    NSURL *url = nil;
    
    for (OCTIssue *issue in self)
    {
        if ([issue isKindOfClass:[OCTIssue class]] &&
            [report isEqualToIssue:issue])
        {
            url = issue.HTMLURL;
            break;
        }
    }
    
    return url;
}

@end
