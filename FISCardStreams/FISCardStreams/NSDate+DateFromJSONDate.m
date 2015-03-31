//
//  NSDate+DateFromJSONDate.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "NSDate+DateFromJSONDate.h"

@implementation NSDate (DateFromJSONDate)

+ (NSDate *)dateFromJSONDate:(NSString *)jsonDate {
    NSDateFormatter *jsonDateFormat = [[NSDateFormatter alloc]init];
    [jsonDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    NSDate *date = [jsonDateFormat dateFromString:jsonDate];
    return date;
}

@end
