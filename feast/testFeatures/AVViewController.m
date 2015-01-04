//
//  AVViewController.m
//  testFeatures
//
//  Created by Jeffrey Shih on 11/30/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "AVViewController.h"
#import <Parse/Parse.h>

@interface AVViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UILabel *color;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *preferenceField;
@property (strong, nonatomic) IBOutlet UITextField *interestedField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString * usersname;

@end

NSArray *_pickerData;
CLLocation *currentLocation;




@implementation AVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    // Do any additional setup after loading the view.
    
    // Initialize Data
    _pickerData = @[@"Anytime", @"Breakfast", @"Lunch", @"Dinner", @"Drinks"];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.color.text = @"Anytime";
    self.color.textColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
 
    
    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];

 //Keyboard Stuff
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.preferenceField.delegate = self;
    self.interestedField.delegate = self;

    
    //Query for user's name
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"%@", [object objectForKey:@"name"]);
        self.usersname = [object objectForKey:@"name"];
    }];
    
    
    //User stuff
    /*
    PFQuery *prefq = [PFQuery queryWithClassName:@"profilepics"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
            self.preferenceField.text = [object objectForKey:@"pref"];
        }
    }];*/

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (IBAction)submitInfo:(id)sender {
    
    if ([self.preferenceField.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
                                                                       message:@"Fill in a preference (even 'Food')"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(@"Action selected: %@", action.title);
                                                         }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        
        
        PFObject *avail = [PFObject objectWithClassName:@"AvailablePeople"];
        
        avail[@"user"] = [PFUser currentUser];
        
        NSNumber * time;
        
        if ([self.color.text  isEqualToString:@"Anytime"]){
            time = @0;
        }
        else if ([self.color.text  isEqualToString:@"Breakfast"]){
            time = @1;
        }
        else if ([self.color.text  isEqualToString:@"Lunch"]){
            time = @2;
        }
        else if ([self.color.text  isEqualToString:@"Dinner"]){
            time = @3;
        }
        else{
            time = @4;
        }
        
        // Anytime = 0, Breakfast = 1, Lunch = 2, Dinner = 3, Drinks = 4
        
        
        avail[@"range"] = time;
        avail[@"pref"] = self.preferenceField.text;
        avail[@"place"] = self.interestedField.text;
        avail[@"available"] = [NSNumber numberWithBool:YES];
        avail[@"Name"] = self.usersname;
        NSLog(@"STUFF: %@", self.usersname);

        
     //   CLLocationCoordinate2D coordinate = currentLocation.coordinate;
        
        PFGeoPoint *currLoc = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude
                                                        longitude:currentLocation.coordinate.longitude];
        
        avail[@"location"] = currLoc;
        
        NSLog(@"SAVING");
        
        [avail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[error userInfo][@"error"]
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     NSLog(@"Action selected: %@", action.title);
                                                                 }];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            if (succeeded){
                NSLog(@"SAVED");
                
                NSLog(@"%@", currentLocation);

                [[self navigationController] popToRootViewControllerAnimated:YES];
                
                //[self performSegueWithIdentifier:@"returnMain" sender:nil];
            }
            else{
                NSLog(@"Some kind of error occured whilst saving!");
            }
        }];
    
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
        switch(row)
    {
            
        case 0:
            self.color.text = @"Anytime";
            self.color.textColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 1:
            self.color.text = @"Breakfast";
            self.color.textColor = [UIColor colorWithRed:0.0f/255.0f green: 0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 2:
            self.color.text = @"Lunch";
            self.color.textColor = [UIColor colorWithRed:0.0f/255.0f green: 255.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 3:
            self.color.text = @"Dinner";
            self.color.textColor = [UIColor colorWithRed:205.0f/255.0f green:   140.0f/255.0f blue:31.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 4:
            self.color.text = @"Drinks";
            self.color.textColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
            break;
            
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation * newLocation = [locations lastObject];
    
    currentLocation = newLocation;
    
    [self.locationManager stopUpdatingLocation];
}




-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.preferenceField){
        [self.interestedField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
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
