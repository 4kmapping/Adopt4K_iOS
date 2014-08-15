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
#import "KSConnManager.h"
#import "Adoption.h"
#import "OZFeature.h"

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

    Userprofile *profile = [appDelegate userprofile];
    
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
    
    int count = [Adoption countAdoptionsForUserId:profile.userId];
    
    if(count == NSNotFound) {
        //Handle error
    }
    
    self.adoptionStatusLabel.text = [NSString stringWithFormat:
                                     @"You adopted total %d OZ.", count];
    //NSLog(@"%@", self.adoptionStatusLabel.text);
    
    
    
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

// In a storyboard-based application, 
// you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)didSyncClicked
{
    
    UIAlertView *alert = [[UIAlertView alloc]
              initWithTitle:@"Warning"
                    message:@"Are you sure to synchronize with a server?"
                   delegate:self
          cancelButtonTitle:@"Cancel"
          otherButtonTitles:@"Confirm",nil];
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Canceled.");
    }
    else {
        NSLog(@"Confirmed.");
        [self syncWithServer];
    }
}



- (BOOL)syncWithServer
{
    KSConnManager *conn = [KSConnManager getInstance];
    
    NSDictionary *jsonDict = [conn syncAdoptionWithServer];
    
    if (jsonDict == nil)
    {
        return false;
    }
    
    NSArray *results = jsonDict[@"results"];
    
    if ([results count] > 0)
    {
        
        NSLog(@"creating adoptions by syncing.");
        
        FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        Userprofile *profile = [appDelegate userprofile];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        // First off, delete all local Adoption entries.
        // ===
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Adoption"
                                            inManagedObjectContext:context]];
        [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * adoptions = [context executeFetchRequest:fetchRequest error:&error];
        //error handling goes here
        for (NSManagedObject * adoption in adoptions)
        {
            [context deleteObject:adoption];
        }
        NSError *saveError = nil;
        [context save:&saveError];
        
        // Create Adoption items from server.
        // ===
        
        for (NSDictionary *result in results)
        {
        
            NSLog(@"creating one adoption.");
            
            Adoption *adoption = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Adoption"
                              inManagedObjectContext:context];
        
            adoption.year = result[@"targetyear"];
            adoption.wid = result[@"worldid"];
            adoption.zoneName = result[@"oz_zone_name"];
            adoption.countryName = result[@"oz_country_name"];
            adoption.serverURL = result[@"url"];
            adoption.userId = profile.userId;
            // TODO: Delte later.
            // adoption.serverURL = self.serverURL;
            //adoption.serverURL = nil;
            
            OZFeature *feature = [OZFeature getOZFeatureWithWid:adoption.wid];
            
            adoption.polygons = feature.polygons;
        }
        
        saveError = nil;
        [context save:&saveError];
        
        // Update total num of adoptions in UI
        int count = [Adoption countAdoptionsForUserId:profile.userId];
        self.adoptionStatusLabel.text = [NSString stringWithFormat:
                                         @"You adopted total %d OZ.", count];
        
        return true;
    }
    
    return false;

}



@end







