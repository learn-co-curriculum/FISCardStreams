//
//  FISRSSFeedAPIClient.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Nelly

#import "FISRSSFeedAPIClient.h"
#import "XMLReader.h"

@implementation FISRSSFeedAPIClient
- (instancetype)initWithBlogUrl:(NSString *)blogUrl
{
    self = [super init];
    if (self) {
        _blogLink = blogUrl;
    }
    return self;
}

-(instancetype)init
{
    return [self initWithBlogUrl:@""];
}


-(NSString *)transformBlogUrlToBlogRssFeedUrl
{
    NSString * feed = @"feed";
    NSString * domain = [self.blogLink substringToIndex:19];
    NSString * blogUserName = [self.blogLink substringFromIndex:19];
    
    if ([self.blogLink containsString:@"https://"]) {
        NSLog(@"true");
    }
    else
    {
        NSLog(@"no");
    }
    
    return [NSString stringWithFormat:@"%@%@/%@",domain,feed,blogUserName];
}


-(NSArray *)getBlogList
{
    
    NSURL * blogUrl = [NSURL URLWithString:[self transformBlogUrlToBlogRssFeedUrl]];
    NSData * blogData = [NSData dataWithContentsOfURL:blogUrl];
    NSDictionary *dataDictionary = [XMLReader dictionaryForXMLData:blogData error:nil];
    
    NSArray * blogList = dataDictionary[@"rss"][@"channel"][@"item"];
    NSMutableArray * userBlogResult = [[NSMutableArray alloc]init];
    
    
    for (NSInteger i = 0; i < [blogList count]; i++) {
        NSMutableDictionary * filteredData = [[NSMutableDictionary alloc]init];
        
        filteredData[@"title"] = blogList[i][@"title"][@"@"];
        filteredData[@"link"] = blogList[i][@"link"][@"@"];
        filteredData[@"pubDate"] = blogList[i][@"pubDate"][@"@"];
        
        NSString * description = blogList[i][@"description"][@"@"];
        
        NSString * changeImageSize = [description stringByReplacingOccurrencesOfString:@"width=\"600\" height=\"200\"" withString:@"width=\"250\" height=\"125\""];
        
        NSString *updateFont = [changeImageSize stringByReplacingOccurrencesOfString:@"<p class=\"medium-feed-snippet\">" withString:@"<p class=\"medium-feed-snippet\"><font face=\"avenir\">"];
        
        NSInteger summaryLength = updateFont.length - 10;
        NSString *closingFontTag = [updateFont stringByReplacingCharactersInRange:NSMakeRange(summaryLength, 10) withString:@"</font></p></div>"];
        
        filteredData[@"summary"] = [closingFontTag stringByReplacingOccurrencesOfString:@"»" withString:@""];
        
        NSLog(@"%@", closingFontTag);
        [userBlogResult addObject:filteredData];
    }
    
    return [userBlogResult copy];
    
    
}


// note for myself
/*
 It's better for the user to add the blog post as a regular link as NSString, then extract it by calling the rss feed and adding it as a regular card by putting it on the new card. However, just realized via API, user is not able to add a new card for a blog post.
 */

@end
