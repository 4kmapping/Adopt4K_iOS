//
//  FRKUserProfileViewController.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/28/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRKUserProfileViewController : UIViewController <UIAlertViewDelegate>


@property (weak,nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak,nonatomic) IBOutlet UILabel *appkeyLabel;

@property (weak,nonatomic) IBOutlet UILabel *adoptionStatusLabel;
@property (weak,nonatomic) IBOutlet UILabel *syncButton;


@end
