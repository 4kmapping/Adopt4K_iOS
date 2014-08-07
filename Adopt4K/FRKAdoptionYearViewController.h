//
//  FRKAdoptionConfirmViewController.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "OZFeature.h"

@interface FRKAdoptionYearViewController : UIViewController <GMSMapViewDelegate>

@property (weak,nonatomic) OZFeature *selectedFeature;
@property int selectedTargetYear;
@property (weak,nonatomic) GMSMapView *gmView;
@property (weak,nonatomic) NSString *serverURL;


@property (weak,nonatomic) IBOutlet UILabel *ozidLabel;
@property (weak,nonatomic) IBOutlet UILabel *ozNameLabel;
@property (weak,nonatomic) IBOutlet UIButton *yearButton;
@property (strong,nonatomic) NSArray * yearChoices;



@end
