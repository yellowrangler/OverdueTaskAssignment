//
//  ODDetailTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDetailTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailsLabel;

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;

@end
