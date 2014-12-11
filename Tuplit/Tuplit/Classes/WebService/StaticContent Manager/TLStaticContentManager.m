//
//  TLStaticContentManager.m
//  Tuplit
//
//  Created by ev_mac6 on 19/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLStaticContentManager.h"

@implementation TLStaticContentManager

- (void)dealloc {
	
	_delegate = nil;
}

- (void)getStaticContents {
	
    NSString *strServerURL = STATIC_CONTENT_URL;
    strServerURL = [strServerURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *URL = [NSURL URLWithString:strServerURL];
	AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"" parameters:nil];
    
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[AFHTTPRequestOperation addAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)]];
    
    NSDate *start=[NSDate date];
    NSLog(@"startTime = %@",start);
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDate *end=[NSDate date];
        NSLog(@"endTime = %@",end);
        double ellapsedSeconds= [end timeIntervalSinceDate:start];
        NSLog(@"StaticContentResponsetime = %f",ellapsedSeconds);
        
        NSData *data =[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error=nil;
		NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        int code=[[[responseJSON objectForKey:@"meta"] objectForKey:@"code"] integerValue];
        
        if(code == 200 || code == 201)
        {
            NSString * strPropertyName = [[responseJSON objectForKey:@"meta"] objectForKey:@"dataPropertyName"];
            
            Global *obj = [Global instance];
            
            NSArray *array = [[responseJSON objectForKey:strPropertyName] valueForKey:@"cms"];
            
            for (NSDictionary *dict in array) {
                
                if([[dict valueForKey:@"PageName"] isEqualToString:@"About"])
                    obj.aboutContent = dict[@"Content"];
                else if([[dict valueForKey:@"PageName"] isEqualToString:@"Privacy Policy"])
                    obj.privacyContent = dict[@"Content"];
                else if([[dict valueForKey:@"PageName"] isEqualToString:@"Terms of Use"])
                    obj.termsContent = dict[@"Content"];
                else if([[dict valueForKey:@"PageName"] isEqualToString:@"FAQ"])
                    obj.faqUrl = dict[@"Content"];
                else
                {
                    
                }
            }
            
            NSString *legalContent = [[responseJSON objectForKey:strPropertyName] valueForKey:@"Legal"];
            if(legalContent.length>0)
                obj.legalContent = legalContent;

            array = [[responseJSON objectForKey:strPropertyName] valueForKey:@"HomeSlider"];
            obj.welcomeScreenImages = [array valueForKey:@"ImageUrl"];
            
            array = [[responseJSON objectForKey:strPropertyName] valueForKey:@"TutorialSlider"];
            obj.tutorialScreenImages = [array valueForKey:@"ImageUrl"];
            
            obj.discoutTiers = [[responseJSON objectForKey:strPropertyName]valueForKey:@"DiscountTier"];
            
            if([_delegate respondsToSelector:@selector(staticContentManagerSuccess:)])
                [_delegate staticContentManagerSuccess:self];
            
            
            NSString *inviteMsg = [[responseJSON objectForKey:strPropertyName] valueForKey:@"FriendInviteMessage"];
            [TLUserDefaults setInviteMsg:inviteMsg];
            
            NSString *iTunesurl = [[responseJSON objectForKey:strPropertyName] valueForKey:@"ItunesURL"];
            [TLUserDefaults setItunesURL:iTunesurl];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kStaticContentRetrived object:nil];
            
        }
        else
        {
            [[ProgressHud shared]hide];
            [[NSNotificationCenter defaultCenter]postNotificationName:kStaticContentRetrived object:nil];
            NSString *errorMsg = [[responseJSON objectForKey:@"meta"] objectForKey:@"errorMessage"];
            if([_delegate respondsToSelector:@selector(staticContentManager:returnedWithErrorCode:errorMsg:)])
                [_delegate staticContentManager:self returnedWithErrorCode:StringFromInt(code) errorMsg:errorMsg];
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
        [[ProgressHud shared] hide];
        [[NSNotificationCenter defaultCenter]postNotificationName:kStaticContentRetrived object:nil];
        [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
        if([_delegate respondsToSelector:@selector(staticContentManagerFailed:)])
            [_delegate staticContentManagerFailed:self];
        
	}];
    
	[operation start];
}


@end
