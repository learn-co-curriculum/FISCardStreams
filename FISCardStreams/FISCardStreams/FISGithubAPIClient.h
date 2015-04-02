//
//  FISGithubAPIClient.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Anish

#import <Foundation/Foundation.h>
#import "FISConstants.h"

@interface FISGithubAPIClient : NSObject

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *repoDictionaries))completionBlock;


@end
