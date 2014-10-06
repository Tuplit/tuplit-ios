//
//  TLMerchantListingManager.m
//  Tuplit
//
//  Created by ev_mac5 on 28/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLMerchantListingManager.h"

AFHTTPRequestOperation *operation;

@implementation TLMerchantListingManager

@synthesize delegate,merchantArray,merchantListModel,listedCount,totalCount;

- (void)dealloc {
	
	delegate = nil;
}

-(void) callService:(TLMerchantListingModel*) merchantListingModel {
    
    merchantListModel = merchantListingModel;
    
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:MERCHANT_LISTING_URL]];

    NSDictionary *queryParams = @{
                                  @"Latitude": NSNonNilString(merchantListingModel.Latitude),
                                  @"Longitude": NSNonNilString(merchantListingModel.Longitude),
                                  @"Type": NSNonNilString(merchantListingModel.Type),
                                  @"Start": NSNonNilString(merchantListingModel.Start),
                                  @"SearchKey": NSNonNilString(merchantListingModel.SearchKey),
                                  @"DiscountTier": NSNonNilString(merchantListingModel.DiscountTier),
                                  @"Category": NSNonNilString(merchantListingModel.Category),
                                  };
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:queryParams];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
     
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"MerchantListResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        NSLog(@"Response: %@", responseJSON);
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
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
                                                                  @"NewTag" : @"NewTag",
                                                                  @"Category" : @"Category",
                                                                  @"TotalUsersShopped" : @"TotalUsersShopped",
                                                                  @"TagType" : @"TagType",
                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.merchantArray = mapper.mappingResult.array.copy;
            
                if([delegate respondsToSelector:@selector(merchantListingManager:withMerchantList:)])
                    [delegate merchantListingManager:self withMerchantList:self.merchantArray];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if([delegate respondsToSelector:@selector(merchantListingManager:returnedWithErrorCode:errorMsg:)])
            {
                [delegate merchantListingManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
            }
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if(error.code!=-999)
        {
            if([delegate respondsToSelector:@selector(merchantListingManager:)])
                [delegate merchantListingManager:self];
        }
        
	}];
    
	[operation start];
}

-(void) cancelRequest {
    
    [operation cancel];
}

@end
