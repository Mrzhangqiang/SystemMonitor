//
//  CPULoadFilter.m
//  ActivityMonitor++
//
//  Created by st on 10/05/2013.
//  Copyright (c) 2013 st. All rights reserved.
//

#import "CPULoad.h"
#import "CPULoadFilter.h"

@interface CPULoadFilter()
@property (strong, nonatomic) NSMutableArray *rawCpuLoadHistory;

- (void)appendRawCpuLoad:(CPULoad*)cpuLoad;
@end

@implementation CPULoadFilter
@synthesize rawCpuLoadHistory;

static const NSUInteger kCpuLoadHistoryMax = 0;

#pragma mark - override

- (id)init
{
    if (self = [super init])
    {
        self.rawCpuLoadHistory = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - public

- (CPULoad*)filterLoad:(CPULoad*)cpuLoad
{
    NSUInteger i;
    float avgSystem = 0;
    float avgUser = 0;
    float avgNice = 0;
    float avgSystemWithoutNice = 0;
    float avgUserWithoutNice = 0;
    
    [self.rawCpuLoadHistory addObject:cpuLoad];
    
    for (i = 0; i < self.rawCpuLoadHistory.count; ++i)
    {
        CPULoad *load = [self.rawCpuLoadHistory objectAtIndex:i];
        avgSystem += load.system;
        avgUser += load.user;
        avgNice += load.nice;
        avgSystemWithoutNice += load.systemWithoutNice;
        avgUserWithoutNice += load.userWithoutNice;
    }
    
    CPULoad *result = [[CPULoad alloc] init];
    result.system = avgSystem / i;
    result.user = avgUser / i;
    result.nice = avgNice / i;
    result.systemWithoutNice = avgSystemWithoutNice / i;
    result.userWithoutNice = avgUserWithoutNice / i;
    result.total = result.system + result.user + result.nice;
    
    return result;
}

#pragma mark - private

- (void)appendRawCpuLoad:(CPULoad*)cpuLoad
{
    [self.rawCpuLoadHistory insertObject:cpuLoad atIndex:0];
    
    while (self.rawCpuLoadHistory.count > kCpuLoadHistoryMax)
    {
        [self.rawCpuLoadHistory removeLastObject];
    }
}

@end
