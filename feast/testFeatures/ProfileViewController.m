//
//  ProfileViewController.m
//  feast
//
//  Created by Jeffrey Shih on 12/2/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>


@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PFQuery * userQuery;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.saveButton.layer.cornerRadius = 2;
    self.saveButton.layer.borderWidth = 2;
    self.saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    //Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
//    self.preferenceField.delegate = self;
    
    
    //Query for user's name
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"%@", [object objectForKey:@"name"]);
        self.personLabel.text = [object objectForKey:@"name"];
        self.mailLabel.text = [object objectForKey:@"email"];
        self.numberLabel.text = [object objectForKey:@"phone"];
    }];
    
    [self showPhoto];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPhoto{ //updates Photo for entry
    
    PFQuery *query = [PFQuery queryWithClassName:@"profilepics"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    
    NSLog(@"getting query for user");
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
            NSLog(@"HELLO");
                PFFile *userPic = object[@"pic"];
                [userPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        NSLog(@"Getting photo");
                        self.image = [UIImage imageWithData:imageData];
                        self.imageView.image = self.image;
                      //  self.preferenceField.text = [object objectForKey:@"pref"];
                    }
                }];
        }
        else{
            NSLog(@"%@", error);
        }
        
    }];
    
     
}

-(IBAction) save:(id) sender{
    UIImage *imageToSave = self.imageView.image;
    if (imageToSave){
//        if ([self.preferenceField.text isEqualToString:@""]){
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
//                                                                           message:@"Fill in a preference (even 'Anything')"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action) {
//                                                                 NSLog(@"Action selected: %@", action.title);
//                                                             }];
//            [alert addAction:okAction];
//            
//            [self presentViewController:alert animated:YES completion:nil];
//        }
        
        PFObject * profilePics = [PFObject objectWithClassName:@"profilepics"];
        NSData *imageData = UIImagePNGRepresentation(imageToSave);
        PFFile *pic = [PFFile fileWithName:@"image.png" data:imageData];
        
        profilePics[@"pic"] = pic;
        profilePics[@"user"] = [PFUser currentUser];
      //  profilePics[@"pref"] = self.preferenceField.text;

        [profilePics saveInBackground];


        [[self navigationController] popToRootViewControllerAnimated:YES];

    }
    
}

- (IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhoto = [[UIActionSheet alloc] initWithTitle:@"How do you want to select a picture?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Picture", @"Choose Picture", nil];
    [choosePhoto showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePicture];
    } else if (buttonIndex == 1) {
        [self choosePicture];
    }
}


- (void)takePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"This device does not seem to have a camera."
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
        [noCamera show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}

- (void)choosePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}


- (BOOL)verifyPermissions
{
    CLAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status != kCLAuthorizationStatusAuthorized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please give this app permission to access your photo library in your settings app!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                       message:@"Seems like picking a photo didn't really work out for you."
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
    [noCamera show];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        [textField resignFirstResponder];
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
