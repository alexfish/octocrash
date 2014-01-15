//
//  PLCrashReport+Issue.m
//  OctoCrash
//
//  Created by Alex Fish on 1/14/14.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "PLCrashReport+Issue.h"

@implementation PLCrashReport (AEFIssue)


#pragma mark - Paramaters

- (NSDictionary *)parameters
{
    NSString *title = @"Test Title";
    NSString *body = @"Test Body";
    
    return @{@"title": title, @"body": body};
}

@end
