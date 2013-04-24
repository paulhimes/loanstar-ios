//
//  LoginViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "LoginViewController.h"
#import "UserAccount.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *displayNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    if (currentUserId) {
        [self performSegueWithIdentifier:@"QuickLogin" sender:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Login"]) {
        [[NSUserDefaults standardUserDefaults] setValue:self.displayNameField.text forKey:kCurrentDisplayName];
        [[NSUserDefaults standardUserDefaults] setValue:self.displayNameField.text forKey:kCurrentUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Login"]) {
        if ([self.displayNameField.text length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.displayNameField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
