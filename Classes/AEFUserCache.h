//
//  AEFUserCache.h
//  OctoCrash
//
//  Created by Alex Fish on 11/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AEFUser;

/**
 Caches AEFUser objects, the cache can only hold
 one user at a time.
 */
@interface AEFUserCache : NSObject

/**
 Cache a user object for later use. When caching a user
 any existing users in the cache will be removed. 
 
 @param user The user object to cache
 */
+ (void)cacheUser:(AEFUser *)user;

/**
 Return the cached user, if the cache does not contain
 a user then nil is returned.
 
 @returns user The user held in the cache
 */
+ (AEFUser *)cachedUser;

/**
 Clear the cache deleting any cached user forever, nothing
 will happen if the cache is already empty.
 */
+ (void)clearCache;

@end
