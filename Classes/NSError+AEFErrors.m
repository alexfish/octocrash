//
//  NSError+AEFErrors.m
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "NSError+AEFErrors.h"


@implementation NSError (AEFErrors)


#pragma mark - Errors

+ (NSError *)errorWithCode:(NSInteger)errorCode
{
    NSError *error = nil;
    
    switch (errorCode) {
        case AEFErrorCodeNotFound:
            error = [NSError notFoundError];
            break;
        case AEFErrorCodeAuthFailed:
            error = [NSError authError];
            break;
        default:
            error = [NSError genericError];
            break;
    }
    return error;
}


#pragma mark - Errors (Private)

+ (NSError *)notFoundError
{
	NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: AEFLocalizedString(@"ERROR_DESCRIPTION_NOT_FOUND", nil),
                               NSLocalizedFailureReasonErrorKey: AEFLocalizedString(@"ERROR_REASON_NOT_FOUND", nil),
                               };
    
	return [NSError errorWithDomain:kAEFErrorDomain code:AEFErrorCodeNotFound userInfo:userInfo];
}

+ (NSError *)authError
{
	NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: AEFLocalizedString(@"ERROR_DESCRIPTION_AUTH", @""),
                               NSLocalizedFailureReasonErrorKey: AEFLocalizedString(@"ERROR_REASON_AUTH", nil),
                               };
    
	return [NSError errorWithDomain:kAEFErrorDomain code:AEFErrorCodeAuthFailed userInfo:userInfo];
}

+ (NSError *)genericError
{
	NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: AEFLocalizedString(@"ERROR_DESCRIPTION_GENERIC", @""),
                               NSLocalizedFailureReasonErrorKey: AEFLocalizedString(@"ERROR_REASON_GENERIC", nil),
                               };
    
	return [NSError errorWithDomain:kAEFErrorDomain code:AEFErrorCodeGeneric userInfo:userInfo];
}

@end
