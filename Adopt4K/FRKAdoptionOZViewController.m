//
//  FRKAdoptionViewController.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/23/14.
//  Copyright (c) 2014 4K. All rights reserved.
//


#import "FRKAdoptionOZViewController.h"
#import "FRKAdoptionYearViewController.h"
#import "KSConnManager.h"

@interface FRKAdoptionOZViewController ()
{
    // Holds OZ features
    NSMutableDictionary *ozFeatures;
    NSString *serverURL; // server URL for the created adoption entry in server.
    

    GMSMapView *gmView;
    double currMaxRadiusX;
    double currCenterX;
    
    OZFeature *currFeature;
    int currTargetYear;

}

@end

@implementation FRKAdoptionOZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FRKAppDelegate *appDelegate = (FRKAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Set a center of the map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.285
                                                            longitude:103.848
                                                                 zoom:12];
    
    // Determine MapView size
    CGFloat topBufferHeight = 160.0; // Top buffer height
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    gmView = [GMSMapView mapWithFrame:CGRectMake(0, topBufferHeight,
                                                 screenWidth, screenHeight - topBufferHeight) camera:camera];
    
    gmView.settings.compassButton = YES;
    
    // IMPORTANT to add GMSMapView as subview of ViewController main view
    
    [self.view addSubview:gmView];
    
    // Add line
    UIColor *colorGrey = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, 1)];
    lineView1.backgroundColor = colorGrey;
    [self.view addSubview:lineView1];
    
}


- (IBAction)loadOZFeature:(id)sender
{

    NSString *wid = self.ozidTextField.text;
    //NSLog(@"wid >> %@",wid);

    // TODO: Check if the current wid is already chosen by others.
    // ===
    
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


    
    //FRKOZFeature *feature = ozFeatures[wid];
    
    // Set a current feature
    currFeature = feature;
    
    // clean up a map before adding polygons & initialize variables
    [gmView clear];
    currMaxRadiusX = 0.0;
    
    
    [self addPolygonsWithData:feature];
    
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
    
    // Display the selected zone name
    NSString *zoneName = [NSString stringWithFormat:@"%@, %@", currFeature.zoneName,
                          currFeature.countryName];
    self.zoneNameLabel.text = zoneName;
    
}


- (void)addPolygonsWithData:(OZFeature *)feature
{
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
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"adoptionYearSegue"])
    {
        FRKAdoptionYearViewController *vc = [segue destinationViewController];
        
        [vc setSelectedFeature:currFeature];
        [vc setSelectedTargetYear:currTargetYear];
        [vc.view addSubview:gmView];
        [vc setServerURL:serverURL];
        NSLog(@"serverURL in prepareForSegue: %@", [vc serverURL]);
    }
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"adoptionYearSegue"])
    {
        // perform your computation to determine whether segue should occur
        
        KSConnManager *conn = [KSConnManager getInstance];
        
        BOOL segueShouldOccur = (![conn checkAdoptionWidLock:currFeature.wid]);
        
        if (!segueShouldOccur)
        {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Please choose another Omega Zone."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            // shows alert to user
            [notPermitted show];
            
            return NO;
        }
        
        
        serverURL = [conn lockAdoption:currFeature.wid];
        if (serverURL == nil)
        {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Failed to lock. Please try again later."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            // shows alert to user
            [notPermitted show];
            
            return NO;
        }
        
    }
    
    // by default perform the segue transition
    return YES;
}




- (IBAction)adoptOZ:(id)sender
{
    // Check if both ozid and target year are selected.
    NSString *ozid = self.ozidTextField.text;
    
    if([ozid length] == 0 )
    {
        NSLog(@"You should choose an omega zone.");
    }
    
    // Save it to its datasource
    
    // Send it to server.
        
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




