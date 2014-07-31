//
//  Userprofile.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/28/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Userprofile : NSManagedObject

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * appkey;


- (BOOL)isReady;

@end
