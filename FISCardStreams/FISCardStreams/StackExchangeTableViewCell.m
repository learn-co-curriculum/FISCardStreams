//
//  StackExchangeTableViewCell.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/14/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "StackExchangeTableViewCell.h"

@implementation StackExchangeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textView.editable = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
