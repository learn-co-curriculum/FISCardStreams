//
//  FISStackExchangeAPI.h
//  FISCardStreams
//
//  Created by Anish Kumar on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISStackExchangeAPI : NSObject


+(NSURLRequest *)redirectAfterAuthentication;


+ (void)getNetworkActivityForCurrentUserWithCompletionBlock:(void (^)(NSArray *userNetworkActivities))completionBlock;


@end
