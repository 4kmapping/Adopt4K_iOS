//
//  FRKOZDetailsViewController.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/27/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Adoption.h"
#import <GoogleMaps/GoogleMaps.h>

@interface FRKOZDetailsViewController : UIViewController
{
    
}

@property Adoption *selectedOZ;

@property (weak,nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak,nonatomic) IBOutlet UILabel *oznameLabel;
@property (weak,nonatomic) IBOutlet UILabel *yearLabel;


- (IBAction)deleteOZ;

- (void)addPolygonsWithCurrentAdoption;


@end
