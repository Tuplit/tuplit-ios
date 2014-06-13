//
//  UIAlertView+BlockAlert.h
//  Tuplit
//
//  Created by ev_mac6 on 09/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIAlertView+MKBlockAdditions.h"

typedef void (^OnTextOkBlock)(NSString* tx);

@interface UIAlertView (BlockAlert)
+ (UIAlertView*) textAlertWithTitle:(NSString*)title
                            message:(NSString*)message
                          onDismiss:(OnTextOkBlock)ok;
@end
