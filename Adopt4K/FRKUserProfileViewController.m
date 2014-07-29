//
//  FRKUserProfileViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/28/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKUserProfileViewController.h"
#import "Userprofile.h"
#import "FRKAppDelegate.h"

@interface FRKUserProfileViewController ()
{
    Userprofile *userprofile;
    
}

@end

@implementation FRKUserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Read a userprofile from local db.
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Userprofile"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    
    if([results count] == 0)
    {
        self.displayNameLabel.text = @"Type your username and appkey.";
        self.usernameLabel.text = @"Click Edit button.";
        self.appkeyLabel.text = @"Click Edit button.";
    }
    else if ([results count] == 1)
    {
        userprofile = results[0];
        self.displayNameLabel.text = userprofile.displayName;
        self.usernameLabel.text = userprofile.username;
        self.appkeyLabel.text = userprofile.appkey;
        
    }
    else
    {
        // To nothing yet.
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    [self viewDidLoad]; // to reload selected cell
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
