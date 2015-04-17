//
//  FISCardstreamSignUpViewController.m
//  FISCardStreams
//
//  Created by Anish Kumar on 4/2/15.
//  Copyright (c) 2015 Mark Edward Murray. All rights reserved.

//  Coded by Anish Kumar

#import <MONActivityIndicatorView.h>

#import "FISCardstreamSignUpViewController.h"

#import "AddingCredentialsViewController.h"
#import "FISStreamsDataManager.h"
#import "FISCardStreamsAPIClient.h"
#import "FISStream.h"

@interface FISCardstreamSignUpViewController () <UITextFieldDelegate>


@property (nonatomic) FISStreamsDataManager *dataManager;
@property (nonatomic) FISStream *streamToPass;


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic) MONActivityIndicatorView *indicatorView;

@end


@implementation FISCardstreamSignUpViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [FISStreamsDataManager sharedDataManager];
    
    self.usernameTextField.delegate = self;
    
    self. indicatorView = [[MONActivityIndicatorView alloc] init];
    [self.view addSubview:self.indicatorView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.usernameTextField resignFirstResponder];
    return YES;
}


#pragma mark - UIButton Actions

- (IBAction)cancelButtonTapped:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)signUpButtonTapped:(id)sender {
    
    [self.indicatorView startAnimating];
    [self checkForUsernameUniquenessAndSignUserUp];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"Yes" forKey:@"user_logged_in"];
    
}


#pragma mark - View Helper Methods

-(void)takeMeToCredentialPage
{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"LoginFlow" bundle:nil];
    UINavigationController *navController = [myStoryboard instantiateInitialViewController];
    AddingCredentialsViewController *homePage = [myStoryboard instantiateViewControllerWithIdentifier:@"credentialVC"];
    
    homePage.fisDevUsername = self.usernameTextField.text;
    
    UIApplication *application = [UIApplication sharedApplication];
    [application.keyWindow setRootViewController:navController];
    
    [self presentViewController:homePage animated:YES completion:nil];

}


-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
}


#pragma mark - UIButton Helper Method

- (void)checkForUsernameUniquenessAndSignUserUp {
    [FISCardStreamsAPIClient getAllStreamsAndCheckWithUsername:self.usernameTextField.text CompletionBlock:^(FISStream *stream) {
        
        [self.indicatorView stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup failed"
                                                        message:@"Username is already taken"
                                                       delegate:self
                                              cancelButtonTitle:@"Try Again"
                                              otherButtonTitles:nil];
        [alert show];
    }SecondCompletionBlock:^(BOOL unique) {
        
        if (unique == NO) {
            
            NSString *username = [self validateUserName:self.usernameTextField.text];
            
            [FISCardStreamsAPIClient createAStreamForName:username WithCompletionBlock:^(FISStream *userStream) {
                NSLog(@"Signed UP");
                self.dataManager.userStream = userStream;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if(![defaults valueForKey:@"fisdev_username"])
                {
                    [defaults setValue:username forKey:@"fisdev_username"];
                }
                
                [self takeMeToCredentialPage];
                [self.indicatorView stopAnimating];
                
            }];
        }
    }];
}


- (NSString *)validateUserName:(NSString *)usernameBeforeValidation
{
    if ([self.usernameTextField.text containsString:@" "]) {
        NSString *usernameToReturn = [self.usernameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        return usernameToReturn;
    }
    
    else{
        return self.usernameTextField.text;
    }
}

@end
