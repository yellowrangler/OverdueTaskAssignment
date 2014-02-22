//
//  ODViewController.m
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import "ODViewController.h"
#import "ODDetailTaskViewController.h"

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
    
    NSLog(@"%@", self.taskObjects);
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODTask *task = [self.taskObjects objectAtIndex:indexPath.row];
    
    [self updateToggleCompletionOfTask:task forIndexPath:indexPath];
    
    [self.tableView reloadData];

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // get task
        ODTask *task = [self.taskObjects objectAtIndex:indexPath.row];
        
        // remove the element from the array
        [self deleteTask:task forIndexPath:indexPath];
        
        // delete the task  from the taskOjects array
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        //animate the deletion
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        // reload the table
//        [self.tableView reloadData];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ODTask *task = [self.taskObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
    
    // do test of bool here for color
    if (task.complete) cell.backgroundColor = [UIColor greenColor];
    else
    {
        BOOL dateIsLargerThenCurrentDate = [self isDate1GreaterThenDate2:[NSDate date] and:task.date];
        if (dateIsLargerThenCurrentDate) cell.backgroundColor = [UIColor redColor];
        else cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}


#pragma mark actions
- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.tableView.editing)[self.tableView setEditing:NO animated:YES];
    else [self.tableView setEditing:YES animated:YES];

    
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
    else if ([segue.destinationViewController isKindOfClass:[ODDetailTaskViewController class]])
    {
        ODDetailTaskViewController *detailTaskViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        detailTaskViewController.task = self.taskObjects[path.row];
        
        detailTaskViewController.delegate = self;
    }
}

#pragma mark Delegates
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailTaskViewConrollerSegue" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    ODTask *task = self.taskObjects[sourceIndexPath.row];
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:task atIndex:destinationIndexPath.row];
    
    [self saveTasks];
}

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

-(void)updateTask
{
    [self saveTasks];
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

-(BOOL)isDate1GreaterThenDate2:(NSDate *)date1 and:(NSDate *)date2
{
    NSTimeInterval timeInterval1 = [date1 timeIntervalSince1970];
    NSTimeInterval timeInterval2 = [date2 timeIntervalSince1970];
    
    if (timeInterval1 > timeInterval2) return YES;
    else return NO;
    
}

-(void)updateToggleCompletionOfTask:(ODTask *)task forIndexPath:(NSIndexPath *)indexPath
{

    // toggle completion
    if (task.complete) task.complete = NO;
    else task.complete = YES;
    
    // get current list from user defaults
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_LIST_KEY] mutableCopy];
    
    // replace the task object with new updated task object
    [taskObjectsAsPropertyLists replaceObjectAtIndex:indexPath.row withObject:[self taskObjectAsAPropertyList:task]];
    
    // new array back to user data and syncronize
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)deleteTask:(ODTask *)task forIndexPath:(NSIndexPath *)indexPath
{
    // get current list from user defaults
    NSMutableArray *taskObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_LIST_KEY] mutableCopy];
    
    // replace the task object with new updated task object
    [taskObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];

    // new array back to user data and syncronize
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
 }

-(void)saveTasks
{
    // get current list from user defaults
    NSMutableArray *taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < [self.taskObjects count]; x++)
    {
        [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:self.taskObjects[x]]];
    }

    // new array back to user data and syncronize
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:TASK_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
