//
//  PLCrashReport_IssueSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 14/01/2014.
//  Copyright 2014 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "PLCrashReport+Issues.h"
#import <OctoKit/OctoKit.h>

SPEC_BEGIN(PLCrashReport_IssueSpec)

describe(@"PLCrashReport_Issue", ^{
    
    __block PLCrashReport *report;
    __block NSString *crashName;
    __block NSString *crashReason;
    
    beforeEach(^{
       
        report = [[PLCrashReport alloc] init];
        crashName = @"Test Crash";
        crashReason = @"Somehting Happened";
        
        PLCrashReportExceptionInfo *exceptionInfo = [PLCrashReportExceptionInfo mock];
        [exceptionInfo stub:@selector(stackFrames) andReturn:@[]];
        [exceptionInfo stub:@selector(exceptionName) andReturn:crashName];
        [exceptionInfo stub:@selector(exceptionReason) andReturn:crashReason];
        [report stub:@selector(exceptionInfo) andReturn:exceptionInfo];
        
    });
    
    context(@"when returning paramaters", ^{
        
        it(@"should contain a title", ^{
            [[[[report parameters] objectForKey:AEFIssueTitleKey] should] beNonNil];
        });
        
        it(@"should contain a body", ^{
            [[[[report parameters] objectForKey:AEFIssueBodyKey] should] beNonNil];
        });
        
        it(@"should contain the crash name in the title", ^{
            [[[[report parameters] objectForKey:AEFIssueTitleKey] should] containString:crashName];
        });
        
        it(@"should contain the crash reason in the title", ^{
            [[[[report parameters] objectForKey:AEFIssueTitleKey] should] containString:crashReason];
        });
        
        it(@"should prepend an opening pre tag for nicer reading", ^{
            [[[[report parameters] objectForKey:AEFIssueBodyKey] should] containString:@"<pre>"];
        });
        
        it(@"should append a closing pre tag for nicer reading", ^{
            [[[[report parameters] objectForKey:AEFIssueBodyKey] should] containString:@"</pre>"];
        });
    });
    
    context(@"when matching issues", ^{
       
        it(@"should match if the titles are the same'", ^{
            [report stub:@selector(title) andReturn:@"Test Crash"];
            OCTIssue *issue = [OCTIssue mock];
            [issue stub:@selector(title) andReturn:@"Test Crash"];
            
            [[theValue([report isEqualToIssue:issue]) should] beYes];
        });
    });
    
});

SPEC_END
