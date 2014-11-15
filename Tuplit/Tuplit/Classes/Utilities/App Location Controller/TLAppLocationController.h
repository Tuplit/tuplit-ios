//
//  TLAppLocationController.h
//  Tuplit
//
//  Created by ev_mac11 on 12/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLCurrentLocationManager.h"

@interface TLAppLocationController : NSObject<TLCurrentLocationManagerDelegate>

{
    NSTimer *timer;
}

+(id)sharedManager;
-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;
@end
