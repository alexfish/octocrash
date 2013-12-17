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

    it(@"should start", ^{
        [[[AEFCrashReporter sharedReporter] should] respondToSelector:@selector(startReporting)];
    });
    
});

SPEC_END
