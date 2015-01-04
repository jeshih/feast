//
//  ResetViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 12/1/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "ResetViewController.h"
#import <Parse/Parse.h>


@interface ResetViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    self.emailField.delegate = self;
    
    self.resetButton.layer.cornerRadius = 2;
    self.resetButton.layer.borderWidth = 2;
    self.resetButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.layer.borderWidth = 2;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
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

- (IBAction)reset:(id)sender {
    
    if ([self.emailField.text isEqualToString:@""] || ![self.emailField.text containsString:@"@"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                       message:@"Fill in an email address"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(@"Action selected: %@", action.title);
                                                         }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [PFUser requestPasswordResetForEmailInBackground:self.emailField.text];
        
        [self performSegueWithIdentifier:@"resetSegue" sender:nil];
    }
    
   
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
