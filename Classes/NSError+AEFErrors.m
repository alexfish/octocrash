//
//  NSError+AEFErrors.m
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "NSError+AEFErrors.h"

// Models
#import "AEFStrings.h"


@implementation NSError (AEFErrors)


#pragma mark - Errors

+ (NSError *)errorWithCode:(NSInteger)errorCode
{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: AEFErrorCodeDescription(errorCode),
                        NSLocalizedFailureReasonErrorKey: AEFErrorCodeFailureReason(errorCode)
                               };
    
	return [NSError errorWithDomain:kAEFErrorDomain code:errorCode userInfo:userInfo];
}


#pragma mark - Error Strings

NSString *AEFErrorCodeDescription(NSInteger errorCode)
{
    NSString *description = nil;
    
    switch (errorCode) {
        case AEFErrorCodeNotFound:
            description = AEFLocalizedString(@"ERROR_DESCRIPTION_NOT_FOUND", nil);
            break;
        case AEFErrorCodeAuthFailed:
            description = AEFLocalizedString(@"ERROR_DESCRIPTION_AUTH", nil);
            break;
        default:
            description = AEFLocalizedString(@"ERROR_DESCRIPTION_GENERIC", nil);
            break;
    }
    
    return description;
}

NSString *AEFErrorCodeFailureReason(NSInteger errorCode)
{
    NSString *failureReason = nil;
    
    switch (errorCode) {
        case AEFErrorCodeNotFound:
            failureReason = AEFLocalizedString(@"ERROR_REASON_NOT_FOUND", nil);
            break;
        case AEFErrorCodeAuthFailed:
            failureReason = AEFLocalizedString(@"ERROR_REASON_AUTH", nil);
            break;
        default:
            failureReason = AEFLocalizedString(@"ERROR_REASON_GENERIC", nil);
            break;
    }
    
    return failureReason;
}


@end
