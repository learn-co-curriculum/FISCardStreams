//
//  FISRSSFeedAPIClient.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Nelly

#import <Foundation/Foundation.h>

@interface FISRSSFeedAPIClient : NSObject

@property(strong, nonatomic)NSString * blogLink;


-(NSString *)transformBlogUrlToBlogRssFeedUrl;
-(NSArray *)getBlogList;
- (instancetype)initWithBlogUrl:(NSString *)blogUrl;
@end
