//
//  ETRouteFinder.m
//  Easy Traveller
//
//

#import "CKPlaceFinder.h"
#import "SBJSON.h"

static CKPlaceFinder *_shared = nil;


@interface CKPlaceFinder ()
- (void)cancelRequest;
@end


@implementation CKPlaceFinder

@synthesize delegate=_delegate;
@synthesize isAutoComp;


+ (id)shared {
    
    if (!_shared) _shared = [CKPlaceFinder new];
    return _shared;
}

- (void)findPlaces:(NSString *)params {
    
    [self cancelRequest];
    
    NSString *urlStr;
    urlStr = params;	//[kGooglePlacesURL stringByAppendingString:params];
	
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)dealloc {
	
	[self cancelRequest];
}

/******************************** Userdefined methods ***************************************/

- (void)cancelRequest {
	
	if (isConnectionExist) {
		
        [conn cancel];
        conn = nil;
        isConnectionExist = NO;
        receivedData = nil;
	}
}

/******************************** Delegate methods ***************************************/


#pragma mark - NSURLConnection delegate methods

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	
	return nil;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	
	isConnectionExist=YES;	
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
    receivedData = [[NSMutableData alloc] init];
    [receivedData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]; 
    SBJSON *json = [SBJSON new];
    NSDictionary *dict = (NSDictionary *)[json objectWithString:response error:nil];
	
    [_delegate placeFindedDidFindPlaces:[dict valueForKey:@"results"]];			// OLD
	
	[self cancelRequest];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    [_delegate placeFinderConnectionError];
	[self cancelRequest];
}


@end


