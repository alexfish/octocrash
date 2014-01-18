//
//  NSError_AEFErrorsSpec.m
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright 2014 alexefish. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSError+AEFErrors.h"


SPEC_BEGIN(NSError_AEFErrorsSpec)

describe(@"NSError_AEFErrors", ^{
    
    context(@"When generating errors", ^{
       
        it(@"Should return a generic error by default", ^{
            [[[[[NSError errorWithCode:0] userInfo] objectForKey:NSLocalizedDescriptionKey] should] equal:AEFLocalizedString(@"ERROR_DESCRIPTION_GENERIC", nil)];
        });
        
        it(@"Should return a not found error", ^{
            [[[[[NSError errorWithCode:AEFErrorCodeNotFound] userInfo] objectForKey:NSLocalizedDescriptionKey] should] equal:AEFLocalizedString(@"ERROR_DESCRIPTION_NOT_FOUND", nil)];
        });
        
        it(@"should return an auth error", ^{
            [[[[[NSError errorWithCode:AEFErrorCodeAuthFailed] userInfo] objectForKey:NSLocalizedDescriptionKey] should] equal:AEFLocalizedString(@"ERROR_DESCRIPTION_AUTH", nil)];
        });
    });
});

SPEC_END
