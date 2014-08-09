//
//  FRKAppDelegate.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/22/14.
//  Copyright (c) 2014 4K. All rights reserved.
//


#import <GoogleMaps/GoogleMaps.h>

#import "FRKAppDelegate.h"
#import "OZFeature.h"    // CoreData ManagedObject

@implementation FRKAppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyC6ZJ5Q2KRKz_2oe6ZSGKH3MdraJ3vkH5w"];
    
    // Make OZFeature List
	// Read OZ features from a local file.
    // ***
    
    // TODO: To create a sqlite with OZFeature
    // USE ONLY ONCE and COMMENT OUT
    //[self loadOZFeaturesFromJSON];
    //[self loadOZFeaturesFromJSON:@"all_ozfeatures_ABC_4_coredata_2"];
    
    //[self testOZFeatureCoreData];
    //[self testOZFeatureCoreDataWithWid:@"USA-HIA"];
    
    // load Userprofile
    // ===
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Userprofile"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    self.userprofile = nil;
    
    if ([results count] > 0)
    {
        self.userprofile = results[0];
    }

    // Set up a notification for refreshing adopted OZ list.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserprofile)
                                                 name:@"RefreshUserprofile"
                                               object:nil];
    
    
    // For debugging purpose.
    NSLog(@"path:%@",[[NSBundle mainBundle]bundlePath]);
    
    return YES;
}


#pragma mark - Userprofile management.
- (void)refreshUserprofile
{
    // load Userprofile
    // ===
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"Userprofile"
                                       inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([results count] > 0)
    {
        self.userprofile = results[0];
    }
    
    NSLog(@"Userprofile is refreshed in App Delegate.");
    
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

     

# pragma mark - OZFeature creation from a file

/*
- (BOOL)initOZFeatureCoreDataFromFile
{
    // Fist Check if pre-poluated sqlite db exists.
    
    NSString* documentsPath =
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
            NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"Adopt4K.sqlite"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    // IF EXISTS, SKIP the rest.
    if(fileExists)
    {
        return false;
    }
    
    // Make OZFeature List
	// Read OZ features from a local file.
    // ===
    
    NSString *filePath = [[NSBundle mainBundle]
                          pathForResource:@"all_ozfeatures_ABC_4_coredata" ofType:@"txt"];
    
    NSError *error;
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    NSLog(@"error: %@", error);
    
    OZFeature *ozfeature;
    
    for (int i=0;i<lines.count;i++)
    {
        NSString *line = lines[i];
        
        NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
        
        NSLog(@"ERROR IS: %@",error);
        
        ozfeature = [NSEntityDescription
                       insertNewObjectForEntityForName:@"OZFeature"
                       inManagedObjectContext:[ self managedObjectContext]];
        

        
        if(dict != nil && ozfeature != nil)
        {

            NSDictionary *properties = [dict valueForKey:@"properties"];
            
            NSString *widKey = [properties valueForKey:@"WorldID"];
            
            NSString *polygonType = [[dict valueForKey:@"geometry"] valueForKey:@"type"];
            
            NSArray *polygons = [[dict valueForKey:@"geometry"] valueForKey:@"coordinates"];
            NSLog(@"polygons: %@", polygons);
            
            ozfeature.wid = widKey;
            ozfeature.polygonType = polygonType;
            ozfeature.polygons = polygons;
            ozfeature.center_x = [properties valueForKey:@"Cen_x"];
            ozfeature.center_y = [properties valueForKey:@"Cen_y"];
            ozfeature.area = [properties valueForKey:@"Shape_Area"];
            ozfeature.zoneName = [properties valueForKey:@"Zone_Name"];
            ozfeature.countryName = [properties valueForKey:@"Cnty_Name"];

            
            
            NSError *savingError = nil;
            
            if ([[self managedObjectContext] save:&savingError])
            {
                NSLog(@"Successfully saved the context.");
                NSLog(@"population: @d, world type: %@", ozfeature.population, ozfeature.worldType);
            }
            else
            {
                NSLog(@"Failed to save the context. Error = %@", savingError);
            }
            
        }
        else
        {
            NSLog(@"Failed to create the new ozfeature.");
        }
        
    }
    
    return true;
    
}
*/


- (BOOL)loadOZFeaturesFromJSON
{
    
    // CHECK IF EXISTING SQLite DB Files. If So, skip the rest of the process.
    NSString* documentsPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* dbFile = [documentsPath stringByAppendingPathComponent:@"Adopt4K.sqlite"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dbFile];
    
    if(fileExists)
    {
        NSLog(@"Adopt4K.sqlite already exists. Skip loading.");
        return false;
    }
    
    
    // Load data by executing SQL statements.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"all_ozfeatures_ABC_4_coredata"
                                                           ofType:@"txt"];
    
    NSError *error;
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    NSLog(@"error: %@", error);
    
    for (int i=0;i<lines.count;i++)
    {
        NSString *line = lines[i];
        
        NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&error];
  
        
        NSLog(@"ERROR IS: %@",error);
        
        OZFeature *ozfeature = [NSEntityDescription
                     insertNewObjectForEntityForName:@"OZFeature"
                     inManagedObjectContext:[ self managedObjectContext]];
        
        
        
        if(dict != nil && ozfeature != nil)
        {
            
            ozfeature.wid = [dict valueForKey:@"wid"];
            ozfeature.area = [dict valueForKey:@"Shape_Area"];
            ozfeature.zoneName = [dict valueForKey:@"zoneName"];
            ozfeature.countryName = [dict valueForKey:@"countryName"];
            ozfeature.center_x = [dict valueForKey:@"center_x"];
            ozfeature.center_y = [dict valueForKey:@"center_y"];
            ozfeature.polygonType = [dict valueForKey:@"polygonType"];
            ozfeature.polygons = [dict valueForKey:@"polygons"];
            ozfeature.worldType = [dict valueForKey:@"worldType"];
            ozfeature.population = [dict valueForKey:@"population"];
            
            
        }
        else
        {
            NSLog(@"Failed to create the new ozfeature.");
        }

        NSError *savingError = nil;
        
        if ([[self managedObjectContext] save:&savingError])
        {
            NSLog(@"Successfully saved the context.");
        }
        else
        {
            NSLog(@"Failed to save the context. Error = %@", savingError);
        }
       
        
    }
    
    return true;
    
}


