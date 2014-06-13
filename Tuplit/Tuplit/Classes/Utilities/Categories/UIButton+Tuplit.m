//
//  UIButton+Tuplit.m
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UIButton+Tuplit.h"

@implementation UIButton (Tuplit)

- (void)setUpButtonForTuplit {
    
    UIImage *backButtonImage = getImage(@"buttonBg", NO);
    UIImage *stretchableBackButtonImage = [backButtonImage stretchableImageWithLeftCapWidth:25 topCapHeight:0];
    [self setBackgroundImage:stretchableBackButtonImage forState:UIControlStateNormal];
	self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
}

- (void)backButtonWithTarget:(id)target action:(SEL)selector {
    
    CGFloat delta =  SYSTEM_VERSION_LESS_THAN(@"7.0")?25:0;
    UIImage *backImage = getImage(@"BackArrow", NO);
    self.frame = CGRectMake(0, 0, backImage.size.width+delta, backImage.size.height);
    self.contentMode = UIViewContentModeRight;
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self setImage:backImage forState:UIControlStateNormal];
}

@end
