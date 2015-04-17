//
//  FISStreamSpec.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/16/15.
//  Copyright 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import "Expecta.h"

#import "FISStream.h"

#import "NSDate+DateFromJSONDate.h"


SpecBegin(FISStream)

describe(@"FISStream", ^{
    
    __block NSString       *streamID;
    __block NSString       *streamName;
    __block NSString       *streamDescription;
    __block NSDate         *createdAt;
    __block NSMutableArray *cards;
    
    __block NSString       *jsonCreatedAt;
    __block NSDictionary   *streamDictionary;
    
    __block NSDictionary   *streamDictionary2;
    __block NSArray        *streamDictionaries;
    
    __block FISStream      *defaultStream;
    __block FISStream      *designatedStream;
    __block FISStream      *dictionaryStream;
    __block NSArray        *arrayOfStreams;
    
    beforeEach(^{
        streamID          = @"streamID";
        streamName        = @"streamName";
        streamDescription = @"streamDescription";
        createdAt         = [NSDate date];
        cards             = [[NSMutableArray alloc]init];
        
        jsonCreatedAt     = [NSDate dateAsJSONDate:createdAt];
        
        streamDictionary  = @{ @"id"          : streamID,
                               @"name"        : streamName,
                               @"description" : streamDescription,
                               @"createdAt"   : jsonCreatedAt     };
        
        streamDictionary2  = [streamDictionary copy];
        streamDictionaries = @[streamDictionary, streamDictionary2];
        
        defaultStream = [[FISStream alloc]init];
        
        designatedStream =
        [[FISStream alloc]initWithStreamID:streamID
                                streamName:streamName
                         streamDescription:streamDescription
                                 createdAt:createdAt
                                     cards:cards];
        
        dictionaryStream =
        [FISStream createStreamFromDictionary:streamDictionary];
        
        arrayOfStreams =
        [FISStream createArrayOfStreamsFromDictionaries:streamDictionaries];
    });
    
    describe(@"default initializer", ^{
        it(@"sets default values to all properties", ^{
            expect(defaultStream.streamID         ).to.equal(@"");
            expect(defaultStream.streamName       ).to.equal(@"");
            expect(defaultStream.streamDescription).to.equal(@"");
            expect(defaultStream.createdAt).to.beKindOf([NSDate class]);
            expect(defaultStream.cards).to.equal([NSMutableArray new]);
        });
    });
    
    describe(@"designated initializer", ^{
        it(@"sets submitted values to all properties", ^{
            expect(designatedStream.streamID         ).to.equal(streamID);
            expect(designatedStream.streamName       ).to.equal(streamName);
            expect(designatedStream.streamDescription).to.equal(streamDescription);
            expect(designatedStream.createdAt        ).to.equal(createdAt);
            expect(designatedStream.cards            ).to.equal(cards);
        });
    });
    
    describe(@"class initializer", ^{
        it(@"sets properties correctly from a dictionary", ^{
            expect(designatedStream.streamID         ).to.equal(streamID);
            expect(designatedStream.streamName       ).to.equal(streamName);
            expect(designatedStream.streamDescription).to.equal(streamDescription);
            expect(designatedStream.cards            ).to.equal(cards);
        });
        it(@"sets date property correctly", ^{
            NSInteger streamCreatedAt = [dictionaryStream.createdAt timeIntervalSince1970];
            NSInteger createdAtEpoch = [createdAt timeIntervalSince1970];
            
            expect(streamCreatedAt).to.beCloseToWithin(createdAtEpoch, 1);
        });
    });
    
    describe(@"class array initializer", ^{
        it(@"has the correct number of objects", ^{
            expect([arrayOfStreams count]).to.equal(2);
        });
        it(@"sets properties correctly from a dictionary", ^{
            for (FISStream *currentStream in arrayOfStreams) {
                expect(currentStream.streamID         ).to.equal(streamID);
                expect(currentStream.streamName       ).to.equal(streamName);
                expect(currentStream.streamDescription).to.equal(streamDescription);
                expect(currentStream.cards            ).to.equal(cards);
            }
        });
        it(@"sets date property correctly", ^{
            for (FISStream *currentStream in arrayOfStreams) {
                NSInteger streamCreatedAt = [currentStream.createdAt timeIntervalSince1970];
                NSInteger createdAtEpoch = [createdAt timeIntervalSince1970];
                
                expect(streamCreatedAt).to.beCloseToWithin(createdAtEpoch, 1);
            }
        });
    });

});

SpecEnd
