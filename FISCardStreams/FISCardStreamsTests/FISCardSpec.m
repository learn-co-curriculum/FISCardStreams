//
//  FISCardSpec.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/16/15.
//  Copyright 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "FISCard.h"

#import "NSDate+DateFromJSONDate.h"


SpecBegin(FISCard)

describe(@"FISCard", ^{
    
    __block NSString       *cardID;
    __block NSString       *streamID;
    __block NSString       *title;
    __block NSString       *cardDescription;
    __block NSDate         *createdAt;
    __block NSDate         *updatedAt;
    __block NSInteger       displayAt;
    __block NSInteger       streamPosition;
    __block NSDate         *postAt;
    __block NSString       *source;
    __block NSString       *uniquenessID;
    __block BOOL            isDeleted;
    __block NSDate         *deletedAt;
    __block NSMutableArray *attachments;
    __block NSInteger       commentCount;
    __block NSMutableArray *comments;
    __block NSArray        *tags;
    
    __block NSString       *jsonCreatedAt;
    __block NSString       *jsonUpdatedAt;
    __block NSString       *jsonPostAt;
    __block NSString       *jsonDeletedAt;
    __block NSDictionary   *cardDictionary;
    
    __block NSDictionary   *cardDictionary2;
    __block NSArray        *cardDictionaries;
    
    __block FISCard        *defaultCard;
    __block FISCard        *designatedCard;
    __block FISCard        *dictionaryCard;
    __block NSArray        *arrayOfCards;
    
    beforeEach(^{
        cardID          = @"cardID";
        streamID        = @"streamID";
        title           = @"title";
        cardDescription = @"cardDescription";
        createdAt       = [NSDate date];
        updatedAt       = [NSDate dateWithTimeIntervalSinceNow:1111];
        displayAt       = 12345;
        streamPosition  = 67890;
        postAt          = [NSDate dateWithTimeIntervalSinceNow:2222];
        source          = @"source";
        uniquenessID    = @"uniquenessID";
        isDeleted       = YES;
        deletedAt       = [NSDate dateWithTimeIntervalSinceNow:3333];
        attachments     = [[NSMutableArray alloc]init];
        commentCount    = 0;
        comments        = [[NSMutableArray alloc]init];
        tags            = @[@"tag1", @"tag2"];
        
        jsonCreatedAt   = [NSDate dateAsJSONDate:createdAt];
        jsonUpdatedAt   = [NSDate dateAsJSONDate:updatedAt];
        jsonPostAt      = [NSDate dateAsJSONDate:postAt];
        jsonDeletedAt   = [NSDate dateAsJSONDate:deletedAt];
        
        cardDictionary  = @{ @"id"             : cardID,
                             @"streamId"       : streamID,
                             @"title"          : title,
                             @"description"    : cardDescription,
                             @"createdAt"      : jsonCreatedAt,
                             @"updatedAt"      : jsonUpdatedAt,
                             @"displayAt"      : @(displayAt),
                             @"streamPosition" : @(streamPosition),
                             @"postAt"         : jsonPostAt,
                             @"source"         : source,
                             @"uniquenessID"   : uniquenessID,
                             @"isDeleted"      : @(isDeleted),
                             @"deletedAt"      : jsonDeletedAt,
                             @"attachments"    : attachments,
                             @"commentCount"   : @(commentCount),
                             @"comments"       : comments,
                             @"tags"           : tags            };
        
        cardDictionary2  = [cardDictionary copy];
        cardDictionaries = @[cardDictionary, cardDictionary2];
        
        defaultCard = [[FISCard alloc]init];
        
        designatedCard = [[FISCard alloc]initWithCardID:cardID
                                               streamID:streamID
                                                  title:title
                                        cardDescription:cardDescription
                                              createdAt:createdAt
                                              updatedAt:updatedAt
                                              displayAt:displayAt
                                         streamPosition:streamPosition
                                                 postAt:postAt
                                                 source:source
                                           uniquenessID:uniquenessID
                                              isDeleted:isDeleted
                                              deletedAt:deletedAt
                                            attachments:attachments
                                           commentCount:commentCount
                                               comments:comments
                                                   tags:tags         ];
        
        dictionaryCard = [FISCard createCardFromDictionary:cardDictionary];
        
        arrayOfCards = [FISCard createArrayOfCardsFromDictionaries:cardDictionaries];
    });
    
    describe(@"default initializer", ^{
        it(@"sets default values for all string properties", ^{
            expect(defaultCard.cardID         ).to.equal(@"");
            expect(defaultCard.streamID       ).to.equal(@"");
            expect(defaultCard.title          ).to.equal(@"");
            expect(defaultCard.cardDescription).to.equal(@"");
            expect(defaultCard.source         ).to.equal(@"");
            expect(defaultCard.uniquenessID   ).to.equal(@"");
        });
        it(@"sets date values for date properties except deletedAt", ^{
            expect(defaultCard.createdAt).to.beKindOf([NSDate class]);
            expect(defaultCard.updatedAt).to.beKindOf([NSDate class]);
            expect(defaultCard.postAt   ).to.beKindOf([NSDate class]);
        });
        it(@"sets deletion information to NO", ^{
            expect(defaultCard.isDeleted).to.beFalsy();
            expect(defaultCard.deletedAt).to.beNil();
        });
        it(@"sets integer properties to zero", ^{
            expect(defaultCard.displayAt     ).to.equal(0);
            expect(defaultCard.streamPosition).to.equal(0);
            expect(defaultCard.commentCount  ).to.equal(0);
        });
        it(@"initializes array properties with empty arrays", ^{
            expect(defaultCard.attachments).to.equal([[NSMutableArray alloc]init]);
            expect(defaultCard.comments).to.equal([[NSMutableArray alloc]init]);
            expect(defaultCard.tags).to.equal(@[]);
        });
    });
    
    describe(@"designated initializer", ^{
        it(@"sets submitted values for all string properties", ^{
            expect(designatedCard.cardID         ).to.equal(cardID);
            expect(designatedCard.streamID       ).to.equal(streamID);
            expect(designatedCard.title          ).to.equal(title);
            expect(designatedCard.cardDescription).to.equal(cardDescription);
            expect(designatedCard.source         ).to.equal(source);
            expect(designatedCard.uniquenessID   ).to.equal(uniquenessID);
        });
        it(@"sets submitted date values for date properties except deletedAt", ^{
            expect(designatedCard.createdAt).to.equal(createdAt);
            expect(designatedCard.updatedAt).to.equal(updatedAt);
            expect(designatedCard.postAt   ).to.equal(postAt);
        });
        it(@"sets deletion information correctly", ^{
            expect(designatedCard.isDeleted).to.beTruthy();
            expect(designatedCard.deletedAt).to.equal(deletedAt);
        });
        it(@"sets integer properties to submitted values", ^{
            expect(designatedCard.displayAt     ).to.equal(displayAt);
            expect(designatedCard.streamPosition).to.equal(streamPosition);
            expect(designatedCard.commentCount  ).to.equal(commentCount);
        });
        it(@"initializes array properties with submitted arrays", ^{
            expect(designatedCard.attachments).to.equal(attachments);
            expect(designatedCard.comments   ).to.equal(comments);
            expect(designatedCard.tags       ).to.equal(tags);
        });
    });
    
    describe(@"class initializer", ^{
        it(@"sets submitted values for all string properties", ^{
            expect(dictionaryCard.cardID         ).to.equal(cardID);
            expect(dictionaryCard.streamID       ).to.equal(streamID);
            expect(dictionaryCard.title          ).to.equal(title);
            expect(dictionaryCard.cardDescription).to.equal(cardDescription);
            expect(dictionaryCard.source         ).to.equal(source);
            expect(dictionaryCard.uniquenessID   ).to.equal(uniquenessID);
        });
        it(@"sets submitted date values for date properties except deletedAt", ^{
            NSInteger cardCreatedAt = [dictionaryCard.createdAt timeIntervalSince1970];
            NSInteger cardUpdatedAt = [dictionaryCard.updatedAt timeIntervalSince1970];
            NSInteger cardPostAt    = [dictionaryCard.postAt timeIntervalSince1970];
            
            NSInteger createdAtEpoch = [createdAt timeIntervalSince1970];
            NSInteger updatedAtEpoch = [updatedAt timeIntervalSince1970];
            NSInteger postAtEpoch    = [postAt timeIntervalSince1970];

            
            expect(cardCreatedAt).to.beCloseToWithin(createdAtEpoch, 1);
            expect(cardUpdatedAt).to.beCloseToWithin(updatedAtEpoch, 1);
            expect(cardPostAt   ).to.beCloseToWithin(postAtEpoch,    1);
        });
        it(@"sets deletion information correctly", ^{
            NSInteger cardDeletedAt    = [dictionaryCard.deletedAt timeIntervalSince1970];
            
            NSInteger deletedAtEpoch = [deletedAt timeIntervalSince1970];
            
            expect(dictionaryCard.isDeleted).to.beTruthy();
            expect(cardDeletedAt).to.beCloseToWithin(deletedAtEpoch, 1);
        });
        it(@"sets integer properties to submitted values", ^{
            expect(dictionaryCard.displayAt     ).to.equal(displayAt);
            expect(dictionaryCard.streamPosition).to.equal(streamPosition);
            expect(dictionaryCard.commentCount  ).to.equal(commentCount);
        });
        it(@"initializes array properties with submitted arrays", ^{
            expect(dictionaryCard.attachments).to.equal(attachments);
            expect(dictionaryCard.comments   ).to.equal(comments);
            expect(dictionaryCard.tags       ).to.equal(tags);
        });
    });
    
    describe(@"class array initializer", ^{
        it(@"returns the correct number of instances", ^{
            expect([arrayOfCards count]).to.equal(2);
        });
        it(@"sets submitted values for all string properties", ^{
            for (FISCard *currentCard in arrayOfCards) {
                expect(currentCard.cardID         ).to.equal(cardID);
                expect(currentCard.streamID       ).to.equal(streamID);
                expect(currentCard.title          ).to.equal(title);
                expect(currentCard.cardDescription).to.equal(cardDescription);
                expect(currentCard.source         ).to.equal(source);
                expect(currentCard.uniquenessID   ).to.equal(uniquenessID);
            }
        });
        it(@"sets submitted date values for date properties except deletedAt", ^{
            for (FISCard *currentCard in arrayOfCards) {
                NSInteger cardCreatedAt = [currentCard.createdAt timeIntervalSince1970];
                NSInteger cardUpdatedAt = [currentCard.updatedAt timeIntervalSince1970];
                NSInteger cardPostAt    = [currentCard.postAt timeIntervalSince1970];
                
                NSInteger createdAtEpoch = [createdAt timeIntervalSince1970];
                NSInteger updatedAtEpoch = [updatedAt timeIntervalSince1970];
                NSInteger postAtEpoch    = [postAt timeIntervalSince1970];
                
                
                expect(cardCreatedAt).to.beCloseToWithin(createdAtEpoch, 1);
                expect(cardUpdatedAt).to.beCloseToWithin(updatedAtEpoch, 1);
                expect(cardPostAt   ).to.beCloseToWithin(postAtEpoch,    1);
            }
        });
        it(@"sets deletion information correctly", ^{
            for (FISCard *currentCard in arrayOfCards) {
                NSInteger cardDeletedAt    = [currentCard.deletedAt timeIntervalSince1970];
                
                NSInteger deletedAtEpoch = [deletedAt timeIntervalSince1970];
                
                expect(currentCard.isDeleted).to.beTruthy();
                expect(cardDeletedAt).to.beCloseToWithin(deletedAtEpoch, 1);
            }
        });
        it(@"sets integer properties to submitted values", ^{
            for (FISCard *currentCard in arrayOfCards) {
                expect(currentCard.displayAt     ).to.equal(displayAt);
                expect(currentCard.streamPosition).to.equal(streamPosition);
                expect(currentCard.commentCount  ).to.equal(commentCount);
            }
        });
        it(@"initializes array properties with submitted arrays", ^{
            for (FISCard *currentCard in arrayOfCards) {
                expect(currentCard.attachments).to.equal(attachments);
                expect(currentCard.comments   ).to.equal(comments);
                expect(currentCard.tags       ).to.equal(tags);
            }
        });
    });
});

SpecEnd
