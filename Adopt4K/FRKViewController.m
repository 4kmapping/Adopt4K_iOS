//
//  FRKViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/22/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKViewController.h"
#import "KSConnManager.h"
#import "FRKAppDelegate.h"

@interface FRKViewController ()

@end

@implementation FRKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StartAdoptionSegue"])
    {
        
        KSConnManager *conn = [KSConnManager getInstance];
        serverURL = [conn lockAdoption:currFeature.wid];
        
        
        FRKAdoptionYearViewController *vc = [segue destinationViewController];
        
        [vc setSelectedFeature:currFeature];
        [vc setSelectedTargetYear:currTargetYear];
        [vc.view addSubview:gmView];
        [vc setServerURL:serverURL];
        NSLog(@"serverURL in prepareForSegue: %@", [vc serverURL]);
    }
    
}
*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    FRKAppDelegate *appDelegate=(FRKAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([identifier isEqualToString:@"StartAdoptionSegue"] ||
        [identifier isEqualToString:@"StartHistorySegue"])
    {
        // perform your computation to determine whether segue should occur
        
        KSConnManager *conn = [KSConnManager getInstance];
        
        Userprofile *userprofile = [appDelegate userprofile];
        
        BOOL segueShouldOccur = (userprofile != nil);
        
        if (!segueShouldOccur)
        {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"You Should register your app!"
                                         message:@"Please input Username and Appkey in your Userprofile page."
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



@end
