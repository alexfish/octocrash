//
//  AEFCrashCollecterSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 17/12/2013.
//  Copyright 2013 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <OctoCrash/OctoCrash.h>


SPEC_BEGIN(AEFCrashCollectorSpec)

describe(@"AEFCrashCollecter", ^{
    
    __block AEFCrashCollector *collector;
    
    beforeEach(^{
        collector = [[AEFCrashCollector alloc] init];
    });

});

SPEC_END
