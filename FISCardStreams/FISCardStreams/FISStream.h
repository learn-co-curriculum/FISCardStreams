//
//  FISStream.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import <Foundation/Foundation.h>

@interface FISStream : NSObject

/**
 The unique identity of the Stream.
 */
@property (strong, nonatomic) NSString *streamID;

/**
 Descriptive name of the Stream.
 */
@property (strong, nonatomic) NSString *streamName;

/**
 Detailed description of the Stream.
 */
@property (strong, nonatomic) NSString *streamDescription;

/**
 Date and time when the Stream was created.
 */
@property (strong, nonatomic) NSDate   *createdAt;

/**
 List of cards attributed to the Stream.
 */
@property (strong, nonatomic) NSMutableArray *cards;

- (instancetype)init;

/**
 Designated initializer.
 */
- (instancetype)initWithStreamID:(NSString *)streamID
                      streamName:(NSString *)streamName
               streamDescription:(NSString *)streamDescription
                       createdAt:(NSDate   *)createdAt
                           cards:(NSMutableArray *)cards;

/**
 Generates a Stream from a serialized JSON dictionary response from the CardStream API.
 */
+ (FISStream *)createStreamFromDictionary:(NSDictionary *)streamDictionary;

@end
