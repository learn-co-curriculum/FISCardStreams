//
//  FISTableViewCell.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/15/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISTableViewCell.h"

@implementation FISTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier{
    return @"CustomeCell";
}
@end
