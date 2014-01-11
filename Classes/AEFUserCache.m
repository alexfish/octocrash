//
//  AEFUserCache.m
//  OctoCrash
//
//  Created by Alex Fish on 11/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFUserCache.h"

// Controller
#import "SSKeychain.h"

// Model
#import "AEFUser.h"

// Constants
static NSString * const kAEFKeyChainService     = @"com.alexefish.octocrash";
static NSString * const kAEFAccountKey          = @"acct";


@implementation AEFUserCache


#pragma mark - Cache

+ (void)cacheUser:(AEFUser *)user
{
    if (!user.password || !user.username) return;
    
    [AEFUserCache clearCache];
    
    [SSKeychain setPassword:user.password
                 forService:kAEFKeyChainService
                    account:user.username];
}


#pragma mark - GET

+ (AEFUser *)cachedUser
{
    NSString *username = [AEFUserCache username];
    NSString *password = [SSKeychain passwordForService:kAEFKeyChainService
                                                account:username];
    
    AEFUser *user = nil;
    
    if (username && password)
    {
        user = [[AEFUser alloc] initWithUsername:username
                                        password:password];
    }
    
    return user;
}


#pragma mark - GET (Private)

+ (NSString *)username
{
    NSArray *accounts = [SSKeychain accountsForService:kAEFKeyChainService];
    NSDictionary *account = [accounts lastObject];
    
    return account[kAEFAccountKey];
}


#pragma mark - DELETE

+ (void)clearCache
{
    NSArray *accounts = [SSKeychain accountsForService:kAEFKeyChainService];
    
    for (NSDictionary *account in accounts)
    {
        [SSKeychain deletePasswordForService:kAEFKeyChainService
                                     account:account[kAEFAccountKey]];
    }
}

@end
