//
//  NSString+StringFunctions.h
//  myWeather
//
//  Created by ev_mac5 on 01/03/14.
//  Copyright (c) 2014 ev_mac5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringFunctions)

- (CGFloat)widthWithFont:(UIFont *)font;
- (CGFloat)heigthWithWidth:(CGFloat)width andFont:(UIFont *)font;
- (NSString *)URLEncodeStringFromString;

@end
