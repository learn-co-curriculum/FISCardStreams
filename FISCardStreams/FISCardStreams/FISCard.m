//
//  FISCard.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import "FISCard.h"

#import "FISAttachment.h"
#import "FISComment.h"

#import "NSDate+DateFromJSONDate.h"

@implementation FISCard

- (instancetype)init {
    self = [self initWithCardID:@""
                       streamID:@""
                          title:@""
                cardDescription:@""
                      createdAt:[NSDate date]
                      updatedAt:[NSDate date]
                      displayAt:0
                 streamPosition:0
                         postAt:[NSDate date]
                         source:@""
                      isDeleted:NO
                      deletedAt:nil
                    attachments:[[NSMutableArray alloc]init]
                   commentCount:0
                       comments:[[NSMutableArray alloc]init]
                           tags:@[]                             ];
    return self;
}

- (instancetype)initWithCardID:(NSString *)cardID
                      streamID:(NSString *)streamID
                         title:(NSString *)title
               cardDescription:(NSString *)cardDescription
                     createdAt:(NSDate   *)createdAt
                     updatedAt:(NSDate   *)updatedAt
                     displayAt:(NSInteger )displayAt
                streamPosition:(NSInteger )streamPosition
                        postAt:(NSDate   *)postAt
                        source:(NSString *)source
                     isDeleted:(BOOL      )isDeleted
                     deletedAt:(NSDate   *)deletedAt
                   attachments:(NSMutableArray *)attachments
                  commentCount:(NSInteger )commentCount
                      comments:(NSMutableArray *)comments
                          tags:(NSArray  *)tags {
    self = [super init];
    if (self) {
        _cardID          = cardID;
        _title           = title;
        _cardDescription = cardDescription;
        _createdAt       = createdAt;
        _updatedAt       = updatedAt;
        _displayAt       = displayAt;
        _streamPosition  = streamPosition;
        _postAt          = postAt;
        _source          = source;
        _isDeleted       = isDeleted;
        _deletedAt       = deletedAt;
        _attachments     = attachments;
        _commentCount    = commentCount;
        _comments        = comments;
        _tags            = tags;
    }
    return self;
}

+ (FISCard *)createCardFromDictionary:(NSDictionary *)cardDictionary {
    NSMutableArray *attachments = [FISCard attachmentsFromArray:cardDictionary[@"attachments"]
                                                     withCardID:cardDictionary[@"id"]          ];
    
    NSMutableArray *comments = [FISCard commentsFromArray:cardDictionary[@"comments"]   ];
    
    NSDate *createdAt = [NSDate dateFromJSONDate:cardDictionary[@"createdAt"]];
    NSDate *updatedAt = [NSDate dateFromJSONDate:cardDictionary[@"updatedAt"]];
    NSDate *postAt    = [NSDate dateFromJSONDate:cardDictionary[@"postAt"]];
    NSDate *deletedAt = [NSDate dateFromJSONDate:cardDictionary[@"deletedAt"]];
    
    NSString *source = @"";
    if ([[cardDictionary allKeys]containsObject:@"source"]) {
        source = cardDictionary[@"source"];
    }
    
    FISCard *card = [[FISCard alloc]initWithCardID:cardDictionary[@"id"]
                                          streamID:cardDictionary[@"streamId"]
                                             title:cardDictionary[@"title"]
                                   cardDescription:cardDictionary[@"description"]
                                         createdAt:createdAt
                                         updatedAt:updatedAt
                                         displayAt:(NSInteger)cardDictionary[@"displayAt"]
                                    streamPosition:(NSInteger)cardDictionary[@"streamPosition"]
                                            postAt:postAt
                                            source:source
                                         isDeleted:cardDictionary[@"isDeleted"]
                                         deletedAt:deletedAt
                                       attachments:attachments
                                      commentCount:(NSInteger)cardDictionary[@"commentCount"]
                                          comments:comments
                                              tags:cardDictionary[@"tags"]              ];
    
    return card;
}

+ (NSMutableArray *)attachmentsFromArray:(NSArray *)attachmentDictionaries
                       withCardID:(NSString *)cardID {
    NSMutableArray *attachments = [[NSMutableArray alloc]init];
    for (NSDictionary *attachmentDictionary in attachmentDictionaries) {
        FISAttachment *attachment = [FISAttachment createAttachmentFromDictionary:attachmentDictionary
                                                                       withCardID:cardID];
        [attachments addObject:attachment];
    }
    return attachments;
}

+ (NSMutableArray *)commentsFromArray:(NSArray *)commentDictionaries {
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    for (NSDictionary *commentDictionary in commentDictionaries) {
        FISComment *comment = [FISComment createCommentFromDictionary:commentDictionary];
        [comments addObject:comment];
    }
    return comments;
}



@end