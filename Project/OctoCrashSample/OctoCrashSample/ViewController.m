//
//  ViewController.m
//  OctoCrashSample
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)crash:(id)sender
{
    NSException *exception = [NSException exceptionWithName:@"OctoCrashed" reason:@"This crash was on purpose" userInfo:nil];
    [exception raise];
}

@end
