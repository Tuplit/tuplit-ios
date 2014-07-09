

#import "CurrentLocation.h"


@interface CurrentLocation ()
@end


@implementation CurrentLocation

CLLocationManager *locationManager;
CLLocationCoordinate2D currentLocation;
BOOL locationUpdated;
BOOL alertVisible;
NSDictionary *addressDict = nil;

double mylat,myLon;

- (void)dealloc {
    
	locationManager = nil;
}


#pragma mark - User Defined Methods

+ (void)start {
    
    if (!locationManager) {
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = (id)self;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    [locationManager startUpdatingLocation];
}

+ (BOOL)isLocationUpdated {
    
    return locationUpdated;
}

+ (CLLocationCoordinate2D)coordinate {
    
    if (locationUpdated) return currentLocation;
    else return CLLocationCoordinate2DMake(999, 999);
}

+ (CLLocationDegrees)latitude {
 
    return [CurrentLocation coordinate].latitude;
}

+ (CLLocationDegrees)longitude {
    
    return [CurrentLocation coordinate].longitude;
}

+ (NSString *)latitudeString {
    
    return [NSString stringWithFormat:@"%lf", [CurrentLocation coordinate].latitude];
}

+ (NSString *)longitudeString {
    
    return [NSString stringWithFormat:@"%lf", [CurrentLocation coordinate].longitude];
}

+ (NSString *)Country {
    
    return [addressDict objectForKey:(NSString*) kABPersonAddressCountryKey];
}

+ (NSString *)Zip {
    
    return [addressDict objectForKey:(NSString*) kABPersonAddressZIPKey];
}

+ (NSString *)stateAndCountry {
    
    NSString *city = [addressDict objectForKey:(NSString*) kABPersonAddressCityKey];
    if([city isEqualToString:@""])
    {
        city=[addressDict objectForKey:(NSString*) kABPersonAddressStreetKey];
    }
    
    return city;
}

+ (NSString *)address
{
    NSString *street =[addressDict objectForKey:(NSString*) kABPersonAddressStreetKey];
    NSString *city = [addressDict objectForKey:(NSString*) kABPersonAddressCityKey];
    NSString *state = [addressDict objectForKey:(NSString*) kABPersonAddressStateKey];
    NSString *address_;
    address_=street;
    
    if([state isEqualToString:@""] || state == nil)
    {
       address_ =@"Not set";
    }
    else
    {
        if([city isEqualToString:@""] || city == nil)
        {
            address_= state;
        }
        else if([street isEqualToString:@""] || street == nil)
        {
            address_= [NSString stringWithFormat:@"%@,%@",city,state];
        }
        else
        {
            address_ =[NSString stringWithFormat:@"%@,%@,%@",street,city,state];
        }
    }
    
    return address_;
}


#pragma mark - Location Manager Delegate Methods

+ (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
    NSDate *eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 15.0) return;
    locationUpdated = YES;
    currentLocation = newLocation.coordinate;
}

+ (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    locationUpdated = NO;
    
    if (error.code == kCLErrorDenied) {
		
        [UIAlertView alertViewWithMessage:@"Location service is not enabled"];
        
    } else {
        [manager startUpdatingLocation];
    }
}

+(NSString *)getAddressFromLatitude:(double)pdblLatitude andLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%f,%f&output=csv",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
}

+(NSString*) getDistanceFromLatitude:(double)latitude andLongitude:(double)longitude {
    
    if([self isGPSEnabled]) {
        
        if (latitude == 0.0 && longitude == 0.0) {
            
            return @"";
        }
        else
        {
            NSString *distance;
            
            CLLocation *locationFrom = [[CLLocation alloc] initWithLatitude:[self latitude] longitude:[self longitude]];
            CLLocation *locationTo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            CLLocationDistance locationDistance = [locationFrom distanceFromLocation:locationTo];
            
            //Distance in Meters
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingIncrement = [NSNumber numberWithDouble:0.1];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            distance = [NSString stringWithFormat:@"%@ m",[formatter stringFromNumber:[NSNumber numberWithDouble:locationDistance]]];
            
            if(locationDistance > 1000)
            {
                double kmString = locationDistance * 0.001;
                distance = [NSString stringWithFormat:@"%@ km",[formatter stringFromNumber:[NSNumber numberWithDouble:kmString]]];
            }
            else
            {
                distance = [NSString stringWithFormat:@"%@ m",[formatter stringFromNumber:[NSNumber numberWithDouble:locationDistance]]];
            }
            
            return distance;
        }
    }
    else
      return @"";
}

+ (BOOL) isLocationTooFarForLatitude:(double) latitude longitude:(double) longitude {
    
    CLLocation *locationFrom = [[CLLocation alloc] initWithLatitude:[self latitude] longitude:[self longitude]];
    CLLocation *locationTo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance locationDistance = [locationFrom distanceFromLocation:locationTo];
    if (locationDistance > 5000) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) isGPSEnabled
{
    if (! ([CLLocationManager locationServicesEnabled]) || ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	alertVisible = NO;
}


@end

