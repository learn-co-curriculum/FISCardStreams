//
//  FISComment.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
// assigned to Mark

#import "FISComment.h"

#import "NSDate+DateFromJSONDate.h"

@implementation FISComment

- (instancetype)init {
    self = [self initWithCommentID:@""
                          parentID:@""
                         createdAt:[NSDate date]
                           content:@""];
    return self;
}

- (instancetype)initWithCommentID:(NSString *)commentID
                         parentID:(NSString *)parentID
                        createdAt:(NSDate   *)createdAt
                          content:(NSString *)content {
    self = [super init];
    if (self) {
        _commentID = commentID;
        _parentID  = parentID;
        _createdAt = createdAt;
        _content   = content;
    }
    return self;
}

+ (FISComment *)createCommentFromDictionary:(NSDictionary *)commentDictionary {
    NSDate *createdAt = [NSDate dateFromJSONDate:commentDictionary[@"createdAt"] ];
    
    return [[FISComment alloc]initWithCommentID:commentDictionary[@"id"]
                                       parentID:commentDictionary[@"parentId"]
                                      createdAt:createdAt
                                        content:commentDictionary[@"content"]   ];
}

@end
