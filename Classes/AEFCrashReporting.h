//
//  AEFCrashReporting.h
//  OctoCrash
//
//  Created by Alex Fish on 18/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AEFCrashReporting <NSObject>

/**
 The Github repository to report crashes to, in the format org/name or user/name
 E.g alexfish/octocrash
 */
@property (nonatomic, copy, readonly) NSString *repo;

/**
 Github OAuth application client ID
 */
@property (nonatomic, copy, readonly) NSString *clientID;

/**
 Githuv OAuth application client secret
 */
@property (nonatomic, copy, readonly) NSString *clientSecret;

@end
