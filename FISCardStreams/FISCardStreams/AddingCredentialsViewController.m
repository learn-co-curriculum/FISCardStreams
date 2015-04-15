//
//  AddingCredentialsViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/8/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "AddingCredentialsViewController.h"

// Frameworks
#import <AFOAuth2Manager.h>
#import <AFNetworking.h>
#import <MONActivityIndicatorView/MONActivityIndicatorView.h>

// View controllers
#import "StackSexchangeLoginWebViewController.h"

// Data
#import "FISStreamsDataManager.h"
#import "FISGithubAPIClient.h"
#import "FISStackExchangeAPI.h"

@interface AddingCredentialsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *checkerImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkerImageTwo;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIImageView *settings;

@property (weak, nonatomic) IBOutlet UITextField *blogTextField;

@property (nonatomic) NSString *mediumUsername;
@property(nonatomic)CGPoint originalCenter;

- (IBAction)githubLoginButtonTapped:(id)sender;

@end


@implementation AddingCredentialsViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.homeButton aboveSubview:self.settings];
    // Do any additional setup after loading the view.
    [self.blogTextField setDelegate:self];
    self.originalCenter = self.view.center;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];
    if (cred) {
        self.checkerImage.hidden = NO;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults valueForKey:@"access_token"];
    
    if (accessToken) {
        self.checkerImageTwo.hidden = NO;
    }

}


#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.blogTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-100);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.center = self.originalCenter;
    self.mediumUsername = textField.text;
    
}



#pragma mark - UIButton Actions

- (IBAction)home:(id)sender {
    MONActivityIndicatorView *indicator = [[MONActivityIndicatorView alloc]init];
    [self.view addSubview:indicator];
    
    FISStreamsDataManager *streamsDataManager = [FISStreamsDataManager sharedDataManager];
    
    if (![self.blogTextField.text isEqualToString:@""]) {
        streamsDataManager.blogURL = [NSString stringWithFormat:@"https://medium.com/%@", self.blogTextField.text];
    }
    
    [FISGithubAPIClient getUsernameWithCompletionBlock:^(NSString *username) {
        streamsDataManager.githubUsername = username;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)githubLoginButtonTapped:(id)sender {
    
    [FISGithubAPIClient redirectAfterAuthentication];
}


- (IBAction)stackExchangeLoginButtonTapped:(id)sender {
    
    //[FISStackExchangeAPI redirectAfterAuthentication];
    
    StackSexchangeLoginWebViewController *stackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stackVC"];
    
    [self presentViewController:stackVC animated:YES completion:nil];
}




@end
