//
//  FISCard.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import <Foundation/Foundation.h>

/**
  FISCard conforms to the CardStreams.io API card object. Attachments and Comments are custom objects initialized from the Card's JSON dictionary response.
 */
@interface FISCard : NSObject

@property (strong, nonatomic) NSString  *cardID;
@property (strong, nonatomic) NSString  *streamID;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *cardDescription;

@property (strong, nonatomic) NSDate    *createdAt;
@property (strong, nonatomic) NSDate    *updatedAt;
@property (nonatomic        ) NSInteger displayAt;
@property (nonatomic        ) NSInteger streamPosition;
@property (strong, nonatomic) NSDate    *postAt;

@property (nonatomic        ) BOOL      isDeleted;
@property (strong, nonatomic) NSDate    *deletedAt;

/**
 An array of FISAttachment objects. Defaults to an empty array.
 */
@property (strong, nonatomic) NSArray   *attachments;

@property (nonatomic        ) NSInteger commentCount;
/**
 As an array of FISComment objects. Defaults to an empty array.
 */
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSArray   *tags;

- (instancetype)init;

- (instancetype)initWithCardID:(NSString *)cardID
                      streamID:(NSString *)streamID
                         title:(NSString *)title
               cardDescription:(NSString *)cardDescription
                     createdAt:(NSDate   *)createdAt
                     updatedAt:(NSDate   *)updatedAt
                     displayAt:(NSInteger )displayAt
                streamPosition:(NSInteger )streamPosition
                        postAt:(NSDate   *)postAt
                     isDeleted:(BOOL      )isDeleted
                     deletedAt:(NSDate   *)deletedAt
                   attachments:(NSArray  *)attachments
                  commentCount:(NSInteger )commentCount
                      comments:(NSMutableArray *)comments
                          tags:(NSArray  *)tags;

+ (FISCard *)createCardFromDictionary:(NSDictionary *)cardDictionary;


@end
