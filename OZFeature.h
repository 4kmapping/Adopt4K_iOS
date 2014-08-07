//
//  OZFeature.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/26/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OZFeature : NSManagedObject

@property (nonatomic, retain) NSString * wid;
@property (nonatomic, retain) NSString * polygonType;
@property (nonatomic, retain) NSNumber * center_x;
@property (nonatomic, retain) NSNumber * center_y;
@property (nonatomic, retain) NSNumber * area;
@property (nonatomic, retain) NSString * zoneName;
@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSArray *polygons;
@property (nonatomic, retain) NSNumber * population;
@property (nonatomic, retain) NSString * worldType;


@end
