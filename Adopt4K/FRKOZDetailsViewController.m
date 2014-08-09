//
//  FRKOZDetailsViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/27/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "FRKOZDetailsViewController.h"
#import "FRKAppDelegate.h"
#import "OZFeature.h"
#import "KSConnManager.h"

@interface FRKOZDetailsViewController ()
{
    GMSMapView *gmView;
}

@end

@implementation FRKOZDetailsViewController


@synthesize selectedOZ;



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
    
    NSLog(@"selected oz id: %@", selectedOZ.wid);
    
    NSDictionary *dict =[[NSDictionary alloc]
                         initWithObjects:@[@"Low",@"Medium", @"High"]
                         forKeys:@[@"A",@"B",@"C"]];

    
    OZFeature *feature = [self getOZFeatureWithWid:selectedOZ.wid];
    
    self.oznameLabel.text = [NSString stringWithFormat:@"%@, %@ (%@)",
                             selectedOZ.zoneName,
                             selectedOZ.countryName, selectedOZ.wid,
                             dict[feature.worldType],
                             [feature.population intValue]];
    
    self.infoLabel.text = [NSString stringWithFormat:@"Gospel Access: %@  Population: %d",
                           dict[feature.worldType],
                           [feature.population intValue]];
    
    
    self.yearLabel.text = [NSString stringWithFormat:@"Year %d",
                           [selectedOZ.year intValue]];
    

    // Set a center of the map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.285
                                                            longitude:103.848
                                                                 zoom:12];
    
    // Determine MapView size
    CGFloat topBufferHeight = 220.0; // Top buffer height
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    gmView = [GMSMapView mapWithFrame:CGRectMake(0, topBufferHeight,
                                                 screenWidth, screenHeight - topBufferHeight) camera:camera];
    
    gmView.settings.compassButton = YES;
    

    
    // IMPORTANT to add GMSMapView as subview of ViewController main view
    [self.view addSubview:gmView];

    [self addPolygonsWithCurrentAdoption];
    
    // Add line
    UIColor *colorGrey = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 220, self.view.bounds.size.width, 1)];
    lineView1.backgroundColor = colorGrey;
    [self.view addSubview:lineView1];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (OZFeature *)getOZFeatureWithWid:(NSString *)wid
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
    
    OZFeature *feature = nil;
    if([results count] == 0)
    {
        NSLog(@"No matches.");
    }
    else
    {
        feature = results[0];
    }
    
    return feature;
}


- (void)addPolygonsWithCurrentAdoption
{
    NSString *wid = selectedOZ.wid;
    
    // Get the corresponding omega zone feature.
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
    }
    else
    {
        feature = results[0];
    }
    
    
    double currMaxRadiusX = 0.0;
    NSArray *firstLevel = feature.polygons;
    //NSLog(@"first level: %@", firstLevel);
    
    if ([feature.polygonType isEqual:@"MultiPolygon"])
    {
        for (int i = 0; i < [firstLevel count]; i++)
        {
            NSArray *secondLevel = firstLevel[i][0]; // Move down one more level.
            
            GMSMutablePath *path = [GMSMutablePath path];
            
            for (int j = 0; j < [secondLevel count]; j++)
            {
                //NSLog(@"second level: %@", secondLevel[j]);
                //NSLog(@"class type: %@", [secondLevel[j][0] class]);
                NSNumber *longitude = secondLevel[j][0];
                NSNumber *latitude = secondLevel[j][1];
                [path addCoordinate:CLLocationCoordinate2DMake([latitude doubleValue],
                                                               [longitude doubleValue])];
                
                // Calculate the biggest distance between center x and the x of points.
                double distance = fabs([feature.center_x doubleValue] - [longitude doubleValue]);
                if (currMaxRadiusX < distance)
                {
                    currMaxRadiusX = distance;
                }
            }
            
            GMSPolygon *polygon = [GMSPolygon polygonWithPath:path];
            polygon.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.20];
            polygon.strokeColor = [UIColor blueColor];
            polygon.strokeWidth = 2;
            polygon.map = gmView;
            
            //[polygonsOverlay addObject:polygon];
            
        }
        
        //NSLog(@"num of polygons: %lu",[feature.polygons count]);
        //NSLog(@"class type: %@", [feature.polygons class]);
    }
    else // if feature is a single polygon
    {
        GMSMutablePath *path = [GMSMutablePath path];
        
        NSArray *secondLevel = firstLevel[0];
        
        for (int j = 0; j < [secondLevel count]; j++)
        {
            //NSLog(@"second level: %@", secondLevel[j]);
            //NSLog(@"class type: %@", [firstLevel[j][0] class]);
            NSNumber *longitude = secondLevel[j][0];
            NSNumber *latitude = secondLevel[j][1];
            [path addCoordinate:CLLocationCoordinate2DMake([latitude doubleValue],
                                                           [longitude doubleValue])];
            
            // Calculate the biggest distance between center x and the x of points.
            double distance = fabs([feature.center_x doubleValue] - [longitude doubleValue]);
            if (currMaxRadiusX < distance)
            {
                currMaxRadiusX = distance;
            }
            
        }
        
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:path];
        polygon.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.20];
        polygon.strokeColor = [UIColor blueColor];
        polygon.strokeWidth = 2;
        polygon.map = gmView;
        
        //[polygonsOverlay addObject:polygon];
        
        
    }
    
    double zoomLevel;
    if (currMaxRadiusX*2.0000 < 1.0)
    {
        zoomLevel = 13 + log2(currMaxRadiusX*2.0000);
    }
    else
    {
        zoomLevel = 8 - log2(currMaxRadiusX*2.0000);
    }
    
    NSLog(@"zoomlevel: %f",currMaxRadiusX*2.0000);
    NSLog(@"zoomlevel: %f",zoomLevel);
    
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude: [feature.center_y doubleValue]
                                 longitude: [feature.center_x doubleValue]
                                 zoom: zoomLevel];
    
    [gmView setCamera:camera];
    
    
}



#pragma mark - Delete oz.

-(IBAction)didDeleteClicked
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warning"
                                                    message: @"Are you sure to delete?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Confirm",nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Canceled.");
    }
    else {
        NSLog(@"Confirmed.");
        [self deleteOZ];
    }
}

- (BOOL)deleteOZ
{
    NSLog(@"Deleting oz: %@", selectedOZ.wid);
    
    KSConnManager *conn = [KSConnManager getInstance];
    
    BOOL success = [conn deleteAdoption:selectedOZ];
    
    if(success)
    {
        
        FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc = [NSEntityDescription
                                           entityForName:@"Adoption"
                                           inManagedObjectContext:context];
        
        [context deleteObject:selectedOZ];
        
        NSError *savingError = nil;
        [context save:&savingError];
        NSLog(@"Failed to save the context. Error = %@", savingError);
        
        // Send a notification to refresh adoption list in prev screen.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshList" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return true;
        
    }
    else
    {
        // TODO: Inform user, log
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Alert"
                                     message:@"Please try again."
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        // shows alert to user
        [notPermitted show];

        NSLog(@"Error in deleting the current adoption (wid:%@) in server side",
              selectedOZ.wid);
        
        return false;
    }
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
