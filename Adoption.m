//
//  Adoption.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/26/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "Adoption.h"
#import "FRKAppDelegate.h"


@implementation Adoption

@dynamic polygons;
@dynamic timestamp;
@dynamic userId;
@dynamic wid;
@dynamic zoneName;
@dynamic countryName;
@dynamic year;
@dynamic serverURL;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    [self setTimestamp:[NSDate date]];
}


+ (int)countAdoptionsForUserId:(NSString *)uid
{
    
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Adoption"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(userId = %@)", uid];
    [fetchRequest setPredicate:pred];
    
    NSError *err;
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&err];

    return count;
}



@end



