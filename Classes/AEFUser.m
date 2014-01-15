//
//  AEFUser.m
//  OctoCrash
//
//  Created by Alex Fish on 09/01/2014.
//  Copyright (c) 2014 alexefish. All rights reserved.
//

#import "AEFUser.h"

/**
 Class Extension
 */
@interface AEFUser ()

// Overwritten readonly properties
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *token;

@end


@implementation AEFUser


#pragma mark - Init

- (id)initWithLogin:(NSString *)login
              token:(NSString *)token
{
    self = [super init];
    if (self)
    {
        self.login = login;
        self.token = token;
    }
    
    return self;
}

@end
