//
//  NSArray_IssuesSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright 2014 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSArray+Issues.h"
#import "PLCrashReport+Issues.h"
#import <OctoKit/OctoKit.h>


SPEC_BEGIN(NSArray_IssuesSpec)

describe(@"NSArray_Issues", ^{
    
    context(@"when searching for reports", ^{
       
        __block NSArray *array;
        __block PLCrashReport *report;
        
        beforeEach(^{
            OCTIssue *issue = [[OCTIssue alloc] init];
            OCTResponse *response = [OCTResponse mock];
            [response stub:@selector(parsedResult) andReturn:issue];
            
            [issue stub:@selector(HTMLURL) andReturn:[NSURL URLWithString:@"testURL"]];
            array = @[response];
            
            report = [[PLCrashReport alloc] init];
        });
        
        it(@"should match if an issue matching is in the array", ^{
            [report stub:@selector(isEqualToIssue:) andReturn:theValue(YES)];

            [[[[array reportURL:report] absoluteString] should] equal:@"testURL"];
        });
        
        it(@"should not match if the array contains other objects", ^{
            array = @[@1];
            
            [[[array reportURL:report] should] beNil];
        });
    });
});

SPEC_END
