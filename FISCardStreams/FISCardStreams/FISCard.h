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

/**
 The unique identity of a Card.
 */
@property (strong, nonatomic) NSString  *cardID;

/**
 Stream to which this card belongs.
 */
@property (strong, nonatomic) NSString  *streamID;

/**
 Card title / summary.
 */
@property (strong, nonatomic) NSString  *title;

/** 
 Card textual contents.
 */
@property (strong, nonatomic) NSString  *cardDescription;

/**
 Date and time when the Card was created.
 */
@property (strong, nonatomic) NSDate    *createdAt;

/**
 Date and time when the Card's contents were last modified.
 */
@property (strong, nonatomic) NSDate    *updatedAt;

/**
 Time position where the Card should be displayed in the Stream.
 */
@property (nonatomic        ) NSInteger displayAt;

/**
 (optional) Date and time assinged by poster for the Card to displayed at.
 */
@property (nonatomic        ) NSInteger streamPosition;

/**
 (optional) Date and time assigned by poster for the Card to be displayed at.
 */
@property (strong, nonatomic) NSDate    *postAt;

/**
 (custom--optional) The origin of the card's data.
 */
@property (strong, nonatomic) NSString  *source;

/**
 Is the card absent from the Stream?
 */
@property (nonatomic        ) BOOL      isDeleted;

/**
 (optional) The Stream when this card was deleted  (clarity ?)
 */
@property (strong, nonatomic) NSDate    *deletedAt;

/**
 (optional) The set of file attachments to the card, as an array of FISAttachment objects. Defaults to an empty array.
 */
@property (strong, nonatomic) NSMutableArray *attachments;

/**
 Number of Comments made to the card.
 */
@property (nonatomic        ) NSInteger commentCount;

/**
 (optional) The Comments made to the card, stored as an array of FISComment objects. Defaults to an empty array.
 */
@property (strong, nonatomic) NSMutableArray *comments;

/**
 (optional) The Comments made to the Card.
 */
@property (strong, nonatomic) NSArray   *tags;

- (instancetype)init;

/**
 Designated initializer.
 */
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
                          tags:(NSArray  *)tags;

/**
 Generates a card from a serialized JSON dictionary response from the CardStream API.
 */
+ (FISCard *)createCardFromDictionary:(NSDictionary *)cardDictionary;
+ (NSMutableArray *)createCardsFromCardDictionaries:(NSArray *)cardDictionaries;

@end
