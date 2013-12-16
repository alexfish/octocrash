//
//  AEFCrashReporter.h
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The front of house of OctoCrash, all IO should go through this class via the 
 available interface.
 */
@interface AEFCrashReporter : NSObject

/**
 Returns the default crash reporter
 @returns A Singleton instance of the crash reporter
 */
+ (id)sharedReporter;

@end
