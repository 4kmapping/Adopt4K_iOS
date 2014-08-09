//
//  OZFeature.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/26/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "OZFeature.h"
#import "FRKAppDelegate.h"


@implementation OZFeature

@dynamic wid;
@dynamic polygonType;
@dynamic center_x;
@dynamic center_y;
@dynamic area;
@dynamic zoneName;
@dynamic countryName;
@dynamic polygons;
@dynamic population;
@dynamic worldType;


+ (OZFeature *)getOZFeatureWithWid:(NSString *)wid
{
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"OZFeature"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(wid = %@)", wid];
    [fetchRequest setPredicate:pred];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    OZFeature *feature;
    if([results count] == 0)
    {
        NSLog(@"No matches.");
        
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Alert"
                                     message:@"The OZ ID does not exist."
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        // shows alert to user
        [notPermitted show];
        
        return nil;
    }

    NSLog(@"matched.");
    feature = results[0];
    
    return feature;
}

@end
