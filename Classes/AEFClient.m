//
//  AEFClient.m
//  OctoCrash
//
//  Created by Alex Fish on 17/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "AEFClient.h"

// Models
#import <OctoKit/OctoKit.h>
#import <CrashReporter/PLCrashReport.h>


// Class extension
@interface AEFClient ()

/**
 Protocol properties
 */
@property (nonatomic, copy) NSString *repo;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;

@end

@implementation AEFClient


#pragma mark - Init

- (id)initWithRepo:(NSString *)repo
          clientID:(NSString *)clientID
      clientSecret:(NSString *)clientSecret
{
    self = [super init];
    if (self)
    {
        self.repo = repo;
        self.clientID = clientID;
        self.clientSecret = clientSecret;
    }
    
    return self;
}


#pragma mark - Reports

- (void)sendReport:(PLCrashReport *)report
{}

@end
