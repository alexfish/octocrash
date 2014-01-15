//
//  PLCrashReport_IssueSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 14/01/2014.
//  Copyright 2014 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "PLCrashReport+Issue.h"


SPEC_BEGIN(PLCrashReport_IssueSpec)

describe(@"PLCrashReport_Issue", ^{
    
    __block PLCrashReport *report;
    __block NSString *crashName;
    
    beforeEach(^{
       
        report = [[PLCrashReport alloc] init];
        crashName = @"Test Crash";
        
        PLCrashReportExceptionInfo *exceptionInfo = [PLCrashReportExceptionInfo mock];
        [exceptionInfo stub:@selector(exceptionName) andReturn:crashName];
        [report stub:@selector(exceptionInfo) andReturn:exceptionInfo];
        
    });
    
    context(@"when returning paramaters", ^{
        
        it(@"should contain a title", ^{
            [[[[report parameters] objectForKey:AEFIssueTitleKey] should] beNonNil];
        });
        
        it(@"should contain a body", ^{
            [[[[report parameters] objectForKey:AEFIssueBodyKey] should] beNonNil];
        });
        
        it(@"should contain a user friendly title", ^{
            NSString *friendlyTitle = [NSString stringWithFormat:@"Crash: %@", crashName];
            [[[[report parameters] objectForKey:AEFIssueTitleKey] should] equal:friendlyTitle];
        });
    });
    
});

SPEC_END
