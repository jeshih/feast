//
//  FeatsViewController.m
//  feast
//
//  Created by Jeffrey Shih on 12/3/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "FeatsViewController.h"
#import "MapViewController.h"

@interface FeatsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UILabel *theirPrefLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString * name1;
@property (strong, nonatomic) NSString * name2;
@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UIButton *finishButton;

@end

@implementation FeatsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1]];
    
    NSLog(@"%@", self.tableEntity);
    
    
    

    NSLog(@"Obj id: %@", [self.tableEntity objectId]);
    // Do any additional setup after loading the view.
    
    
    //Query for user's name
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
       NSLog(@"%@", [object objectForKey:@"name"]);
        self.name1 = [object objectForKey:@"name"];
        
        if ([[self.tableEntity objectForKey:@"name1"] isEqualToString:self.name1]){
            
            self.personLabel.text = [self.tableEntity objectForKey:@"name2"];
            self.otherUser = [self.tableEntity objectForKey:@"user2"];
        }
        else{
            self.personLabel.text = [self.tableEntity objectForKey:@"name1"];
            self.otherUser = [self.tableEntity objectForKey:@"user1"];
        }
        
        [self showPhoto];

    }];

    
//    self.personLabel.text = [self.tableEntity objectForKey:@"Name"];
    self.theirPrefLabel.text = [self.tableEntity objectForKey:@"type"];
    self.placeLabel.text = [self.tableEntity objectForKey:@"location"];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPhoto{ //updates Photo for entry
    
    PFQuery *query = [PFQuery queryWithClassName:@"profilepics"];
    //    PFUser *user = [self.tableEntity objectForKey:@"user"];
    //    NSLog(@"%@", [self.tableEntity objectForKey:@"user"]);
    [query whereKey:@"user" equalTo:self.otherUser];
    
    NSLog(@"getting query for user");
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error){
            // NSLog(@"Obj id: %@", [object objectId]);
            PFFile *userPic = object[@"pic"];
            [userPic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *errors) {
                if (!errors) {
                    self.image = [UIImage imageWithData:imageData];
                    self.imageView.image = self.image;
                }
                else{
                    NSLog(@"%@", errors);
                    
                }
            }];
        }
        else{
            NSLog(@"%@", error);
        }
        
    }];
    
    
}

- (IBAction)finishUp:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Feast"];
    
    [query getObjectInBackgroundWithId:[self.tableEntity objectId] block:^(PFObject *entry, NSError *error) {
        
        [entry deleteInBackground];
        
    }];

    
    [[self navigationController] popToRootViewControllerAnimated:YES];

}


- (IBAction)showLocation:(id)sender {

    [self performSegueWithIdentifier:@"seeMap" sender:self];
    //
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"seeMap"]) {
        
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        
        
        MapViewController *destViewController = segue.destinationViewController;
        
        destViewController.loc = [self.tableEntity objectForKey:@"location"];
        destViewController.pref = [self.tableEntity objectForKey:@"type"];

        
    }
    
}


@end
