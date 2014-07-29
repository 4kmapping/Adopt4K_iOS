//
//  FRKAppDelegate.h
//  Adopt4K
//
//  Created by Min Seong Kang on 7/22/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong,nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic) NSMutableDictionary *ozFeatures;


- (void)initOZFeatureCoreDataFromFile;

- (NSURL *)applicationDocumentsDirectory;

@end
