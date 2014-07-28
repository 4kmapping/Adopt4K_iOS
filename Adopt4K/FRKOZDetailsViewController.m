//
//  FRKOZDetailsViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/27/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKOZDetailsViewController.h"

@interface FRKOZDetailsViewController ()

@end

@implementation FRKOZDetailsViewController


@synthesize selectedOZ;



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
    
    NSLog(@"selected oz id: %@", selectedOZ.wid);
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
