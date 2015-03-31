//
//  FISStream.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import "FISStream.h"
#import "FISCard.h"

#import "NSDate+DateFromJSONDate.h"

@implementation FISStream

- (instancetype)init {
    self = [self initWithStreamID:@""
                       streamName:@""
                streamDescription:@""
                        createdAt:[NSDate date]
                            cards:[[NSMutableArray alloc]init] ];
    return self;
}

- (instancetype)initWithStreamID:(NSString *)streamID
                      streamName:(NSString *)streamName
               streamDescription:(NSString *)streamDescription
                       createdAt:(NSDate   *)createdAt
                           cards:(NSMutableArray *)cards {
    self = [super init];
    if (self) {
        _streamID          = streamID;
        _streamName        = streamName;
        _streamDescription = streamDescription;
        _createdAt         = createdAt;
        _cards             = cards;
    }
    return self;
}

+ (FISStream *)createStreamFromDictionary:(NSDictionary *)streamDictionary {
    NSDate *createdAt = [NSDate dateFromJSONDate:streamDictionary[@"createdAt"]];
    
    FISStream *stream = [[FISStream alloc]initWithStreamID:streamDictionary[@"id"]
                                                streamName:streamDictionary[@"name"]
                                         streamDescription:streamDictionary[@"description"]
                                                 createdAt:createdAt
                                                     cards:[[NSMutableArray alloc]init] ];
    return stream;
}

//- (void)initializeCardsFromArray:(NSArray *)cardDictionaries {
//    NSMutableArray *cards = [[NSMutableArray alloc]init];
//    for (NSDictionary *cardDictionary in cardDictionaries) {
//        FISCard *card = [FISCard createCardFromDictionary:cardDictionary];
//        [cards addObject:card];
//    }
//    self.cards
//}

@end
