//
//  WebViewTableViewCell.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/14/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "WebViewTableViewCell.h"
#import "FISCard.h"
@implementation WebViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCard:(FISCard *)card
{
    _card = card;
    
    if (self.card != nil) {
        self.titleLabel.text = self.card.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        if (!self.card.postAt) {
            self.card.postAt = self.card.createdAt;
        }
        self.dateLabel.text = [dateFormatter stringFromDate:self.card.postAt];
        
        [self.blogWebView loadHTMLString:self.card.cardDescription baseURL:nil];
    }

}

@end
