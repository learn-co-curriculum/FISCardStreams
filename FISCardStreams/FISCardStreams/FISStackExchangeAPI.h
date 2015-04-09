//
//  FISStackExchangeAPI.h
//  FISCardStreams
//
//  Created by Anish Kumar on 4/8/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISStackExchangeAPI : NSObject

+ (void)getNetworkActivityForCurrentUserWithToken:(NSString *)token completionBlock:(void (^)(NSArray *items))completionBlock;

@end
