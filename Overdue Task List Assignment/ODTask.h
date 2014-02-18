//
//  ODTask.h
//  Overdue Task List Assignment
//
//  Created by Tarrant Cutler on 2/17/14.
//  Copyright (c) 2014 Tarrant Cutler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODTask : NSObject

@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *description;
@property (strong, nonatomic)NSDate *date;
@property (nonatomic)BOOL complete;

-(id)initWithData:(NSDictionary *)data;

@end
