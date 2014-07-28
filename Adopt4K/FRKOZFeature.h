//
//  FRKOZFeature.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRKOZFeature : NSObject

@property NSString *wid;
@property NSString *polygonType;
@property NSArray *polygons;
@property NSNumber *center_x;
@property NSNumber *center_y;
@property NSNumber *area;
@property NSString *zoneName;
@property NSString *countryName;

@end
