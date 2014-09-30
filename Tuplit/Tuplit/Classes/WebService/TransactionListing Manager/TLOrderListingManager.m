//
//  TLOrderListingManager.m
//  Tuplit
//
//  Created by ev_mac11 on 26/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLOrderListingManager.h"

@implementation TLOrderListingManager
@synthesize delegate;

- (void)dealloc {
	
	delegate = nil;
}
-(void) callService:(NSString*) orderID
{
    NSString *url = [NSString stringWithFormat:TRANSACTION_DETAIL_URL,orderID];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:nil];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"Request : %@", [request.URL absoluteString]);
    NSLog(@"Method  : %@", request.HTTPMethod);
    
    NSDate *start=[NSDate date];
    
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSDate *end=[NSDate date];
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"OrderListingResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        NSLog(@"Response: %@",responseJSON);
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping* produstsMapping = [RKObjectMapping mappingForClass:[OrderProductModel class]];
            [produstsMapping addAttributeMappingsFromDictionary:@ {
                @"ProductID"              :   @"ProductID",
                @"ItemName"               :   @"ItemName",
                @"Photo"                  :   @"Photo",
                @"ProductsQuantity"       :   @"ProductsQuantity",
                @"ProductsCost"           :   @"ProductsCost",
                @"DiscountPrice"          :   @"DiscountPrice",
                @"TotalPrice"             :   @"TotalPrice",
                
                
            }];
            
            
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[OrderDetailModel class]];
            [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Products" toKeyPath:@"Products" withMapping:produstsMapping]];
            [responseMapping addAttributeMappingsFromDictionary:@ {
                @"OrderId"        :   @"OrderId",
                @"CartId"         :   @"CartId",
                @"UserId"         :   @"UserId",
                @"MerchantId"     :   @"MerchantId",
                @"TotalPrice"     :   @"TotalPrice",
                @"TransactionId"  :   @"TransactionId",
                @"CompanyName"    :   @"CompanyName",
                @"Address"        :   @"Address",
                @"Location"       :   @"Location",
                @"Photo"          :   @"Photo",
                @"FirstName"      :   @"FirstName",
                @"LastName"       :   @"LastName",
                @"Email"          :   @"Email",
                @"OrderDate"      :   @"OrderDate",
                @"OrderDoneBy"    :   @"OrderDoneBy",
                @"UniqueId"       :   @"UniqueId",
                
            }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.orderDetailsModel = mapper.mappingResult.firstObject;
                
                if([delegate respondsToSelector:@selector(orderDetailsManagerSuccessful:withorderDetails:)])
                    [delegate orderDetailsManagerSuccessful:self withorderDetails:self.orderDetailsModel];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if([delegate respondsToSelector:@selector(orderDetailsManager:returnedWithErrorCode:errorMsg:)])
            {
                [delegate orderDetailsManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if([delegate respondsToSelector:@selector(orderDetailsManagerFailed:)])
            [delegate orderDetailsManagerFailed:self];
        
	}];
    [operation start];
    
}

@end
