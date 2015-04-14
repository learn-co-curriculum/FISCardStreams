//
//  FISCardCollectionViewCell.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardCollectionViewCell.h"
#import <UIColor+Hex.h>

@interface FISCardCollectionViewCell ()

@end



@implementation FISCardCollectionViewCell


-(void)awakeFromNib{
    [self setupBackgroundColors];
    
}

-(void)setupBackgroundColors{
    
    UIColor *themeBlue = [UIColor colorFromHex:@"208D90"];
    
    self.bottomContainer.backgroundColor = themeBlue;
    
    

    
}
@end
