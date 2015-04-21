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
#import "FISCardstreamLogInViewController.h"
#import <SSKeychain.h>

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

#import "FISConstants.h"




@interface FISCardsTableViewController ()

@property (strong, nonatomic) FISStreamsDataManager *streamsDataManager;
@property (strong, nonatomic) FISCollectionDataManager *collectionsDataManager;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settings;

- (IBAction)searchTapped:(id)sender;

@property (nonatomic) BOOL githubUpdateIsComplete;
@property (nonatomic) BOOL rssUpdateIsComplete;
@property (nonatomic) BOOL stackExchangeUpdateIsComplete;

@end



@implementation FISCardsTableViewController


#pragma mark - View Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.streamsDataManager.userStream.streamName;
    
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
    self.collectionsDataManager = [FISCollectionDataManager sharedDataManager];
    
    [self addingPullToRefreshFeatureToTheTableViews];
    [self setUpNavigationBarFonts];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    UIImageView *pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings"]];
    [pic setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x,self.navigationController.navigationBar.frame.origin.y -10,30,30)];
    [pic setBackgroundColor:[UIColor clearColor]];
    pic.layer.cornerRadius = pic.frame.size.width / 2;
    pic.layer.masksToBounds = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.settings.image = [UIImage imageNamed:@"settings"];
    
}

-(void)setUpNavigationBarFonts{
    
    NSDictionary *barButtonAppearance = @{NSFontAttributeName : [UIFont fontWithName:@"avenir" size:18.0]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearance forState:UIControlStateNormal ];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"avenir" size:22], NSFontAttributeName, nil]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getAllCardsForUser];
    
    [self getAllStreams];
    
    [self setUpNavigationBarFonts];

    
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.streamsDataManager.userStream.cards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FISCard *currentCard = self.streamsDataManager.userStream.cards[indexPath.row];
    
    if ([currentCard.source isEqualToString:SOURCE_BLOG]) {
        
        WebViewTableViewCell *webCell = (WebViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"blogCell" forIndexPath:indexPath];
        
        webCell.card = currentCard;
        NSString *blog = @"Blog: ";
        webCell.titleLabel.text = [blog stringByAppendingString:currentCard.title];
        
        return webCell;
    }
    if([currentCard.source isEqualToString:SOURCE_STACK_EXCHANGE])
    {
        WebViewTableViewCell *stackCell = (WebViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"blogCell" forIndexPath:indexPath];
        stackCell.card = currentCard;
        return stackCell;
    }
    else {
        
        FISCardTableViewCell *cardCell = (FISCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"githubCell" forIndexPath:indexPath];
        cardCell.card = currentCard;
        
        return cardCell;
        
    }
    
}


#pragma mark - UIButton Actions

- (void)updateCardsForAllAccounts {
    self.githubUpdateIsComplete = NO;
    self.rssUpdateIsComplete = NO;
    self.stackExchangeUpdateIsComplete = NO;
    
    [self.streamsDataManager updateRSSFeedWithCompletionBlock:^(NSArray *newBlogCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newBlogCards];
        self.rssUpdateIsComplete = YES;
        NSLog(@"RSS Updated");
        [self reloadTableViewIfAllUpdatesAreComplete];
    }];
    
    if (self.streamsDataManager.githubUsername) {
        [self updateGithubCards];
    } else {
        NSLog(@"Fetching github username");
        [self.streamsDataManager getUsernameFromGithubWithCompletionBlock:^(BOOL success) {
            [self updateGithubCards];
        }];
    }
    
    [self.streamsDataManager updateStackExchangeFeedWithCompletionBlock:^(NSArray *newStackExchangeCards, BOOL success) {
        if (success) {
            [self.streamsDataManager.userStream.cards addObjectsFromArray:newStackExchangeCards];
            self.stackExchangeUpdateIsComplete = YES;
            NSLog(@"Stack Exchange updated");
            [self reloadTableViewIfAllUpdatesAreComplete];
        } else {
            self.stackExchangeUpdateIsComplete = YES;
        }
    }];
}


- (void)updateGithubCards {
    [self.streamsDataManager updateGithubFeedWithCompletionBlock:^(NSArray *newGithubCards) {
        [self.streamsDataManager.userStream.cards addObjectsFromArray:newGithubCards];
        self.githubUpdateIsComplete = YES;
        NSLog(@"Github updated");
        [self reloadTableViewIfAllUpdatesAreComplete];
    }];
}


- (void)reloadTableViewIfAllUpdatesAreComplete {
    if (self.githubUpdateIsComplete &&
        self.rssUpdateIsComplete &&
        self.stackExchangeUpdateIsComplete) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSSortDescriptor *postAtSorter = [NSSortDescriptor sortDescriptorWithKey:@"postAt" ascending:NO];
            NSArray *allCardsSortedByPostAt = [self.streamsDataManager.userStream.cards sortedArrayUsingDescriptors:@[postAtSorter]];
            self.streamsDataManager.userStream.cards = [[NSMutableArray alloc]initWithArray:allCardsSortedByPostAt];
            [self.tableView reloadData];
        }];
    }
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
        [self updateCardsForAllAccounts];
        
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Reload tableview");
            self.navigationItem.title = self.streamsDataManager.userStream.streamName;
            
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
    [self getAllCardsForUser];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    FISCardViewController *cardVC = segue.destinationViewController;
}



@end
