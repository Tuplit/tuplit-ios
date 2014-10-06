//
//  TLFavouriteListingManager.m
//  Tuplit
//
//  Created by ev_mac11 on 03/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLFavouriteListingManager.h"

AFHTTPRequestOperation *operation;

@implementation TLFavouriteListingManager
@synthesize listedCount,totalCount,favouriteArray;
- (void)dealloc {
	
	_delegate = nil;
}

-(void) callService:(TLMerchantListingModel*) merchantListingModel;
{
    self.merchantListModel = merchantListingModel;
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:FAVOURITE_LIST_URL]];
    
    NSDictionary *queryParams = @{
                                  @"Latitude": NSNonNilString(merchantListingModel.Latitude),
                                  @"Longitude": NSNonNilString(merchantListingModel.Longitude),
//                                  @"Type": NSNonNilString(merchantListingModel.Type),
                                  @"Start": NSNonNilString(merchantListingModel.Start),
                                  @"Search": NSNonNilString(merchantListingModel.SearchKey),
                                  };
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
    NSLog(@"QueryParams : %@",queryParams);
        
	operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"FavListingResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response : %@",responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code==200 || code==201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            listedCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"listedCount"] integerValue];
            totalCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"totalCount"] integerValue];
            
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MerchantModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"MerchantId": @"MerchantID",
                                                                  @"Icon": @"Icon",
                                                                  @"Image": @"Image",
                                                                  @"DiscountTier": @"DiscountTier",
                                                                  @"CompanyName": @"CompanyName",
                                                                  @"ShortDescription": @"ShortDescription",
                                                                  @"Address": @"Address",
                                                                  @"ItemsSold": @"ItemsSold",
                                                                  @"Latitude": @"Latitude",
                                                                  @"Longitude": @"Longitude",
                                                                  @"distance": @"distance",
                                                                  @"IsSpecial": @"IsSpecial",
                                                                  @"IsGoldenTag" : @"IsGoldenTag",
                                                                  @"Category" : @"Category",
                                                                  @"TotalUsersShopped" : @"TotalUsersShopped",
                                                                  @"TagType" : @"TagType",
                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.favouriteArray = mapper.mappingResult.array.copy;
                
                if(_delegate)
                    [_delegate favouriteManagerSuccessfull:self withFavouriteList:self.favouriteArray];
            }
        }
        else
        {
            if (_delegate)
                [_delegate favouriteManager:self returnedWithErrorCode:[NSString stringWithFormat:@"%d",code] errorMsg:[[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"]];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [_delegate favouriteManagerFailed:self];
	}];
    
	[operation start];
}
-(void) cancelRequest {
    
    [operation cancel];
}
@end
