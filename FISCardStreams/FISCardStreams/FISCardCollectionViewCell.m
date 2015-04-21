//
//  FISCardCollectionViewCell.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardCollectionViewCell.h"
#import "FISCardViewController.h"
#import "FISCard.h"

#import <UIColor+Hex.h>

#import "FISStreamsDataManager.h"
#import "FISCollectionDataManager.h"
#import "NSDate+DateFromJSONDate.h"


@interface FISCardCollectionViewCell ()

//@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;
//@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;


@end



@implementation FISCardCollectionViewCell

-(void)awakeFromNib{
    
    [self.cardTableView setDelegate:self];
    [self.cardTableView setDataSource:self];
    
//    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
//    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.stream.cards count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    FISCard *currentCard = self.stream.cards[indexPath.section];
    
    NSString *gitHubString = @"Github Commit";
    
//    if (currentCard.title == gitHubString) {
        cell.textLabel.text = [NSString stringWithFormat:@"GitHub Commit: %@", currentCard.postAt];
//    }else{
//    cell.textLabel.text = currentCard.title;
//    }
    
    NSDate *postDate = currentCard.postAt;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *shortDate = [dateFormatter stringFromDate:postDate];
    
    cell.detailTextLabel.text = shortDate;
    

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  45;
}


@end
