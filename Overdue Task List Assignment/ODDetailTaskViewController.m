//
//  ODDetailTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import "ODDetailTaskViewController.h"
#import "ODEditTaskViewController.h"

@interface ODDetailTaskViewController ()

@end

@implementation ODDetailTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.taskNameLabel.text = self.task.name;
    self.taskDetailsLabel.text = self.task.description;
    [self.taskDetailsLabel sizeToFit];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];

    NSDate *date = self.task.date;
    NSString *stringFromDate = [formatter stringFromDate:date];

    self.taskDateLabel.text = stringFromDate;

}

#pragma mark segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ODEditTaskViewController class]])
    {
        ODEditTaskViewController *editTaskViewController = segue.destinationViewController;
        editTaskViewController.task = self.task;
        
        editTaskViewController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"editTaskViewConrollerSegue" sender:nil];
}

#pragma mark delegate
-(void)didUpdateTask
{
    
    self.taskNameLabel.text = self.task.name;
    self.taskDetailsLabel.text = self.task.description;
    [self.taskDetailsLabel sizeToFit];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    NSDate *date = self.task.date;
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    self.taskDateLabel.text = stringFromDate;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate updateTask];
}

@end
