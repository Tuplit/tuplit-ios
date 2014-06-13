//
//  NSString+StringFunctions.m
//  myWeather
//
//  Created by ev_mac5 on 01/03/14.
//  Copyright (c) 2014 ev_mac5. All rights reserved.
//

#import "NSString+StringFunctions.h"

@implementation NSString (StringFunctions)

- (CGFloat)widthWithFont:(UIFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:self attributes:attributes] size].width;
}

- (CGFloat)heigthWithWidth:(CGFloat)width andFont:(UIFont *)font
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [self length])];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

- (NSString *)URLEncodeStringFromString
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)self;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

@end
