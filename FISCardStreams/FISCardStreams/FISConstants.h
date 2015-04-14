//
//  FISConstants.h
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Anish

#import <Foundation/Foundation.h>

@interface FISConstants : NSObject

extern NSString *const CARDSTREAMS_BASE_URL;

// Mark's API credentials
extern NSString *const CARDSTREAMS_APP_ID_MARK;
extern NSString *const CARDSTREAMS_KEY_MARK;

// Anish's API credentials
extern NSString *const CARDSTREAMS_APP_ID_ANISH;
extern NSString *const CARDSTREAMS_KEY_ANISH;


/**
 *  Main Cardstream Credentials
 
 */

extern NSString *const CARDSTREAMS_APP_ID;
extern NSString *const CARDSTREAMS_KEY;


/**
 
*  FISCardStreams' official Github credentials.
   Callback URI: FISCardStreams://callback
 
 */

extern NSString *const GITHUB_API_URL;
extern NSString *const GITHUB_CLIENT_SECRET;
extern NSString *const GITHUB_CLIENT_ID;


/**
 *  FISCardStream' official Stack Exchange credentials.
    Callback URI: FISCardStreams://callback
    View here: https://stackapps.com/apps/oauth/view/4607

 */
extern NSString *const STACKEXCHANGE_BASE_URL;
extern NSString *const STACKEXCHANGE_CLIENT_ID;
extern NSString *const STACKEXCHANGE_CLINET_SECRET;
extern NSString *const STACKEXCHANGE_KEY;

extern NSString *const SOURCE_BLOG;
extern NSString *const SOURCE_GITHUB;
extern NSString *const SOURCE_STACK_EXCHANGE;

@end
