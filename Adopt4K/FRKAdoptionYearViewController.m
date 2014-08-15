//
//  FRKAdoptionConfirmViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKAdoptionYearViewController.h"
#import "FRKYearChoiceViewController.h"
#import "FRKAdoptionConfirmViewController.h"
#import "KSConnManager.h"

@interface FRKAdoptionYearViewController ()
{
    UITableView *yearsTable;
}

@end

@implementation FRKAdoptionYearViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Update labels to show selected oz.
    self.ozidLabel.text = [NSString stringWithFormat:@"( %@ )", self.selectedFeature.wid];
    
    NSString *ozName = [NSString stringWithFormat:@"%@, %@", self.selectedFeature.zoneName,
        self.selectedFeature.countryName];
    
    self.ozNameLabel.text = ozName;
    
    //NSLog(@"selected server url in AdoptionYearViewController: %@", self.serverURL);
    
    // Add line
    UIColor *colorGrey = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 159, self.view.bounds.size.width, 1)];
    lineView1.backgroundColor = colorGrey;
    [self.view addSubview:lineView1];
    
    //self.yearButton.titleLabel.text = @"Choose Year";
    //self.selectedTargetYear = 0;
    //[self refreshYearLabel];
    
    
}

- (void)refreshYearLabel
{
    self.yearButton.titleLabel.text = [NSString stringWithFormat:@"%d",self.selectedTargetYear ];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"yearChoiceSegue"])
    {
        // Get reference to the destination view controller
        FRKYearChoiceViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setPrevViewController:self];
    }
    if ([[segue identifier] isEqualToString:@"adoptConfirmSegue"])
    {
        FRKAdoptionConfirmViewController *vc = [segue destinationViewController];
        [vc setSelectedFeature:self.selectedFeature];
        [vc setTargetYear:self.selectedTargetYear];
        [vc setServerURL:self.serverURL];
    }
    if ([[segue identifier] isEqualToString:@"cancelAdoptionYearSegue"])
    {
        /*
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
        */ 
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"adoptConfirmSegue"])
    {
        // perform your computation to determine whether segue should occur
        if(self.selectedTargetYear < 2015)
        {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Please choose a target year."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            // shows alert to user
            [notPermitted show];
            
            return NO; // Still allow users to choose OZ.
        }
        
    }
    
    // by default perform the segue transition
    return YES;
}



@end
