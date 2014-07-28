//
//  FRKYearChoiceViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKYearChoiceViewController.h"

@interface FRKYearChoiceViewController ()

@end

@implementation FRKYearChoiceViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)setTargetYear:(id)sender
{
    UIButton *yearButton = (UIButton *)sender;
    //NSLog(@"%@", yearButton.titleLabel.text);
    
    NSInteger intYear = [yearButton.titleLabel.text integerValue];
    [self.prevViewController setSelectedTargetYear:(int)intYear];
    self.prevViewController.yearButton.titleLabel.text = yearButton.titleLabel.text;
    
    //NSLog(@"%d", intYear);
    //NSLog(@"%d", self.prevViewController.selectedTargetYear);
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
