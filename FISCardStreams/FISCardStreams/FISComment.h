//
//  FISComment.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISComment : NSObject

@property (strong, nonatomic) NSString *commentID;
@property (strong, nonatomic) NSString *parentID; // card
@property (strong, nonatomic) NSDate   *createdAt;
@property (strong, nonatomic) NSString *content;

- (instancetype)init;
- (instancetype)initWithCommentID:(NSString *)commentID
                         parentID:(NSString *)parentID
                        createdAt:(NSDate   *)createdAt
                          content:(NSString *)content;

+ (FISComment *)createCommentFromDictionary:(NSDictionary *)commentDictionary;

@end
