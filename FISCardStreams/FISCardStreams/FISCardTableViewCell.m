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
    
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    
    /* self.containerView.layer.shadowOffset = CGSizeMake(-15, 20);
    self.containerView.layer.shadowRadius = 5;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor*/
    ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Setters

- (void)setCard:(FISCard *)card {
    _card = card;
    
    if (self.card != nil) {
        self.titleLabel.text = self.card.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        if (!self.card.postAt) {
            self.dateLabel.text = [dateFormatter stringFromDate:self.card.createdAt];
        } else {
            self.dateLabel.text = [dateFormatter stringFromDate:self.card.postAt];
        }
        
        self.descriptionLabel.text = self.card.cardDescription;
    }

}

@end
