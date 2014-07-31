//
//  CalloutAnnotation.h
//  CustomCalloutSample
//
//  Created by tochi on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CalloutAnnotation : NSObject <MKAnnotation>
{
@private
    NSString *_titlestr;
    NSString *_subTitle;
    CLLocationCoordinate2D _coordinate;
}
@property (nonatomic, readwrite, copy)  NSString *subTitle;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
