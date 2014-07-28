//
//  Adoption.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/26/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Adoption : NSManagedObject

@property (nonatomic, retain) NSArray *polygons;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * wid;
@property (nonatomic, retain) NSString * zoneName;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSNumber * year;

@end
