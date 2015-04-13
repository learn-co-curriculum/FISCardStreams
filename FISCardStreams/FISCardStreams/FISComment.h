//
//  FISComment.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
// assigned to Mark

#import <Foundation/Foundation.h>

@interface FISComment : NSObject

/**
 Unique identifier of the Comment.
 */
@property (strong, nonatomic) NSString *commentID;

/**
 (optional) Identifier of another Comment which this Comment is a reply to.
 */
@property (strong, nonatomic) NSString *parentID;

/**
 The timestamp when this Comment was created.
 */
@property (strong, nonatomic) NSDate   *createdAt;

/**
 The Comment contents.
 */
@property (strong, nonatomic) NSString *content;

- (instancetype)init;

/**
 Designated initializer.
 */
- (instancetype)initWithCommentID:(NSString *)commentID
                         parentID:(NSString *)parentID
                        createdAt:(NSDate   *)createdAt
                          content:(NSString *)content;

/**
 Generates a Comment from a serialized JSON dictionary response from the CardStreams API.
 */
+ (FISComment *)createCommentFromDictionary:(NSDictionary *)commentDictionary;

/**
 Generates an array of FISComment objects from an array of serialized JSON response dictionaries from the CardStreams API.
 */
+ (NSMutableArray *)commentsFromArray:(NSArray *)commentDictionaries;

@end
