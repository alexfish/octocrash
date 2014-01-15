//
//  AEFUserSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 09/01/2014.
//  Copyright 2014 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AEFUser.h"


SPEC_BEGIN(AEFUserSpec)

describe(@"AEFUser", ^{
    
    __block AEFUser *user;
    
    context(@"when initialized", ^{
        
        beforeEach(^{
            user = [[AEFUser alloc] initWithLogin:@"testname" token:@"testpass"];
        });
        
        it(@"should assign a username", ^{
            [[user.login should] equal:@"testname"];
        });
        
        it(@"should assign a password", ^{
            [[user.token should] equal:@"testpass"];
        });
    });
});

SPEC_END
