//
//  PLCrashReport+Issues.m
//  OctoCrash
//
//  Created by Alex Fish on 1/14/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "PLCrashReport+Issues.h"
#import <OctoKit/OctoKit.h>


NSString * const AEFIssueTitleKey = @"title";
NSString * const AEFIssueBodyKey  = @"body";


@implementation PLCrashReport (Issues)


#pragma mark - Paramaters

- (NSDictionary *)parameters
{
    NSString *title = [self title];
    NSString *body = [self body];
    
    return @{AEFIssueTitleKey: title, AEFIssueBodyKey: body};
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
    return [self.title isEqualToString:issue.title];
}

@end
