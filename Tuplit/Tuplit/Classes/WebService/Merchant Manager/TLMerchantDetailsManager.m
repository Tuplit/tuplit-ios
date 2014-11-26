//
//  TLMerchantDetailsManager.m
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLMerchantDetailsManager.h"
AFHTTPRequestOperation *operation;

@implementation TLMerchantDetailsManager

@synthesize delegate,merchantDetailsModel,isAllowCartEnabled;

- (void)dealloc {
	
	delegate = nil;
}

-(void) callService:(TLMerchantListingModel *) merchantListingModel
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:MERCHANT_DETAILS_URL,merchantListingModel.MerchantID]];
    
    NSString *userID = @"";
    if(![TLUserDefaults isGuestUser])
        userID = [TLUserDefaults getCurrentUser].UserId;
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    NSDictionary *queryParams = @{
                                  @"Latitude": NSNonNilString(merchantListingModel.Latitude),
                                  @"Longitude": NSNonNilString(merchantListingModel.Longitude),
                                  @"UserId" : NSNonNilString(userID),
                                  };
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:queryParams];
      
	operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"MerchantDetailResponsetime = %f",ellapsedSeconds);
        
        NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"Response = %@",responseJSON);
		        
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            self.isAllowCartEnabled = [[[responseJSON objectForKey:@"meta"] objectForKey:@"AllowCart"] intValue];
            self.totalComments = [[responseJSON objectForKey:strPropertyName]objectForKey:@"TotalComments"];
            
            RKObjectMapping* openingHoursMapping = [RKObjectMapping mappingForClass:[OpeningHoursModel class]];
            [openingHoursMapping addAttributeMappingsFromDictionary:@ {
                @"Open"                 : @"Open",
                @"Closed"               : @"Closed",
                
            }];
            
            RKObjectMapping* orderedFriendsMapping = [RKObjectMapping mappingForClass:[FriendsListModel class]];
            [orderedFriendsMapping addAttributeMappingsFromDictionary:@ {
                @"id"               : @"Id",
                @"FirstName"        : @"FirstName",
                @"LastName"         : @"LastName",
                @"Photo"            : @"Photo",
            }];
            
            RKObjectMapping* commentsMapping = [RKObjectMapping mappingForClass:[CommentsModel class]];
            [commentsMapping addAttributeMappingsFromDictionary:@ {
                @"UsersId"           : @"UsersId",
                @"FirstName"        : @"FirstName",
                @"LastName"         : @"LastName",
                @"Photo"            : @"Photo",
                @"CommentsText"     : @"CommentsText",
                @"CommentDate"      : @"CommentDate",
                
            }];
            
            //productlist
            RKObjectMapping* specialProductMapping = [RKObjectMapping mappingForClass:[SpecialProductsModel class]];
            [specialProductMapping addAttributeMappingsFromDictionary:@ {
                @"ProductId"         : @"ProductId",
                @"ItemName"          : @"ItemName",
                @"Photo"             : @"Photo",
                @"Price"             : @"Price",
                @"DiscountPrice"     : @"DiscountPrice",
                @"DiscountTier"      : @"DiscountTier",
                @"DiscountApplied"   : @"DiscountApplied",
                @"Ordering"          : @"Ordering",
                @"Status"            : @"Status",
                
            }];
            
            RKObjectMapping* menuProductMapping = [RKObjectMapping mappingForClass:[MenuProductsModel class]];
            [menuProductMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Items" toKeyPath:@"Items" withMapping:specialProductMapping]];
            [menuProductMapping addAttributeMappingsFromDictionary:@ {
                @"CategoryId"         : @"CategoryId",
                @"CategoryName"       : @"CategoryName",
            }];
            
            RKObjectMapping* categoryMerchantMapping = [RKObjectMapping mappingForClass:[CategoryModel class]];
            [categoryMerchantMapping addAttributeMappingsFromDictionary:@ {
                @"CategoryId"         : @"CategoryId",
                @"CategoryName"       : @"CategoryName",
                @"CategoryIcon"       : @"CategoryIcon"
            }];
            
            
            RKObjectMapping* productsListMapping = [RKObjectMapping mappingForClass:[ProductListModel class]];
            
            [productsListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"SpecialProducts" toKeyPath:@"SpecialProducts" withMapping:specialProductMapping]];
            [productsListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DiscountProducts" toKeyPath:@"DiscountProducts" withMapping:specialProductMapping]];
            [productsListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"MenuProducts" toKeyPath:@"MenuProducts" withMapping:menuProductMapping]];
            
            //main part
            RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MerchantsDetailsModel class]];
            
            [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"OpeningHours" toKeyPath:@"OpeningHours" withMapping:openingHoursMapping]];
            [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"OrderedFriendsList" toKeyPath:@"OrderedFriendsList" withMapping:orderedFriendsMapping]];
            [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Comments" toKeyPath:@"Comments" withMapping:commentsMapping]];
            [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ProductList" toKeyPath:@"ProductList" withMapping:productsListMapping]];
            [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"CategoryList" toKeyPath:@"CategoryList" withMapping:categoryMerchantMapping]];
            
            [responseMapping addAttributeMappingsFromDictionary:@{
                                                                  @"Id": @"id",
                                                                  @"MerchantId": @"MerchantId",
                                                                  @"FirstName": @"FirstName",
                                                                  @"LastName": @"LastName",
                                                                  @"Email": @"Email",
                                                                  @"CompanyName": @"CompanyName",
                                                                  @"Address": @"Address",
                                                                  @"Location": @"Location",
                                                                  @"Latitude": @"Latitude",
                                                                  @"Longitude": @"Longitude",
                                                                  @"PhoneNumber": @"PhoneNumber",
                                                                  @"WebsiteUrl": @"WebsiteUrl",
                                                                  @"Icon": @"Icon",
                                                                  @"Image": @"Image",
                                                                  @"Description": @"Description",
                                                                  @"ShortDescription": @"ShortDescription",
                                                                  @"distance": @"distance",
                                                                  @"DiscountTier": @"DiscountTier",
                                                                  @"DiscountType": @"DiscountType",
                                                                  @"DiscountProductId": @"DiscountProductId",
                                                                  @"SpecialIcon": @"SpecialIcon",
                                                                  @"ItemsSold": @"ItemsSold",
                                                                  @"PriceRange" : @"PriceRange",
                                                                  @"SpecialsSold" : @"SpecialsSold",
                                                                  @"AlreadyFavourited" : @"AlreadyFavourited",
                                                                  @"Category" : @"Category",
                                                                  @"OrderCount" : @"OrderCount",
                                                                  @"OrderedFriendsCount" : @"OrderedFriendsCount",
                                                                  @"CustomersCount" : @"CustomersCount",
                                                                  @"IsGoldenTag"  : @"IsGoldenTag",
                                                                  @"slideshow" : @"slideshow",
                                                                  @"TagType" : @"TagType",
                                                                  @"ProductVAT" : @"ProductVAT",
                                                                  
                                                                  }];
            
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.merchantDetailsModel = mapper.mappingResult.firstObject;
                
                if([delegate respondsToSelector:@selector(merchantDetailsManagerSuccessful:withMerchantDetails:)])
                    [delegate merchantDetailsManagerSuccessful:self withMerchantDetails:self.merchantDetailsModel];
            }
        }
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if([delegate respondsToSelector:@selector(merchantDetailsManager:returnedWithErrorCode:errorMsg:)])
            {
                [delegate merchantDetailsManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
            }
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if([delegate respondsToSelector:@selector(merchantDetailsManagerFailed:)])
            [delegate merchantDetailsManagerFailed:self];
        
	}];
    
	[operation start];
}

@end

