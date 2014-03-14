//
//  NSError+AEFErrors.h
//  OctoCrash
//
//  Created by Alex Fish on 18/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  An Enum of available AEFErrorCodes
 */
NS_ENUM(NSInteger, AEFErrorCode)
{
    /** A generic error code when something goes wrong */
    AEFErrorCodeGeneric = 800,
    /** An error code when auth fails */
    AEFErrorCodeAuthFailed = 801,
    /** An error code when something is not found */
    AEFErrorCodeNotFound = 802,
};

/**
 *  Return a localized error description for a given error code
 *
 *  @param errorCode The error code to return a description for
 *
 *  @return A localized description explaining the error code
 */
FOUNDATION_EXPORT NSString *AEFErrorCodeDescription(NSInteger errorCode);

/**
 *  Return a localized error reason for a given error code
 *
 *  @param errorCode The error code to return a failure reason for
 *
 *  @return A localized failure reason for the error code
 */
FOUNDATION_EXPORT NSString *AEFErrorCodeFailureReason(NSInteger errorCode);

/**
 *  The AEFErrorDomain name
 */
FOUNDATION_EXPORT NSString *const kAEFErrorDomain;


/**
 *  A category to provide OctoCrash specific error functionality
 */
@interface NSError (AEFErrors)

/**
 *  Return an NSError object for a specific error code
 *
 *  @param errorCode The error code to generate an error for
 *
 *  @return An new NSError instance for the given error code
 */
+ (NSError *)errorWithCode:(NSInteger)errorCode;

@end
