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

@interface FRKAdoptionYearViewController ()
{
    UITableView *yearsTable;
}

@end

@implementation FRKAdoptionYearViewController

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
    
    // Update labels to show selected oz.
    self.ozidLabel.text = [NSString stringWithFormat:@"( %@ )", self.selectedFeature.wid];
    
    NSString *ozName = [NSString stringWithFormat:@"%@, %@", self.selectedFeature.zoneName,
        self.selectedFeature.countryName];
    
    self.ozNameLabel.text = ozName;
    
}



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
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
