//
//  FISCommentSpec.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/16/15.
//  Copyright 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "FISComment.h"

#import "NSDate+DateFromJSONDate.h"


SpecBegin(FISComment)

describe(@"FISComment", ^{
    
    __block NSString       *commentID;
    __block NSString       *parentID;
    __block NSDate         *createdAt;
    __block NSString       *content;
    
    __block NSString       *jsonCreatedAt;
    __block NSDictionary   *commentDictionary;
    
    __block NSDictionary   *commentDictionary2;
    __block NSArray        *commentDictionaries;
    
    __block FISComment     *defaultComment;
    __block FISComment     *designatedComment;
    __block FISComment     *dictionaryComment;
    __block NSMutableArray *arrayOfComments;

    beforeEach(^{
        commentID         = @"commentID";
        parentID          = @"parentID";
        createdAt         = [NSDate date];
        content           = @"content";
        
        jsonCreatedAt     = [NSDate dateAsJSONDate:createdAt];
        commentDictionary = @{ @"id"        : commentID,
                               @"parentId"  : parentID,
                               @"createdAt" : jsonCreatedAt,
                               @"content"   : content };
        
        commentDictionary2  = [commentDictionary copy];
        commentDictionaries = @[commentDictionary, commentDictionary2];
        
        defaultComment = [[FISComment alloc]init];
        
        designatedComment = [[FISComment alloc]initWithCommentID:commentID
                                                        parentID:parentID
                                                       createdAt:createdAt
                                                         content:content];
        
        dictionaryComment = [FISComment createCommentFromDictionary:commentDictionary];
        
        arrayOfComments = [FISComment commentsFromArray:commentDictionaries];
    });
    
    describe(@"default initializer", ^{
        it(@"sets all properties to default values", ^{
            expect(defaultComment.commentID).to.equal(@"");
            expect(defaultComment.parentID ).to.equal(@"");
            expect(defaultComment.createdAt).to.beKindOf([NSDate class]);
            expect(defaultComment.content  ).to.equal(@"");
        });
    });
    
    describe(@"designated initializer", ^{
        it(@"sets all properties to submitted values", ^{
            expect(designatedComment.commentID).to.equal(commentID);
            expect(designatedComment.parentID ).to.equal(parentID);
            expect(designatedComment.createdAt).to.equal(createdAt);
            expect(designatedComment.content  ).to.equal(content);
        });
    });
    
    describe(@"class initializer", ^{
        it(@"sets string properties correctly from a dictionary", ^{
            
            expect(dictionaryComment.commentID).to.equal(commentID);
            expect(dictionaryComment.parentID ).to.equal(parentID);
            expect(dictionaryComment.content  ).to.equal(content);
        });
        it(@"sets date correctly", ^{
            NSInteger commentCreatedAt = [dictionaryComment.createdAt timeIntervalSince1970];
            NSInteger createdAtEpoch = [createdAt timeIntervalSince1970];
            
            expect(commentCreatedAt).to.beCloseToWithin(createdAtEpoch, 1);
        });
    });
    
    describe(@"class array initializer", ^{
        it(@"has the correct number of comment objects in the array", ^{
            expect([arrayOfComments count]).to.equal(2);
        });
        
        it(@"sets all string properties correctly for each dictionary in the submitted array", ^{
            for (FISComment *currentComment in arrayOfComments) {
                expect(currentComment.commentID).to.equal(commentID);
                expect(currentComment.parentID ).to.equal(parentID);
                expect(currentComment.content  ).to.equal(content);
            }
        });
        
        it(@"set all date properties correly for each dictionary in the submitted array", ^{
            for (FISComment *currentComment in arrayOfComments) {
                NSInteger commentCreatedAt = [currentComment.createdAt timeIntervalSince1970];
                NSInteger createdAtEpoch = [createdAt timeIntervalSince1970];
        
                expect(commentCreatedAt).to.beCloseToWithin(createdAtEpoch, 1);
            }
        });
    });
});

SpecEnd
