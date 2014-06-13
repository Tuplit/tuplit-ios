//
//  UITextField+Tuplit.h
//  Tuplit
//
//  Created by ev_mac6 on 22/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Tuplit)
- (void)setupForTuplitStyle;
- (void)setRightViewIcon:(UIImage*)image target:(id)target action:(SEL)selector;
@end
