//
//  UIBarButtonItem+Tuplit.h
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Tuplit)
- (void)backButtonWithTarget:(id)target action:(SEL)selector;
- (void)buttonWithIcon:(UIImage*)image target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft;
@end
