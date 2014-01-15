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
       
        it(@"should send them if authenticated successfully", ^{
            OCTClient *mockClient = [OCTClient mock];
            [mockClient stub:@selector(isAuthenticated) andReturn:theValue(YES)];
            KWCaptureSpy *spy = [client captureArgument:@selector(authenticate:) atIndex:0];
            
            [[client should] receive:@selector(sendRequest:report:)];
            [client sendReport:[PLCrashReport mock]];
            
            void *(^complete)(OCTClient *client) = spy.argument;
            complete(mockClient);
        });
        
    });
    
});

SPEC_END
