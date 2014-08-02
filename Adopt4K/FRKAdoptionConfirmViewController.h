//
//  FRKAdoptionConfirmViewController.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OZFeature.h"
#import "Adoption.h"

@interface FRKAdoptionConfirmViewController : UIViewController

@property (weak,nonatomic) OZFeature *selectedFeature;
@property int targetYear;
@property (weak,nonatomic) NSString *serverURL;

@property (weak,nonatomic) IBOutlet UILabel *zoneNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *yearLabel;

- (BOOL) adoptionConfirmed;


@end
