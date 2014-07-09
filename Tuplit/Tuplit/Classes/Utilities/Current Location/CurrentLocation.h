

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface CurrentLocation : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate> {
    
}

+ (void)start;
+ (BOOL)isLocationUpdated;
+ (CLLocationCoordinate2D)coordinate;
+ (CLLocationDegrees)latitude;
+ (CLLocationDegrees)longitude;
+ (NSString *)latitudeString;
+ (NSString *)longitudeString;
+ (NSString *)Country;
+ (NSString *)Zip;
+ (NSString *)stateAndCountry;
+ (NSString *)address;
+ (NSString *)getAddressFromLatitude:(double)pdblLatitude andLongitude:(double)pdblLongitude;
+ (NSString*)getDistanceFromLatitude:(double)latitude andLongitude:(double)longitude;
+ (BOOL) isLocationTooFarForLatitude:(double) latitude longitude:(double) longitude;
+ (BOOL) isGPSEnabled;
@end