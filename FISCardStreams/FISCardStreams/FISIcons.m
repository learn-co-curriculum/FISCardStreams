//
//  FISIcons.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/16/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISIcons.h"
#import "FISCard.h"
#import "FISConstants.h"

@implementation FISIcons

-(UIImage *)getIconForSource:(FISCard *)card{
    
    UIImage *requstedIcon = [[UIImage alloc]init];
    
    NSString *sourceString =  [[NSString alloc] initWithString:card.source];
    
    if (sourceString == SOURCE_GITHUB)
    {
        requstedIcon = [UIImage imageNamed:@"Gituhub"];
    }
    else if (sourceString == SOURCE_BLOG)
    {
        requstedIcon = [UIImage imageNamed:@"Blog"];
    }
    
    else if (sourceString == SOURCE_STACK_EXCHANGE)
    {
        requstedIcon = [UIImage imageNamed:@"Stackoverflow"];
    }
    else {
        return nil;
    }
    return requstedIcon;
}

@end
