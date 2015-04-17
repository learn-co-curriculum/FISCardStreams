//
//  FISIcons.h
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/16/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISCard.h"
#import <UIKit/UIKit.h>

@interface FISIcons : NSObject

-(UIImage *)getIconForSource:(FISCard *)card;


@end
