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

@property (strong, nonatomic) NSString *streamName;
@property (strong, nonatomic) NSString *streamDescription;
@property (strong, nonatomic) NSString *streamID;
@property (strong, nonatomic) NSDate *createdAt;

- (instancetype)initWithStreamName:(NSString *)streamName
                 streamDescription:(NSString *)streamDescription
                          streamID:(NSString *)streamID
                         createdAt:(NSDate *)createdAt;

@end
