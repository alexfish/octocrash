//
//  AEFUser.h
//  OctoCrash
//
//  Created by Alex Fish on 09/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 Represents a Github user holding any user specific
 details.
 */
@interface AEFUser : MTLModel

/**
 The users Github login
 */
@property (nonatomic, copy, readonly) NSString *login;

/**
 The users Github token, this token may be out of date if
 the user has revoked access
 */
@property (nonatomic, copy, readonly) NSString *token;

/**
 Init a new user object with a username and password
 @param username The user's login
 @param password The user's token
 
 @returns A new user object
 */
- (id)initWithLogin:(NSString *)login
              token:(NSString *)token;

@end
