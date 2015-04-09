//
//  NSDate+DateFromJSONDate.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
// assigned to Mark

#import <Foundation/Foundation.h>

@interface NSDate (DateFromJSONDate)

+ (NSDate *)dateFromJSONDate:(NSString *)jsonDate;

+ (NSString *)dateAsJSONDate:(NSDate *)date;

+ (NSDate *)dateFromRSSDate:(NSString *)rssDate;

+ (NSDate *)dateFromGithubDate:(NSString *)githubDate;

@end
