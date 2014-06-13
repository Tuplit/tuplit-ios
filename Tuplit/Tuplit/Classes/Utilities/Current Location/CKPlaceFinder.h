//
//  ETRouteFinder.h
//  Easy Traveller
//
//

#import <Foundation/Foundation.h>

//#define KGoolePalcesParams @"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%@,%@&radius=50000&query=%@&sensor=true&key="kGooglePlacesAPIKey
#define KGoolePalcesParams @"https://maps.googleapis.com/maps/api/place/search/json?location=%@,%@&radius=1000&types=food|restaurant&sensor=true&key="kGooglePlacesAPIKey


@protocol CKPlaceFinderDelegate <NSObject>
- (void)placeFindedDidFindPlaces:(NSArray *)places;
- (void)placeFinderConnectionError;
@end

@interface CKPlaceFinder : NSObject {
    
    NSMutableData *receivedData;
	NSURLConnection *conn;
    BOOL isConnectionExist;
}

@property(nonatomic, assign) BOOL isAutoComp;
@property(nonatomic, assign) id <CKPlaceFinderDelegate> delegate;

+ (id)shared;
- (void)findPlaces:(NSString *)params;

@end




