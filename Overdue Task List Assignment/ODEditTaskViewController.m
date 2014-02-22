//
//  ODEditTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import "ODEditTaskViewController.h"

@interface ODEditTaskViewController ()

@end

@implementation ODEditTaskViewController

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
    [[self navigationItem] setTitle:self.task.name];
    self.taskNameTextField.text = self.task.name;
    self.textView.text = self.task.description;
    self.datePicker.date = self.task.date;
    
    self.textView.delegate = self;
    self.taskNameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark actions
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    [self updateTaskObject];
    [self.delegate didUpdateTask];
    
}

#pragma mark helper methods
-(void)updateTaskObject
{
    self.task.name = self.taskNameTextField.text;
    self.task.description = self.textView.text;
    self.task.date = self.datePicker.date;
}

#pragma mark delegates
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // this is hackey solution - user could copy /n as part of string
    if ([text isEqualToString:@"\n"])
    {
        [self.textView resignFirstResponder];
        return  NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.taskNameTextField resignFirstResponder];
    return  YES;
}

@end
