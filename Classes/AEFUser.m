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
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end


@implementation AEFUser


#pragma mark - Init

- (id)initWithUsername:(NSString *)username
              password:(NSString *)password
{
    self = [super init];
    if (self)
    {
        self.username = username;
        self.password = password;
    }
    
    return self;
}

@end
