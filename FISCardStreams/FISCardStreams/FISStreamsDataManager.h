//
//  FISStreamsDataManager.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FISStream;

@interface FISStreamsDataManager : NSObject

@property (strong, nonatomic) NSMutableArray *streams; // may be going unused

@property (strong, nonatomic) NSString *streamID;
@property (strong, nonatomic) FISStream *userStream;

@property (strong, nonatomic) NSString *blogURL;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

+ (instancetype)sharedDataManager;

- (void)generateTestData;

- (void)getStreamForStreamIDWithCompletion:(void (^)(BOOL success))completionBlock;
- (void)getAllCardsForUserStreamWithCompletion:(void (^)(BOOL success))completionBlock;

- (void)updateRSSFeedWithCompletionBlock:(void (^)(NSArray *newBlogCards))completionBlock;

- (void)updateStackExchangeNetworkActivityWithCompletionBlock:(void (^)(NSArray *newStackExchangeCards))completionBlock;

@end
