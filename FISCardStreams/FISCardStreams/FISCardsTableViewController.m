//
//  FISCardsTableViewController.m
//  FISCardStreams
//
//  Created by Mark Murray on 3/31/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//
//  assigned to Mark (temp)



#import "FISCardsTableViewController.h"
#import "FISCardViewController.h"
#import "AddingCredentialsViewController.h"

#import "FISStreamsDataManager.h"
#import "FISCollectionDataManager.h"

// Custom Cells
#import "FISCardTableViewCell.h"
#import "WebViewTableViewCell.h"
#import "StackExchangeTableViewCell.h"

// Models
#import "FISStreamsDataManager.h"
#import "FISStream.h"
#import "FISCard.h"

#import <AFOAuth2Manager.h>




@interface FISCardsTableViewController ()

@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;
@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)refreshTapped:(id)sender;
- (IBAction)searchTapped:(id)sender;

@end



@implementation FISCardsTableViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingPullToRefreshFeatureToTheTableViews];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
    
    
    [self getAllCardsForUser];
    [self getAllStreams];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stream.cards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FISCard *currentCard = self.stream.cards[indexPath.row];

    //FIXME github Constants

    if ([currentCard.source isEqualToString:@"blog"]) {
        WebViewTableViewCell *webCell = (WebViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"weCardCell" forIndexPath:indexPath];
        webCell.card = currentCard;

            return webCell;
    }
    if([currentCard.source isEqualToString:@"stack_exchange"])
    {
        StackExchangeTableViewCell *stackCell = (StackExchangeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"stackCardCell" forIndexPath:indexPath];
        stackCell.card = currentCard;
        return stackCell;
    }
    else {
    
    FISCardTableViewCell *cardCell = (FISCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    cardCell.card = currentCard;
    
    return cardCell;
    
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - UIButton Actions

- (IBAction)refreshTapped:(id)sender {
    [self.streamsDataManager updateRSSFeedWithCompletionBlock:^(NSArray *newBlogCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newBlogCards];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
    [self.streamsDataManager updateGithubFeedWithCompletionBlock:^(NSArray *newGithubCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newGithubCards];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
    [self.streamsDataManager updateStackExchangeFeedWithCompletionBlock:^(NSArray *newStackExchangeCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newStackExchangeCards];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

- (IBAction)settingsButtonTapped:(id)sender {
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginFlow" bundle:nil];
    UIViewController *settings = [loginStoryboard instantiateViewControllerWithIdentifier:@"credentialVC"];
    
    [self presentViewController:settings animated:YES completion:nil];
    
}

- (IBAction)searchTapped:(id)sender {
    
}


#pragma mark - View Helper Methods

- (void)getAllCardsForUser {
    [self.streamsDataManager getAllCardsForUserStreamWithCompletion:^(BOOL success) {
        NSLog(@"cards fetched");
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Reload tableview");
            self.stream = self.streamsDataManager.userStream;
            self.navigationItem.title = self.stream.streamName;
            
            [self.tableView reloadData];
        }];
    }];
}

-(void)getAllStreams{
    [self.collectionsDataManager getAllStreamsWithCompletionBlock:^(BOOL success) {
        if (success) {
            NSLog(@"collections fetched");
        } else {
            NSLog(@"Error fetching all streams.");
        }
    }];
}


- (void)addingPullToRefreshFeatureToTheTableViews {
    //Pull to refresh for tableviews
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)refresh
{
    // do your refresh here and reload the tablview
    [self viewWillAppear:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FISCardViewController *cardVC = segue.destinationViewController;
}



@end
