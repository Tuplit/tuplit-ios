//
//  UITextField+Tuplit.m
//  Tuplit
//
//  Created by ev_mac6 on 22/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UITextField+Tuplit.h"


@implementation UITextField (Tuplit)

- (void)setupForTuplitStyle {
    
    self.background = [UIImage imageNamed:@"textFieldBg"];
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.bounds.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.bounds.size.height)];
    self.rightViewMode = UITextFieldViewModeAlways;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        self.contentVerticalAlignment=0;
}

- (void)setRightViewIcon:(UIImage*)image target:(id)target action:(SEL)selector {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width+20, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
