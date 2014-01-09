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
            user = [[AEFUser alloc] initWithUsername:@"testname" password:@"testpass"];
        });
        
        it(@"should assign a username", ^{
            [[user.username should] equal:@"testname"];
        });
        
        it(@"should assign a password", ^{
            [[user.password should] equal:@"testpass"];
        });
    });
});

SPEC_END
