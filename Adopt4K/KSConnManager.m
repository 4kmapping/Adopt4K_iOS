//
//  KSConnManager.m
//  Adopt4K
//
//  Created by Min Seong Kang on 7/29/14.
//  Copyright (c) 2014 4K. All rights reserved.
//

#import "KSConnManager.h"
#import "Adoption.h"
#import "Userprofile.h"
#import "FRKAppDelegate.h"

@implementation KSConnManager


static int timeoutSeconds = 7;



+ (KSConnManager *)getInstance
{
    static KSConnManager *singletonInstance = nil;
    @synchronized(self)
    {
        if(singletonInstance == nil)
        {
            singletonInstance = [[self alloc] init];
        }
    }
    return singletonInstance;
}


- (BOOL)checkAdoptionWidLock:(NSString *)wid
{
    
    NSString *url_adoptions =
        [NSString stringWithFormat:@"http://4kadopt.org/api/adoptions/?wid=%@", wid];
    
    NSMutableURLRequest *request =
        [self prepareURLRequestWithURLString:url_adoptions
                                      method:@"GET"
                                        data:nil];
    
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];
   
    /* For Debugging */
    //NSLog(@"json data is: %@", jsonStr);
    //NSLog(@"syncing location status code is: %ld", (long)[responseCode statusCode]);
    
    if(responseData == nil)
    {
        NSLog(@"Can't sync with a server! %@ %@", error, [error localizedDescription]);
    }
    else
    {
    
        NSDictionary* jsonDict = [NSJSONSerialization
                                JSONObjectWithData:responseData
                                options:0
                                error:nil];
    
        NSArray *results = jsonDict[@"results"];
    

    
        if([results count] > 0)
        {
            return true;    // Either someone has adopted or is working on this oz.
        }
    }

    return false;
    
}


- (NSString *)lockAdoption:(NSString *)wid
{

    NSString *url_adoptions =
        [NSString stringWithFormat:@"http://4kadopt.org/api/adoptions/"];
    
    NSString *jsonStr =
        [NSString stringWithFormat:
            @"{\"worldid\": \"%@\",\"targetyear\": 0,\"is_adopted\": false}", wid];
    
    NSMutableURLRequest *request =
        [self prepareURLRequestWithURLString:url_adoptions
                                      method:@"POST"
                                        data:jsonStr];
    
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];

    if(responseData == nil)
    {
        NSLog(@"Can't sync with a server! %@ %@", error, [error localizedDescription]);
        return nil;
    }
    else
    {
    
        NSDictionary* jsonDict = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:0
                                  error:nil];
    
        NSString *adoptionURL = jsonDict[@"url"];
    
        NSLog(@"lockAdoption URL: %@", adoptionURL);
    
        return adoptionURL;
    }
}


- (BOOL)confirmAdoption:(Adoption *)adoption
{
    
    NSString *jsonStr =
    [NSString stringWithFormat:
     @"{\"targetyear\": %d,\"is_adopted\": true}", [adoption.year intValue]];
    
    NSMutableURLRequest *request =
        [self prepareURLRequestWithURLString:adoption.serverURL
                                      method:@"PATCH"
                                        data:jsonStr];
    
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];
    
    if(responseData == nil)
    {
        NSLog(@"Can't sync with a server! %@ %@", error, [error localizedDescription]);
        return false;
    }
    else
    {

        int statusCodeNumber = (int)[responseCode statusCode];
        
        NSLog(@"syncing Adoption code is: %ld", (long)[responseCode statusCode]);
        
        if (statusCodeNumber >= 200 && statusCodeNumber < 300)
        {
            return true;
        }
        else
        {
            return false;
        }
        
    }

}


- (BOOL)deleteAdoption:(Adoption *)adoption
{

    return [self deleteAdoptionWithServerURL:adoption.serverURL];
    
}

- (BOOL)deleteAdoptionWithServerURL:(NSString *)serverURL
{

    NSMutableURLRequest *request =
    [self prepareURLRequestWithURLString:serverURL
                                  method:@"DELETE"
                                    data:nil];
    
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];
    
    int statusCodeNumber = (int)[responseCode statusCode];
    
    NSLog(@"syncing Adoption code is: %ld", (long)[responseCode statusCode]);
    
    if (statusCodeNumber >= 200 && statusCodeNumber < 300)
    {
        return true;
    }
    
    return false;
    
    
}


