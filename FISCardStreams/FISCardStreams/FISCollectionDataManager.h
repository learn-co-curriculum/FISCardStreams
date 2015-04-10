//
//  FISCollectionDataManager.h
//  FISCardStreams
//
//  Created by Mark Murray on 4/10/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISCollectionDataManager : NSObject

@property (strong, nonatomic) NSArray *allStreams;

+ (instancetype)sharedDataManager;

- (void)fetchAllStreamsWithCompletionBlock:(void (^)(NSArray *allStreams, BOOL success))completionBlock;

@end
