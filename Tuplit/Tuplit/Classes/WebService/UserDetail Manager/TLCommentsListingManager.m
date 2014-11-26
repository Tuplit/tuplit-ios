//
//  TLCommentsListingManager.m
//  Tuplit
//
//  Created by ev_mac11 on 30/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCommentsListingManager.h"

@implementation TLCommentsListingManager
@synthesize delegate,listedCount,totalCount;

- (void)dealloc {
	
	delegate = nil;
}
-(void) callService:(NSString*)userId withStartCount:(int)start andisUserId:(BOOL)isUserID
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:COMMENT_LISTING_URL]];
    NSDictionary *queryParams;
    if(isUserID)
    {
        queryParams = @{
                        @"UserId": NSNonNilString(userId),
                        @"Type": NSNonNilString(@"1"),
                        @"Start":NSNonNilString([NSString stringWithFormat:@"%d",start]),
                        };
    }
    else
    {
        queryParams = @{
                        @"MerchantId": NSNonNilString(userId),
                        @"Type": NSNonNilString(@"2"),
                        @"Start":NSNonNilString([NSString stringWithFormat:@"%d",start]),
                        };
    }
   
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:queryParams];
    [request addValue:[TLUserDefaults getAccessToken] forHTTPHeaderField:@"Authorization"];
        
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *startTime=[NSDate date];
    NSLog(@"startTime = %@",startTime);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:startTime];
        NSLog(@"CommentListingResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		
        int code=(int)[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            listedCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"listedCount"] integerValue];
            totalCount = [[[responseJSON objectForKey:@"meta"] objectForKey:@"totalCount"] integerValue];
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            NSDictionary *responseDictionarytoMap=[responseJSON objectForKey:strPropertyName];
            
            RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[UserCommentsModel class]];
            [responseMapping addAttributeMappingsFromDictionary:@ {
                @"CommentId"        :   @"CommentId",
                @"CommentsText"     :   @"CommentsText",
                @"CommentDate"      :   @"CommentDate",
                @"UserPhoto"        :   @"UserPhoto",
                @"UserId"           :   @"UserId",
                @"UserName"         :   @"UserName",
                @"merchantId"       :   @"merchantId",
                @"MerchantName"     :   @"MerchantName",
                @"MerchantIcon"     :   @"MerchantIcon",
                
            }];
            NSDictionary *mappingsDictionary = @{ @"": responseMapping };
            RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:responseDictionarytoMap mappingsDictionary:mappingsDictionary];
            NSError *mappingError = nil;
            BOOL isMapped = [mapper execute:&mappingError];
            if (isMapped && !mappingError) {
                
                self.commentslist = mapper.mappingResult.array.copy;
                
                if([delegate respondsToSelector:@selector(commentsListingManagerSuccess:withcommentsList:)])
                    [delegate commentsListingManagerSuccess:self withcommentsList:self.commentslist];
            }
        }
        
        else
        {
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if([delegate respondsToSelector:@selector(commentsListingManager:returnedWithErrorCode:errorMsg:)])
            {
                [delegate commentsListingManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        if([delegate respondsToSelector:@selector(commentsListingManagerFailed:)])
            [delegate commentsListingManagerFailed:self];
        
	}];
    
    [operation start];
}

@end
