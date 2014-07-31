//
//  UIBarButtonItem+Tuplit.m
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UIBarButtonItem+Tuplit.h"

@implementation UIBarButtonItem (Tuplit)

- (void)backButtonWithTarget:(id)target action:(SEL)selector {
    
    CGFloat delta =  SYSTEM_VERSION_LESS_THAN(@"7.0")?25:0;
    UIImage *backImage = getImage(@"BackArrow", NO);
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, backImage.size.width+delta, backImage.size.height);
    button.contentMode = UIViewContentModeRight;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:backImage forState:UIControlStateNormal];
    self.customView = button;
}

- (void)buttonWithIcon:(UIImage*)image target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft {
    
    CGFloat delta =  SYSTEM_VERSION_LESS_THAN(@"7.0")?25:0;
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, image.size.width+delta, image.size.height);
    button.contentMode = UIViewContentModeRight; // Check Condition if any
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    self.customView = button;
}
- (void)buttonWithTitle:(NSString*) title withTarget:(id)target action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    int width = [title widthWithFont:button.titleLabel.font];
     button.frame = CGRectMake(0,0, width+1,30);
    self.customView = button;
}
@end
