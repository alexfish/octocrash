//
//  AEFUserCacheSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 11/01/2014.
//  Copyright 2014 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AEFUserCache.h"
#import "SSKeychain.h"
#import "AEFUser.h"


SPEC_BEGIN(AEFUserCacheSpec)

describe(@"AEFUserCache", ^{
    
    __block AEFUser *user;
    
    beforeEach(^{
        user = [[AEFUser alloc] initWithUsername:@"mrtest" password:@"testpass"];
    });
    
    context(@"when caching", ^{
        
        it(@"should cache a user", ^{
            [AEFUserCache cacheUser:user];
            
            [[[AEFUserCache cachedUser] shouldNot] beNil];
        });
        
        it(@"should clear the cache", ^{
            [AEFUserCache cacheUser:user];
            [AEFUserCache clearCache];
            
            [[[AEFUserCache cachedUser] should] beNil];
        });
        
    });
    
});

SPEC_END
