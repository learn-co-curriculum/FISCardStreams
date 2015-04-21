//
//  FISCardViewController.m
//  FISCardStreams
//
//  Created by Joseph Smalls-Mantey on 4/9/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "FISCardViewController.h"

//collectionview imports
#import "FISCardsTableViewController.h"
#import "FISCardCollectionViewCell.h"
#import "FISCardTableViewCell.h"


//data imports
#import "FISStream.h"
#import "FISCard.h"

//UI pods
#import <RGCardViewLayout.h>
#import <UIColor+Hex.h>
#import <UIColor+uiGradients.h>

//data imports
#import "FISStreamsDataManager.h"
#import "FISCollectionDataManager.h"



@interface FISCardViewController ()

@property (strong, nonatomic) IBOutlet UIView *backgroundGrandientView;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FISCardCollectionViewCell *cardCell;

@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;
@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation FISCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCollectionView];
    [self setUpBackgroundColors];
    [self roundCornersOnCollectionViewCell];
    [self setUpNavigationBarFonts];


    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
}


#pragma mark - Formatting

-(void)roundCornersOnCollectionViewCell{
        self.cardCell.layer.cornerRadius = 5;
        self.cardCell.layer.masksToBounds = YES;
}

-(void)setUpBackgroundColors{
    
    [self.backgroundGrandientView setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.backgroundGrandientView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor]CGColor], nil];
    
    [self.backgroundGrandientView.layer insertSublayer:gradient atIndex:0];
    
}

-(void)setUpNavigationBarFonts{
    
    NSDictionary *barButtonAppearance = @{NSFontAttributeName : [UIFont fontWithName:@"avenir" size:18.0]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearance forState:UIControlStateNormal ];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"avenir" size:22], NSFontAttributeName, nil]];

}


-(void)setUpCollectionView{
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *cardFlow = [[RGCardViewLayout alloc]init];
    self.collectionView.collectionViewLayout = cardFlow;
}

#pragma mark - CollectionView Delegate



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [self.collectionsDataManager.allStreams count];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FISCardCollectionViewCell *cell = [collectionView    dequeueReusableCellWithReuseIdentifier:@"userCell" forIndexPath:indexPath];
    
    FISStream *currentStream = self.collectionsDataManager.allStreams[indexPath.section];
    
    cell.stream = currentStream;
    
    cell.nameField.text = currentStream.streamName;
    
    NSInteger githubCount = [self.collectionsDataManager findCountOfGithubCommitsInLastSevenDaysInCardsArray:currentStream.cards];
    
    cell.gitHubField.text = [NSString stringWithFormat:@"  %ld", (long)githubCount];
    
    
    
    FISCard *stackOverflowCard = [self.collectionsDataManager findMostRecentStackExchangeCardInCardsArray:currentStream.cards];
    
    cell.stackOverflowField.text = [NSString stringWithFormat:@"  %@", stackOverflowCard.cardDescription ];
    
    
    
    FISCard *blogCard = [self.collectionsDataManager findMostRecentBlogCardInCardsArray:currentStream.cards];
    cell.blogField.text = [NSString stringWithFormat:@"  %@", blogCard.title];;
    
    
    return cell;
}




#pragma mark - View Helper Methods

-(void)getAllStreams{
    [self.collectionsDataManager getAllStreamsWithCompletionBlock:^(BOOL success) {
        if (success) {
            NSLog(@"collections fetched");
        } else {
            NSLog(@"collections error");
        }
    }];
}


- (void)getAllCardsForUser {
    [self.streamsDataManager getAllCardsForUserStreamWithCompletion:^(BOOL success) {
        NSLog(@"cards fetched");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Reload tableview");
            self.stream = self.streamsDataManager.userStream;
            self.navigationItem.title = self.stream.streamName;
            [self.tableView reloadData];
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


//#pragma mark - TableView Delegate
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.stream.cards count];
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSLog(@"TABLEVIEW CODE RAN");
//
//    FISCardTableViewCell *cardCell = (FISCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
//
//
//    FISCard *currentCard = self.stream.cards[indexPath.row];
//    cardCell.card = currentCard;
//
//
//    return cardCell;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 176;
//}