- (NSMutableURLRequest *)prepareURLRequestWithURLString:(NSString *)urlStr
                                                 method:(NSString *)method
                                                   data:(NSString *)jsonStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"Server URL: %@", urlStr);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:timeoutSeconds];
    
    Userprofile *profile = [self getUserprofile];
    
    NSMutableDictionary * headers = [[NSMutableDictionary alloc] init];
    
    NSString *credential = [NSString stringWithFormat:@"%@:%@",
                            profile.username, profile.appkey];
    
    NSString *credentialBase64 = [self base64String:credential];
    
    NSString *appkeyStr = [NSString stringWithFormat:@"Basic %@",
                           credentialBase64];
    
    NSLog(@"appkeyStr: %@", appkeyStr);
    
    [headers setObject:appkeyStr forKey:@"Authorization"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    
    [request setAllHTTPHeaderFields:headers];
    
    request.HTTPMethod = method;
    
    // Setting HTTP body
    if([method isEqual:@"GET"] || [method isEqual:@"DELETE"])
    {
        // Do nothing
    }
    else if([method isEqual:@"POST"] || [method isEqual:@"PATCH"])
    {
        [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        // Do nothing now.
    }
    
    return request;
    
}


- (NSMutableURLRequest *)prepareURLRequestWithURLString:(NSString *)urlStr
                                                 method:(NSString *)method
                                                   data:(NSString *)jsonStr
                                            username:(NSString *)username
                                                 appkey:(NSString *)appkey
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"Server URL: %@", urlStr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:timeoutSeconds];
    
    NSMutableDictionary * headers = [[NSMutableDictionary alloc] init];
    
    NSString *credential = [NSString stringWithFormat:@"%@:%@",
                            username, appkey];
    
    NSString *credentialBase64 = [self base64String:credential];
    
    NSString *appkeyStr = [NSString stringWithFormat:@"Basic %@",
                           credentialBase64];
    
    NSLog(@"appkeyStr: %@", appkeyStr);
    
    [headers setObject:appkeyStr forKey:@"Authorization"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    
    [request setAllHTTPHeaderFields:headers];
    
    request.HTTPMethod = method;
    
    // Setting HTTP body
    if([method isEqual:@"GET"] || [method isEqual:@"DELETE"])
    {
        // Do nothing
    }
    else if([method isEqual:@"POST"] || [method isEqual:@"PATCH"])
    {
        [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        // Do nothing now.
    }
    
    return request;
    
}




# pragma mark - Userprofile Info

- (Userprofile *)getUserprofile
{
    FRKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Userprofile"
                                   inManagedObjectContext:context];
    
    NSError *error;
    
    [fetchRequest setEntity:entity];
    
    NSArray *results = [context executeFetchRequest:fetchRequest
                                              error:&error];
    
    if([results count] > 0)
    {
        return results[0];
    }
    
    return nil;
}


- (NSString *)checkUserprofileFromServerWithUsername:(NSString *)username
                                              appkey:(NSString *)appkey
{
    NSString *url_adoptions = [NSString
                            stringWithFormat:@"http://4kadopt.org/api/users/"];
    
    NSMutableURLRequest *request = [self
            prepareURLRequestWithURLString:url_adoptions
                                  method:@"GET"
                                    data:nil
                                    username:username
                                    appkey:appkey];
    
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];
    
    int statusCodeNumber = (int)[responseCode statusCode];
    
    NSLog(@"syncing Adoption code is: %ld", (long)[responseCode statusCode]);
    
    if (statusCodeNumber >= 400 && statusCodeNumber < 500)
    {
        return nil;
    }
    
    /* For Debugging */
    //NSLog(@"json data is: %@", jsonStr);
    //NSLog(@"syncing location status code is: %ld", (long)[responseCode statusCode]);
    NSLog(@"Can't sync with a server! %@ %@", error, [error localizedDescription]);
    
    
    NSDictionary* jsonDict = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:0
                              error:nil];
    
    NSArray *results = jsonDict[@"results"];
    
    
    if([results count] > 0)
    {
        NSDictionary *userDict = results[0];
        return userDict[@"first_name"];
    }
    
    return nil;
    
}



- (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


@end





