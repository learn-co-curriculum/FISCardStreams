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
    
//    [self.indicatorView startAnimating];
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

#pragma mark - UIButton Helper Method

- (void)checkForUsernameUniquenessAndSignUserUp {
    [FISCardStreamsAPIClient getAllStreamsAndCheckWithUsername:self.usernameTextField.text CompletionBlock:^(FISStream *stream) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup failed"
                                                        message:@"Username is already taken"
                                                       delegate:self
                                              cancelButtonTitle:@"Try Again"
                                              otherButtonTitles:nil];
        [alert show];
    }SecondCompletionBlock:^(BOOL unique) {
        
        if (unique == NO) {
            
            [self validateUserName:self.usernameTextField.text];
            NSLog(@"my username %@", self.usernameTextField.text);
            
            if ([self validateUserName:self.usernameTextField.text] == YES)
            {
                [self.indicatorView startAnimating];
                NSLog(@"found the correct answer");
                [FISCardStreamsAPIClient createAStreamForName:self.usernameTextField.text WithCompletionBlock:^(FISStream *userStream) {
                    NSLog(@"Signed UP");
                    self.dataManager.userStream = userStream;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    if(![defaults valueForKey:@"fisdev_username"])
                    {
                        [defaults setValue:self.usernameTextField.text forKey:@"fisdev_username"];
                    }
                    
                    [self takeMeToCredentialPage];
                    [self.indicatorView stopAnimating];
                    
                }];
            }
            
        }
    }];
}


- (BOOL)validateUserName:(NSString *)usernameBeforeValidation
{
    BOOL isAccepted = NO;
    if ([self.usernameTextField.text containsString:@" "]) {
        NSString *usernameToReturn = [self.usernameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        self.usernameTextField.text =  usernameToReturn;
        isAccepted = YES;
    }
    else if([self.usernameTextField.text containsString:@"%"] || [self.usernameTextField.text containsString:@"&"] || [self.usernameTextField.text containsString:@"?"] || [self.usernameTextField.text containsString:@"/"] ||[self.usernameTextField.text isEqualToString:@"+"] )
    {
        
        [self showAlertForIncorrectUsername];
        isAccepted = NO;
        ;
    }
    else
    {
        isAccepted = YES;
    }
    return isAccepted;
    
}

-(void)showAlertForIncorrectUsername
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect Username" message:@"Please use alphanumeric only" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
