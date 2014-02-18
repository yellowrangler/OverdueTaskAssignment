//
//  ODTask.m
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import "ODTask.h"

@implementation ODTask

-(id)init
{
    self = [self initWithData:nil];
    
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.name = data[TASK_TITLE];
        self.description = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.complete = [data[TASK_COMPLETION] boolValue];
    }
    
    return  self;
}


@end
