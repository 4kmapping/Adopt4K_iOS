//
//  FRKAdoptionConfirmViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKAdoptionConfirmViewController.h"
#import "FRKAppDelegate.h"
#import "FRKAdoptionOZViewController.h"
#import "KSConnManager.h"


@interface FRKAdoptionConfirmViewController ()

@end

@implementation FRKAdoptionConfirmViewController

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

    // Display selected OZ and target year
    NSString *ozName = [NSString stringWithFormat:@"%@, %@",
                        self.selectedFeature.zoneName,
                        self.selectedFeature.countryName];
    self.zoneNameLabel.text = ozName;
    self.yearLabel.text = [NSString stringWithFormat:@"%d", self.targetYear];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)adoptionConfirmed
{

    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    // Save to local db.
    Adoption *adoption = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Adoption"
                          inManagedObjectContext:context];
 
    adoption.year = [NSNumber numberWithInt:self.targetYear];
    adoption.wid = self.selectedFeature.wid;
    adoption.polygons = self.selectedFeature.polygons;
    adoption.zoneName = self.selectedFeature.zoneName;
    NSLog(@"zoneName: %@ - %@", adoption.zoneName, self.selectedFeature.zoneName);
    adoption.countryName = self.selectedFeature.countryName;
    adoption.serverURL = self.serverURL;
    
    NSLog(@"Server URL in confirmation view: %@", self.serverURL);
    
    
    // TODO: Save to Server
    // ===
    KSConnManager *conn = [KSConnManager getInstance];
    if(![conn confirmAdoption:adoption])
    {
        return false;
    }
    
    // Save to local
    NSError *savingError = nil;
    
    if ([context save:&savingError])
    {
        NSLog(@"Successfully saved the context.");
        [self displayAdoptions];
        return true;
    }
    else
    {
        NSLog(@"Failed to save the context. Error = %@", savingError);
    }

    return false;
}


- (void)displayAdoptions
{

    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Adoption"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];

    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    Adoption *adoption;
    for (adoption in results)
    {
        NSLog(@"wid: %@, year: %d", adoption.wid, [adoption.year intValue]);
    }
    
    
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"adoptMoreSegue"])
    {
        // Save the selection to server and local.
        [self adoptionConfirmed];
        
        // Make a transition.
        FRKAdoptionOZViewController *vc = [segue destinationViewController];

    }
    else if ([[segue identifier] isEqualToString:@"adoptOneSegue"])
    {
        // Save the selection to server and local.
        NSLog(@"adoptOneSegue clicked");
        [self adoptionConfirmed];
        
    }
    else if([[segue identifier] isEqualToString:@"cancelAdoptionSegue"]) // If Cancel is clicked.
    {
        // Delete Adoption lock in server side
        KSConnManager *conn = [KSConnManager getInstance];
        BOOL success = [conn deleteAdoptionWithServerURL:self.serverURL];
        if (success)
        {
            NSLog(@"Successfully removed adoption lock for %@.", self.serverURL);
        }
        else
        {
            NSLog(@"Failed to remove adoption lock for %@.", self.serverURL);
        }
        
    }
    else
    {
        //To nothing.
    }
 
}
*/


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

    if ([identifier isEqualToString:@"adoptMoreSegue"] ||
        [identifier isEqualToString:@"adoptOneSegue"] )
    {
        // perform your computation to determine whether segue should occur
        

        
        BOOL segueShouldOccur = [self adoptionConfirmed];
        
        if (!segueShouldOccur)
        {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Please try again."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            // shows alert to user
            [notPermitted show];
            
            return NO;
        }
    }
    if ([identifier isEqualToString:@"cancelAdoptionSegue"])
    {
        KSConnManager *conn = [KSConnManager getInstance];
        
        BOOL segueShouldOccur = [conn deleteAdoptionWithServerURL:self.serverURL];
        if (!segueShouldOccur)
        {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Please try again."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            // shows alert to user
            [notPermitted show];
            
            return NO;
        }
    }
        
        
    
    // by default perform the segue transition
    return YES;
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
