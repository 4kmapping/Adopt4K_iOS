//
//  KSConnManager.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/29/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Adoption;

@interface KSConnManager : NSObject

+ (KSConnManager *)getInstance;


- (BOOL)checkAdoptionWidLock:(NSString *)wid;
- (NSString *)lockAdoption:(NSString *)wid;
- (BOOL)confirmAdoption:(Adoption *)adoption;
- (BOOL)deleteAdoption:(Adoption *)adoption;
- (BOOL)deleteAdoptionWithServerURL:(NSString *)serverURL;

- (NSString *)checkUserprofileFromServerWithUsername:(NSString *)username appkey:(NSString *)appkey;


@end





