//
//  AEFCrashReporter.m
//  OctoCrash
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "AEFCrashReporter.h"

// Models
#import "AEFCrashCollector.h"
#import "AEFClient.h"

// Extensions
#import "NSError+AEFErrors.h"
#import "EXTScope.h"


// Class Extension
@interface AEFCrashReporter ()

/**
 The collector collects crashes..
 */
@property (nonatomic, strong) AEFCrashCollector *collector;

/**
 The client sends crash reports to Github
*/
@property (nonatomic, strong) AEFClient *client;

/**
 Protocol properties
 */
@property (nonatomic, copy) NSString    *repo;
@property (nonatomic, copy) NSString    *clientID;
@property (nonatomic, copy) NSString    *clientSecret;
@property (nonatomic, copy) NSArray     *labels;

@end


@implementation AEFCrashReporter


#pragma mark - Init

+ (id)sharedReporter
{
    static AEFCrashReporter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.collector = [[AEFCrashCollector alloc] init];
    }
    
    return self;
}


#pragma mark - Configuration

- (void)setRepo:(NSString *)repo
       clientID:(NSString *)clientID
   clientSecret:(NSString *)clientSecret
{
    self.repo = repo;
    self.clientID = clientID;
    self.clientSecret = clientSecret;
}


#pragma mark - Reporting

- (void)startReporting
{
    [self collectReports];
    [self sendPendingReports];
}


#pragma mark - Reporting (Private)

- (void)sendPendingReports
{
    PLCrashReport *pendingReport = [self.collector pendingReport];
    
    if (pendingReport)
    {
        [self sendReport:pendingReport];
    }
}

- (void)collectReports
{
    [self.collector startCollecting];
}


#pragma mark - Client (Private)

- (void)sendReport:(PLCrashReport *)report
{
    self.client = [[AEFClient alloc] initWithRepo:self.repo
                                         clientID:self.clientID
                                     clientSecret:self.clientSecret];
    
    @weakify(self);
    [self.client authenticate:^(OCTClient *client) {
        @strongify(self);
        
        [self.client getReport:report client:client completed:^(NSURL *reportURL) {
            
            [self.client updateReport:report path:reportURL.absoluteString client:client completed:^{
                [self reportSent];
            } error:nil];
            
        } error:^(NSError *error) {
            if (error.code == AEFErrorCodeNotFound)
            {
                [self.client createReport:report client:client completed:^(id response) {
                    [self reportSent];
                } error:nil];
            }
        }];
    }];
}

- (void)reportSent
{
    [self.collector purge];
}

@end
