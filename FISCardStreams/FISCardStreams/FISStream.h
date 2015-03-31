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

@property (strong, nonatomic) NSString *streamID;
@property (strong, nonatomic) NSString *streamName;
@property (strong, nonatomic) NSString *streamDescription;
@property (strong, nonatomic) NSDate   *createdAt;

@property (strong, nonatomic) NSMutableArray *cards;

- (instancetype)init;
- (instancetype)initWithStreamID:(NSString *)streamID
                      streamName:(NSString *)streamName
               streamDescription:(NSString *)streamDescription
                       createdAt:(NSDate   *)createdAt
                           cards:(NSMutableArray *)cards;

+ (FISStream *)createStreamFromDictionary:(NSDictionary *)streamDictionary;

@end
