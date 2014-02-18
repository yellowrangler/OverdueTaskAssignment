//
//  ODViewController.m
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import "ODViewController.h"

@interface ODViewController ()

@end

@implementation ODViewController

#pragma mark Lazy Instantiation
-(NSMutableArray *)taskObjects
{
    if (!_taskObjects)
    {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    
    return _taskObjects;
}

#pragma mark main
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // settup table view datasource and delegates these will be handled by self
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // get task list from user data
    NSArray *tasksArray = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_LIST_KEY];
    for (NSDictionary *dictionary in tasksArray)
    {
        ODTask *task = [self taskObjectForDictionary:dictionary];
        [self.taskObjects addObject:task];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int tableRows = [self.taskObjects count];
    return tableRows;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ODTask *task = [self.taskObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
    
    // do test of bool here for color
    
    return cell;
}

#pragma mark actions
- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    
    
    
    NSLog(@"Did press reorder");
}

- (IBAction)addTadkButtonPressed:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"addTaskViewConrollerSegue" sender:nil];
    NSLog(@"Did press add");
}

#pragma mark segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ODAddTaskViewController class]])
    {
        ODAddTaskViewController *addTaskViewContoller = segue.destinationViewController;
        addTaskViewContoller.delegate = self;
    }
}

#pragma mark Delegates
-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Did cancel");
}

-(void)didAddTask:(ODTask *)task
{
    // add new task object to mutable array
    [self.taskObjects addObject:task];
    
    NSLog(@"%@",task.name);
    
    // get current list
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_LIST_KEY] mutableCopy];
    
    // if no previous tasks must initialize mutable array
    if (!taskObjectsAsPropertyLists) taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    // add the task object dictionary to array
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:task]];
    
    // new array back to user data and syncronize
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Did add task");
    
    [self.tableView reloadData];
}

#pragma mark  Helper methods
-(NSDictionary *)taskObjectAsAPropertyList: (ODTask *)task
{
    NSDictionary *dictionary = @{TASK_TITLE : task.name,
                                 TASK_DESCRIPTION : task.description,
                                 TASK_DATE : task.date,
                                 TASK_COMPLETION : @(task.complete)};
    return dictionary;
}

-(ODTask *)taskObjectForDictionary:(NSDictionary *)dictionary
{
    ODTask *taskObject = [[ODTask alloc] initWithData:dictionary];
    
    return taskObject;
}










@end
