//
//  PinAnnotation.h
//  CustomCalloutSample
//
//  Created by tochi on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CalloutAnnotation.h"


@interface PinAnnotation : NSObject <MKAnnotation>
{
@private
    NSString *_titlestr;
    NSString *_subTitle;
    
    CLLocationCoordinate2D _coordinate;
    CalloutAnnotation *_calloutAnnotation;
}
@property (nonatomic, readwrite, copy)  NSString *subtitle;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CalloutAnnotation *calloutAnnotation;

@end
