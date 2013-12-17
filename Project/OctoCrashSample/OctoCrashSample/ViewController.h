//
//  ViewController.h
//  OctoCrashSample
//
//  Created by Alex Fish on 16/12/2013.
//  Copyright (c) 2013 alexefish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/**
 The crash button displayed in the middle of the screen
 */
@property (nonatomic, weak) IBOutlet UIButton *crashButton;

/**
 Crash the app
 @param sender The button sending the crash message
 */
- (IBAction)crash:(id)sender;

@end