- (void)testOZFeatureCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"OZFeature"
                                   inManagedObjectContext:self.managedObjectContext];
    
    NSError *error;
    
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [self.managedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    
    
    
    for (NSManagedObject *info in fetchedObjects)
    {
        
        //NSLog(@"polygons: %@", [ozfeature valueForKey:@"polygons"]);
        
        NSLog(@"wid: %@", [info valueForKey:@"wid"]);
        //NSManagedObject *details = [info valueForKey:@"details"];
        //NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }
    
    NSLog(@"Total OZ count: %d", [fetchedObjects count]);
}


- (void)testOZFeatureCoreDataWithWid:(NSString *)wid
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"OZFeature"
                                   inManagedObjectContext:self.managedObjectContext];
    
    NSError *error;
    
    [fetchRequest setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(wid = %@)", wid];
    [fetchRequest setPredicate:pred];
    
    
    NSArray *fetchedObjects = [self.managedObjectContext
                               executeFetchRequest:fetchRequest error:&error];
    

    NSLog(@"Inside testOZFeatureCoreDataWithWid");
    
    for (NSManagedObject *info in fetchedObjects)
    {
        OZFeature *ozfeature = (OZFeature *)info;
        
        //NSLog(@"polygons: %@", [ozfeature valueForKey:@"polygons"]);
        
        NSLog(@"wid: %@", [info valueForKey:@"wid"]);
        //NSManagedObject *details = [info valueForKey:@"details"];
        //NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }
    
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Adopt4K" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Adopt4K.sqlite"];
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        
        // typically the main store name is 'appName.sqlite'
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"Adopt4K" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
   // ***

    NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
    [pragmaOptions setObject:@"DELETE" forKey:@"journal_mode"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, pragmaOptions, NSSQLitePragmasOption, nil];
    //[_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]

    
   // ***
    
    //NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


/*
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Adopt4K.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
 
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
*/

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
