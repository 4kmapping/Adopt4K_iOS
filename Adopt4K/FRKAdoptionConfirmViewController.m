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


- (IBAction)adoptOne
{
    [self adoptionConfirmed];
    // Going back to menu page
}


- (IBAction)adoptMore
{
    [self adoptionConfirmed];
    // Going back to the first page of adoption
}

- (void)adoptionConfirmed
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
    
    NSError *savingError = nil;
    
    if ([context save:&savingError])
    {
        NSLog(@"Successfully saved the context.");
        [self displayAdoptions];
    }
    else
    {
        NSLog(@"Failed to save the context. Error = %@", savingError);
    }
    
    // TODO: Save to Server
    // ===
    KSConnManager *conn = [KSConnManager getInstance];
    [conn confirmAdoption:adoption];
    
    
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
    else // If Cancel is clicked.
    {
        //To nothing.
    }
    
    
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
