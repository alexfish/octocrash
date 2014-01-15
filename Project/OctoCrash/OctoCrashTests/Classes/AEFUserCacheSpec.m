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
        user = [[AEFUser alloc] initWithLogin:@"mrtest" token:@"testpass"];
    });
    
    context(@"when caching", ^{
        
        it(@"should cache a user", ^{
            [[SSKeychain should] receive:@selector(setPassword:forService:account:)];

            [AEFUserCache cacheUser:user];
        });
        
        it(@"should clear the cache", ^{
            [AEFUserCache cacheUser:user];
            [AEFUserCache clearCache];
            
            [[[AEFUserCache cachedUser] should] beNil];
        });
        
    });
    
});

SPEC_END
