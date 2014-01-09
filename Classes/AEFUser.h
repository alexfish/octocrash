//
//  AEFUser.h
//  OctoCrash
//
//  Created by Alex Fish on 09/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a Github user holding any user specific
 details.
 */
@interface AEFUser : NSObject

/**
 The users Github username
 */
@property (nonatomic, copy, readonly) NSString *username;

/**
 The users Github password
 */
@property (nonatomic, copy, readonly) NSString *password;

/**
 Init a new user object with a username and password
 @param username The user's username
 @param password The user's password
 
 @returns A new user object
 */
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password;

@end
