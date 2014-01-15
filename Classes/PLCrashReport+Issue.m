//
//  PLCrashReport+Issue.m
//  OctoCrash
//
//  Created by Alex Fish on 1/14/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "PLCrashReport+Issue.h"


NSString * const AEFIssueTitleKey = @"title";
NSString * const AEFIssueBodyKey  = @"body";


@implementation PLCrashReport (AEFIssue)


#pragma mark - Paramaters

- (NSDictionary *)parameters
{
    NSString *title = [self title];
    NSString *body = @"Test Body";
    
    return @{AEFIssueTitleKey: title, AEFIssueBodyKey: body};
}


#pragma mark - Paramaters (Private)

- (NSString *)title
{
    return [NSString stringWithFormat:@"Crash: %@", self.exceptionInfo.exceptionName];
}

@end
