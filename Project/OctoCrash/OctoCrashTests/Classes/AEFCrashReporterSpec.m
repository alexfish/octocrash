//
//  AEFCrashReporterSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright 2013 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <OctoCrash/OctoCrash.h>

SPEC_BEGIN(AEFCrashReporterSpec)

describe(@"AEFCrashReporter", ^{

    __block AEFCrashReporter *reporter;
    
    beforeEach(^{
        reporter = [AEFCrashReporter sharedReporter];
    });
    
    context(@"public interface", ^{
        
        it(@"should conform to the the crash reporter protocol", ^{
            [[reporter should] conformToProtocol:@protocol(AEFCrashReporting)];
        });
        
        it(@"should have a repo", ^{
            [[reporter should] respondToSelector:@selector(repo)];
        });
        
        it(@"should have a clientID", ^{
            [[reporter should] respondToSelector:@selector(clientID)];
        });
        
        it(@"should have a client secret", ^{
            [[reporter should] respondToSelector:@selector(clientSecret)];
        });
    });
    
    context(@"when configuring", ^{
        
        beforeEach(^{
            [reporter configureRepo:@"repo" clientID:@"id" clientSecret:@"secret"];
        });
        
        it(@"should set a repo", ^{
            [[reporter.repo should] equal:@"repo"];
        });
        
        it(@"should set a clientID", ^{
            [[reporter.clientID should] equal:@"id"];
        });
        
        it(@"should set a clientSecret", ^{
            [[reporter.clientSecret should] equal:@"secret"];
        });
    });
});

SPEC_END
