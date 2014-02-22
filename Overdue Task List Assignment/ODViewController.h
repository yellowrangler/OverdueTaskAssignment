//
//  ODViewController.h
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODAddTaskViewController.h"
#import "ODDetailTaskViewController.h"

@interface ODViewController : UIViewController <ODAddTaskViewControllerDelegate, ODDetailTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskObjects;

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addTadkButtonPressed:(UIBarButtonItem *)sender;

@end
