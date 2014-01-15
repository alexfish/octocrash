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
    if (!user.token || !user.login) return;
    
    [AEFUserCache clearCache];
    
    [SSKeychain setPassword:user.token
                 forService:kAEFKeyChainService
                    account:user.login];
}


#pragma mark - GET

+ (AEFUser *)cachedUser
{
    NSString *login     = [AEFUserCache login];
    NSString *token     = [SSKeychain passwordForService:kAEFKeyChainService
                                                 account:login];
    
    AEFUser *user = nil;
    
    if (login && token)
    {
        user = [[AEFUser alloc] initWithLogin:login token:token];
    }
    
    return user;
}


#pragma mark - GET (Private)

+ (NSString *)login
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
