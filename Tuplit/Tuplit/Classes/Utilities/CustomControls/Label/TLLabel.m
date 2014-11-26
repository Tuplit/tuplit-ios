//
//  TLLabel.m
//  Tuplit
//
//  Created by ev_mac11 on 24/11/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLLabel.h"

@implementation TLLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
