//
//  FRKUserprofileEditViewController.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/28/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRKUserprofileEditViewController : UIViewController <UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak,nonatomic) IBOutlet UITextField *appkeyTextField;

- (IBAction)saveUserprofile;

@end
