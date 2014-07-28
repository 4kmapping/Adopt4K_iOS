//
//  FRKAdoptionViewController.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
//#import "FRKOZFeature.h"
#import "FRKAppDelegate.h"
#import "OZFeature.h"

@interface FRKAdoptionOZViewController : UIViewController <GMSMapViewDelegate>


@property (weak,nonatomic) IBOutlet UIView *inputView;

@property (weak,nonatomic) IBOutlet UITextField *ozidTextField;
@property (weak,nonatomic) IBOutlet UILabel *zoneNameLabel;
@property (weak,nonatomic) IBOutlet UIButton *selectButton;

- (IBAction)loadOZFeature:(id)sender;

- (IBAction)adoptOZ:(id)sender;

- (void)addPolygonsWithData:(OZFeature *)feature;



@end
