//
//  AEFClientSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 18/12/2013.
//  Copyright 2013 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AEFClient_Private.h"
#import <CrashReporter/CrashReporter.h>
#import <OctoKit/OctoKit.h>
#import "PLCrashReport+Issues.h"
#import "NSError+AEFErrors.h"


SPEC_BEGIN(AEFClientSpec)

describe(@"AEFClient", ^{
    
    __block AEFClient *client;
    
    context(@"public interface", ^{
        
        beforeEach(^{
            client = [[AEFClient alloc] init];
        });
        
        it(@"should conform to the reporting protocol", ^{
            [[client should] conformToProtocol:@protocol(AEFCrashReporting)];
        });
    });
    
    context(@"when initialized", ^{
       
        beforeEach(^{
            client = [[AEFClient alloc] initWithRepo:@"repo"
                                            clientID:@"id"
                                        clientSecret:@"secret"];
        });
        
        it(@"should have a repo", ^{
            [[client.repo should] equal:@"repo"];
        });
        
        it(@"should have a clientID", ^{
            [[client.clientID should] equal:@"id"];
        });
        
        it(@"should have a client secret", ^{
            [[client.clientSecret should] equal:@"secret"];
        });
    });
    
    context(@"when sending reports", ^{
       
        it(@"should send them if authenticated", ^{
            OCTClient *mockClient = [OCTClient mock];
            [mockClient stub:@selector(isAuthenticated) andReturn:theValue(YES)];
            
            PLCrashReport *report = [PLCrashReport mock];
            [report stub:@selector(parameters)];
            
            [[client should] receive:@selector(sendRequestWithClient:report:completed:error:)];
            [client sendReport:report client:mockClient completed:nil error:nil];
        });
        
    });
    
    context(@"when getting reports", ^{
        
        __block PLCrashReport *report;
        __block OCTClient *mockClient;
        __block KWCaptureSpy *completeSpy;
        __block NSURL *fakeURL;
        __block OCTResponse *mockResponse;
        
        beforeEach(^{
            report = [PLCrashReport mock];
            [report stub:@selector(title)];
            
            mockClient = [OCTClient mock];
            [client stub:@selector(getRequestWithClient:completed:error:)];
            
            fakeURL = [NSURL URLWithString:@"testURL"];
            
            mockResponse = [OCTResponse mock];
            OCTIssue *mockIssue = [OCTIssue mock];
            [mockIssue stub:@selector(HTMLURL) andReturn:fakeURL];
            [mockIssue stub:@selector(title)];
            [mockResponse stub:@selector(parsedResult) andReturn:mockIssue];
            
            completeSpy = [client captureArgument:@selector(getRequestWithClient:completed:error:) atIndex:1];
        });
        
        it(@"should get a report url if it exists'", ^{
            [report stub:@selector(isEqualToIssue:) andReturn:theValue(YES)];
            [mockClient stub:@selector(isAuthenticated) andReturn:theValue(YES)];
            
            [client getReport:report client:mockClient completed:^(NSURL *reportURL) {
                [[reportURL should] equal:fakeURL];
            } error:nil];
            
            void *(^complete)(NSArray *issues) = completeSpy.argument;
            complete(@[mockResponse]);
        });
        
        it(@"should not get a report id if not authenticated", ^{
            [mockClient stub:@selector(isAuthenticated) andReturn:theValue(NO)];
            
            [client getReport:report client:mockClient completed:nil error:^(NSError *error) {
                [[theValue(error.code) should] equal:theValue(AEFErrorCodeAuthFailed)];
            }];
        });
        
        it(@"should not get a report id that doesn't exist", ^{
            [report stub:@selector(isEqualToIssue:) andReturn:theValue(NO)];
            
            [mockClient stub:@selector(isAuthenticated) andReturn:theValue(YES)];
            
            [client getReport:report client:mockClient completed:nil error:^(NSError *error) {
                [[theValue(error.code) should] equal:theValue(AEFErrorCodeNotFound)];
            }];
            
            void *(^complete)(NSArray *issues) = completeSpy.argument;
            complete(@[mockResponse]);
        });
    });
    
});

SPEC_END
