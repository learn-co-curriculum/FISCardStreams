//
//  FISCardTableViewCell.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/3/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardTableViewCell.h"

#import "FISCard.h"

@implementation FISCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCard:(FISCard *)card {
    _card = card;
    
    if (self.card != nil) {
        self.titleLabel.text = self.card.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        self.dateLabel.text = [dateFormatter stringFromDate:self.card.createdAt];
        
        self.descriptionLabel.text = self.card.cardDescription;
    }

}

@end
