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

@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;
@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;

@end



@implementation FISCardCollectionViewCell

-(void)awakeFromNib{
    
    [self.cardTableView setDelegate:self];
    [self.cardTableView setDataSource:self];
    
    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    
    FISCard *currentCard = self.stream.cards[indexPath.row];
    
    cell.textLabel.text = currentCard.title;
    NSString *date = [NSDate dateAsJSONDate:currentCard.postAt];
    cell.detailTextLabel.text = date;
    
    
    

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  45;
}


@end
