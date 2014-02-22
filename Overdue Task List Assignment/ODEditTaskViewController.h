//
//  ODEditTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODTask.h"

@protocol ODEditTaskViewControllerDelegate <NSObject>

-(void)didUpdateTask;

@end

@interface ODEditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic)id <ODEditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet ODTask *task;

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;

@end
