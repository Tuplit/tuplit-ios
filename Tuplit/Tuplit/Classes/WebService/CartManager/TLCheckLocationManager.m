//
//  TLPayWithUserLocationManager.m
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCheckLocationManager.h"

@implementation TLCheckLocationManager
@synthesize delegate = _delegate;

- (void)dealloc {
	
	_delegate = nil;
}

-(void)callCheckLocationWithMerchantId:(NSString*)merchantId latitude:(NSString*)latitude longitude:(NSString*)longitude{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:CHECK_LOCATION_URL]];
    
    NSDictionary *queryParams=[NSDictionary dictionaryWithObjectsAndKeys:merchantId,@"MerchantId",latitude,@"Latitude",longitude,@"Longitude", nil];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"" parameters:queryParams];
    
    NSLog(@"Request URL : %@",[URL absoluteString]);
    NSLog(@"queryParams : %@",queryParams);
    
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
  	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            [_delegate checkLocationManagerSuccessfull:self allowCart:[[[[responseJSON objectForKey:@"AllowCart"] objectAtIndex:0]valueForKey:@"AllowCart"] integerValue]];
        }
        else
        {
            [_delegate checkLocationManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		[_delegate checkLocationManagerFailed:self];
        
	}];
    
	[operation start];
}

@end
