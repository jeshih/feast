//
//  RegViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 11/30/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "RegViewController.h"
#import <Parse/Parse.h>

@interface RegViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UITextField *conPassField;
@property (strong, nonatomic) IBOutlet UITextField *numberField;

@property (strong, nonatomic) IBOutlet UIButton *regButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    self.numberField.delegate = self;
    self.emailField.delegate = self;
    self.passField.delegate = self;
    self.conPassField.delegate = self;
    self.nameField.delegate = self;
    
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.layer.borderWidth = 2;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.regButton.layer.cornerRadius = 2;
    self.regButton.layer.borderWidth = 2;
    self.regButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registratrion:(id)sender {
    
    
    NSString *username = self.emailField.text;
    NSString *password = self.passField.text;
    NSString *passwordAgain = self.conPassField.text;
    NSString *email = self.emailField.text;
    NSString *phoneNum = self.numberField.text;
    
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
            [self.conPassField becomeFirstResponder];
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
    user[@"phone"] = [_numberField text];
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
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            [self performSegueWithIdentifier:@"fromRegSegue" sender:nil];

        }
    }];
}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.nameField){
        [self.emailField becomeFirstResponder];
    }
    else if (textField == self.emailField){
        [self.passField becomeFirstResponder];
    }
    else if (textField == self.passField){
        [self.conPassField becomeFirstResponder];
    }
    else if (textField == self.conPassField){
        [self.numberField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return NO;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
