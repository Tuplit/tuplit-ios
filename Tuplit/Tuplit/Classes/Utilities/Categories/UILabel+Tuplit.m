//
//  UILabel+Tuplit.m
//  Tuplit
//
//  Created by ev_mac1 on 23/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UILabel+Tuplit.h"

@implementation UILabel (Tuplit)

-(void) setUpLabelCommonStyle
{
    self.textColor = UIColorFromRGB(0x000000);
    self.backgroundColor = [UIColor clearColor];
    self.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    self.userInteractionEnabled = YES;
    self.textAlignment = NSTextAlignmentLeft;
}

@end
