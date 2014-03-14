//
//  PLCrashReport+Issues.m
//  OctoCrash
//
//  Created by Alex Fish on 1/14/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "PLCrashReport+Issues.h"

// Frameworks
#import <OctoKit/OctoKit.h>

// Models
#import "AEFStrings.h"

// Extensions
#import "EXTSynthesize.h"


// Strings
NSString * const AEFIssueTitleKey = @"title";
NSString * const AEFIssueBodyKey  = @"body";
NSString * const AEFLabelsKey     = @"labels";


@implementation PLCrashReport (Issues)

@synthesizeAssociation(PLCrashReport, labels);


#pragma mark - Paramaters

- (NSDictionary *)parameters
{
    NSString *title     = [self title];
    NSString *body      = [self body];
    NSArray *labels     = [NSArray arrayWithArray:self.labels]; // never nil

    return @{AEFIssueTitleKey: title, AEFIssueBodyKey: body, AEFLabelsKey: labels};
}

- (NSDictionary *)commentParameters
{
    NSString *body = [NSString stringWithFormat:AEFLocalizedString(@"CRASH_COMMENT_BODY", nil), [self title]];
    
    return @{AEFIssueBodyKey: body};
}


#pragma mark - Paramaters (Private)

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@: %@",
            self.exceptionInfo.exceptionName,
            self.exceptionInfo.exceptionReason];
}

- (NSString *)body
{
    NSString *humanReadable = [PLCrashReportTextFormatter stringValueForCrashReport:self
                                                                     withTextFormat:PLCrashReportTextFormatiOS];
    humanReadable = [NSString stringWithFormat:@"<pre>%@</pre>", humanReadable];
    
    return humanReadable;
}


#pragma mark - Matching

- (BOOL)isEqualToIssue:(OCTIssue *)issue
{
    BOOL isEqual = NO;
    
    if ([issue isKindOfClass:[OCTIssue class]])
    {
        isEqual = [self.title isEqualToString:issue.title];
    }
    
    return isEqual;
}

@end
