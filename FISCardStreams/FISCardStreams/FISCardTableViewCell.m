//
//  FISCardTableViewCell.m
//  FISCardStreams
//
//  Created by Mark Murray on 4/3/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardTableViewCell.h"
#import "FISCard.h"
#import <QuartzCore/QuartzCore.h>

@implementation FISCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self roundViewCorners];
    [self drawViewShadow];
    
}


-(void)roundViewCorners{
    self.containerView.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void)drawViewShadow{
    
    //set border shadow
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.containerView.bounds];
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.containerView.layer.shadowOpacity = 0.5f;
    self.containerView.layer.shadowPath = shadowPath.CGPath;
    
    
    //set border color
    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.borderWidth= 0.5f;
    
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
