//
//  FISAppDelegate.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  do not modify

#import <UIKit/UIKit.h>

@class FISStreamsDataManager;

@interface FISAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;

@end

