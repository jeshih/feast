//
//  NewUserViewController.m
//  FEAST
//
//  Created by Jeffrey Shih on 11/13/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "NewUserViewController.h"

@interface NewUserViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *regButton;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassField;


@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1]];
    
    
    self.regButton.layer.cornerRadius = 2;
    self.regButton.layer.borderWidth = 2;
    self.regButton.layer.borderColor = [UIColor whiteColor].CGColor;
    

    
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.layer.borderWidth = 2;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = [_emailField text];
    user.password = [_passField text];
    user.email = [_emailField text];
    
    // other fields can be set just like with PFObject
    user[@"phone"] = [_phoneField text];
    user[@"name"] = [_nameField text];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Proceed to main screen.
        } else {
//            NSString *errorString = [error userInfo][@"error"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Already Exists"
                                                                           message:@"Unfortunately that user name has already been taken!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 NSLog(@"Action selected: %@", action.title);
                                                             }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


- (void)processFieldEntries {
    NSString *username = self.emailField.text;
    NSString *password = self.passField.text;
    NSString *passwordAgain = self.confirmPassField.text;
    NSString *email = self.emailField.text;
    NSString *phoneNum = self.phoneField.text;
    
    NSString *errorText = @"Please ";
    NSString *emailBlankText = @"enter an email";
    NSString *passwordBlankText = @"enter a password";
    NSString *phoneBlankText = @"enter a phone number";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (passwordAgain.length == 0) {
            [self.confirmPassField becomeFirstResponder];
        }
        if (password.length == 0) {
            [self.passField becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.emailField becomeFirstResponder];
        }
        
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:emailBlankText];
        }
        if (phoneNum.length == 0) {
            errorText = [errorText stringByAppendingString:phoneBlankText];
        }
        if (password.length == 0 || passwordAgain.length == 0) {
            if (username.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame) {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.passField becomeFirstResponder];
    }
    
    if (textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = [_emailField text];
    user.password = [_passField text];
    user.email = [_emailField text];
    
    // other fields can be set just like with PFObject
    user[@"phone"] = [_phoneField text];
    user[@"name"] = [_nameField text];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            // Display an alert view to show the error message
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            // Bring the keyboard back up, because they probably need to change something.
            [self.emailField becomeFirstResponder];
            return;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.delegate newUserViewControllerDidSignup:self];

    }];
    
     
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // do stuff
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
