//
//  NSDate+DateFromJSONDate.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
// assigned to Mark

#import "NSDate+DateFromJSONDate.h"

@implementation NSDate (DateFromJSONDate)

+ (NSDate *)dateFromJSONDate:(NSString *)jsonDate {
    NSDateFormatter *jsonDateFormat = [[NSDateFormatter alloc]init];
    [jsonDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *date = [jsonDateFormat dateFromString:jsonDate];
    return date;
}

+ (NSString *)dateAsJSONDate:(NSDate *)date {
    NSDateFormatter *jsonDateFormat = [[NSDateFormatter alloc]init];
    [jsonDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSString *jsonDate = [jsonDateFormat stringFromDate:date];
    return jsonDate;
}

+ (NSDate *)dateFromRSSDate:(NSString *)rssDate {
    NSDateFormatter *rssDateFormat = [[NSDateFormatter alloc]init];
    [rssDateFormat setDateFormat:@"ccc, dd LLL yyyy HH:mm:ss vvv"];
    
    NSDate *date = [rssDateFormat dateFromString:rssDate];
    return date;
}

@end
