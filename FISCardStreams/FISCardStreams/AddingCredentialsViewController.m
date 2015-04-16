//
//  AddingCredentialsViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/8/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.
//

#import "AddingCredentialsViewController.h"

#import "FISConstants.h"

// Frameworks
#import <AFOAuth2Manager.h>
#import <AFNetworking.h>
#import <MONActivityIndicatorView/MONActivityIndicatorView.h>
#import <SSKeychain/SSKeychain.h>

// View controllers
#import "StackSexchangeLoginWebViewController.h"
#import "FISCardstreamLogInViewController.h"
#import "FISCardTableViewController.h"

// Data
#import "FISStreamsDataManager.h"
#import "FISGithubAPIClient.h"
#import "FISStackExchangeAPI.h"

// Models
#import "FISStream.h"

@interface AddingCredentialsViewController () <UITextFieldDelegate>


//Checker Buttons
@property (weak, nonatomic) IBOutlet UIImageView *checkerImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkerImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *mediumChecker;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UITextField *blogTextField;

@property (weak, nonatomic) FISStreamsDataManager *streamsDataManager;
@property (nonatomic) NSString *mediumUsername;
@property(nonatomic)CGPoint originalCenter;

- (IBAction)githubLoginButtonTapped:(id)sender;

@end


@implementation AddingCredentialsViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.streamsDataManager = [FISStreamsDataManager sharedDataManager];
    
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:18.0 green:148.0 blue:199.0 alpha:1.0].CGColor;
    self.logoutButton.layer.borderWidth = 2.0;
    
    [self.blogTextField setDelegate:self];
    self.originalCenter = self.view.center;
    
//    if ([self.presentingViewController isKindOfClass:[FISCardstreamLogInViewController class]]) {
//        
//        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *initialVC = [myStoryboard instantiateInitialViewController];
//        
//        //[self presentViewController:initialVC animated:YES completion:nil];
//        
//        UIApplication *application = [UIApplication sharedApplication];
//        [application.keyWindow setRootViewController:initialVC];
//    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}


-(void)viewDidAppear:(BOOL)animated
{
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];
    if (cred) {
        NSLog(@"animating github checker");
        [self animateCheckMark:self.checkerImage];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *accessToken = [defaults valueForKey:@"access_token"];
    NSString *mediumUsername = [defaults valueForKey:@"medium_username"];
    

    NSString *accessToken = [SSKeychain passwordForService:SOURCE_STACK_EXCHANGE account:self.fisDevUsername];
//    NSString *mediumUsername = [SSKeychain passwordForService:SOURCE_BLOG account:self.fisDevUsername];
    
    if (accessToken) {
        NSLog(@"animating stackoerflow checker");
        [self animateCheckMark:self.checkerImageTwo];
    }
    
    
    if (mediumUsername) {
        self.blogTextField.placeholder = mediumUsername;
        [self animateCheckMark:self.mediumChecker];
    }
    
}


#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.blogTextField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-70);
    } completion:^(BOOL finished) {
    }];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.center = self.originalCenter;
    self.mediumUsername = textField.text;
    
}



#pragma mark - UIButton Actions

- (IBAction)home:(id)sender {
    FISStreamsDataManager *streamsDataManager = [FISStreamsDataManager sharedDataManager];
    
    if (![self.blogTextField.text isEqualToString:@""]) {
        streamsDataManager.blogURL = [NSString stringWithFormat:@"https://medium.com/%@", self.blogTextField.text];
        //[SSKeychain setPassword:self.blogTextField.text forService:SOURCE_BLOG account:self.fisDevUsername];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.blogTextField.text forKey:@"medium_username"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    if ([self.presentingViewController isKindOfClass:[FISCardstreamLogInViewController class]]) {
//        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *initialVC = [myStoryboard instantiateInitialViewController];
//        
//        [self presentViewController:initialVC animated:YES completion:nil];
//        
//        UIApplication *application = [UIApplication sharedApplication];
//        [application.keyWindow setRootViewController:initialVC];
//    }
}


- (IBAction)githubLoginButtonTapped:(id)sender {
    
    [FISGithubAPIClient redirectAfterAuthentication];
}


- (IBAction)stackExchangeLoginButtonTapped:(id)sender {
    
    //[FISStackExchangeAPI redirectAfterAuthentication];
    
    StackSexchangeLoginWebViewController *stackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stackVC"];
    stackVC.fisDevUsername = self.fisDevUsername;
    
    [self presentViewController:stackVC animated:YES completion:nil];
}

- (IBAction)logoutButtonTapped:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Hey Developer!"
                                          message:@"Are You sure you want to Log Out?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NO", @"No action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"No action");
                                       
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"YES", @"YES action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"YES action");
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                   [defaults setValue:@"No" forKey:@"user_logged_in"];

                                   //[defaults removeObjectForKey:@"medium_username"];
                                   // [defaults removeObjectForKey:@"access_token"];git
                                   
                                   [AFOAuthCredential deleteCredentialWithIdentifier:@"githubToken"];
                                   
                                   FISCardstreamLogInViewController *loginVC = [self.storyboard instantiateInitialViewController];
                                   
                                   [self presentViewController:loginVC animated:YES completion:nil];
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)animateCheckMark:(UIImageView *)selectedImage
{
    selectedImage.hidden = NO;
    selectedImage.alpha = 0;
    
    [UIView animateWithDuration:4.0 delay:0.25 options:UIViewAnimationOptionCurveLinear animations:^{
        selectedImage.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)dismissKeyboard {
    [self.blogTextField resignFirstResponder];
}

@end
