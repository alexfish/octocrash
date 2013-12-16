//
//  AEFCrashReporterSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright 2013 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AEFCrashReporter.h"


SPEC_BEGIN(AEFCrashReporterSpec)

describe(@"AEFCrashReporter", ^{
    
    it(@"should pass a stupid test", ^{
        [[theValue(YES) should] equal:theValue(YES)];
    });
    
});

SPEC_END
