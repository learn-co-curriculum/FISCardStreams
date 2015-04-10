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

/**
*  Takes a date-as-string from the CardStreams.io api response and converts it to NSDate. The accepted date format is "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'".
 */
+ (NSDate *)dateFromJSONDate:(NSString *)jsonDate;

+ (NSString *)dateAsJSONDate:(NSDate *)date; // should belong in a category on NSString if it is ever used.

/**
 Takes a date-as-string from the Medium.com web page and converts is to NSDate. The accepted date format is "ccc, dd LLL yyyy HH:mm:ss vvv".
 */
+ (NSDate *)dateFromRSSDate:(NSString *)rssDate;

/**
 Takes a date-as-string from the Github.com api reponse and converts is to NSDate. The accepted date format is "yyyy-MM-dd'T'HH:mm:ss'Z'".
 */
+ (NSDate *)dateFromGithubDate:(NSString *)githubDate;

@end
