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
    /** A generic error code when something is not found */
    AEFErrorCodeNotFound = 800,
};

/**
 *  The AEFErrorDomain name
 */
static NSString *const kAEFErrorDomain = @"AEFError";


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
