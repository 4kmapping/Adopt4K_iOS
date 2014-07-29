//
//  FRKUserprofileEditViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/28/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKUserprofileEditViewController.h"
#import "FRKAppDelegate.h"
#import "Userprofile.h"

@interface FRKUserprofileEditViewController ()

@end

@implementation FRKUserprofileEditViewController

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
    
    [self.usernameTextField setDelegate:self];
    [self.appkeyTextField setDelegate:self];

    
    Userprofile *userprofile = self.getUserprofile;
    if (userprofile != nil)
    {
        self.usernameTextField.text = userprofile.username;
        self.appkeyTextField.text = userprofile.appkey;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
#warning Save userprofile to server
    if ([[segue identifier] isEqualToString:@"saveSegue"])
    {
        [self saveUserprofile];
        
    }
}


- (Userprofile *)getUserprofile
{
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Userprofile"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    Userprofile *userprofile = nil;
    
    if ([results count] > 0)
    {
        userprofile = results[0];
    }
    
    return userprofile;
}


- (IBAction)saveUserprofile
{
    NSString *username = self.usernameTextField.text;
    NSString *appkey = self.appkeyTextField.text;
    NSString *displayName = @"Anonymous";

// TODO:
#warning CHECK with server.
    
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Userprofile"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    if([results count] == 0)
    {
        
        Userprofile *userprofile = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Userprofile"
                     inManagedObjectContext:context];

        userprofile.username = username;
        userprofile.appkey = appkey;
        userprofile.displayName = displayName;
        
        NSError *savingError = nil;
        
        if ([context save:&savingError])
        {
            NSLog(@"Successfully saved the context.");
        }
        else
        {
            NSLog(@"Failed to save the context. Error = %@", savingError);
        }

        
    }
    else if ([results count] == 1)
    {
        Userprofile *userprofile = results[0];
        userprofile.username = username;
        userprofile.appkey = appkey;
        userprofile.displayName = displayName;

        NSError *savingError = nil;
        
        if ([context save:&savingError])
        {
            NSLog(@"Successfully saved the context.");
        }
        else
        {
            NSLog(@"Failed to save the context. Error = %@", savingError);
        }
        
    }
    else
    {
        // Do nothing.
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

@end





