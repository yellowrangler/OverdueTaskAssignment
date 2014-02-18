//
//  ODAddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import "ODAddTaskViewController.h"
#import "ODTask.h"

@interface ODAddTaskViewController ()

@end

@implementation ODAddTaskViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.delegate didCancel];
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    
    // add logic to throw alert if no info or faulty info passed
    
    [self.delegate didAddTask:[self createTaskObject]];
}

#pragma mark helper methods
-(ODTask *)createTaskObject
{
    ODTask *addTaskObject = [[ODTask alloc] init];
    addTaskObject.name = self.taskNameTextField.text;
    addTaskObject.description = self.textView.text;
    addTaskObject.date = self.datePicker.date;
    addTaskObject.complete = NO;
    
    return addTaskObject;
}


@end
