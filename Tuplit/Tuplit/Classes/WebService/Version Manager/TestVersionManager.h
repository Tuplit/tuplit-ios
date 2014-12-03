//
//  MTLookupsContent.h
//  MotionTraxx
//
//  Created by ev_mac10 on 15/07/14.
//
//

/*
 `MTLookupsContent` is used to get Lookups Content data form server based on current time stamp
 */


#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface TestVersionManager : NSObject
{
    __weak id _delegate;
}
@property (nonatomic,weak) id delegate;

+ (id) sharedManager;
-(void)validateCurrentAppVersion;

@end


@protocol  TestVersionDelegate <NSObject>

-(void)testVersionActionGetSuccessFully:(NSString*)msg;
-(void)testVersionActionGetFailedWithErrorMessage:(NSString*)msg;
-(void)testVersionActionGetFailed;

@end