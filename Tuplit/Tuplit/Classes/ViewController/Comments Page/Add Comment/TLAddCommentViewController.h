//
//  AddCommentViewController.h
//  Tuplit
//
//  Created by ev_mac8 on 21/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"
#import "TuplitConstants.h"
#import "TLAddCommentManager.h"
#import <Social/Social.h>

@interface TLAddCommentViewController : UIViewController<UITextViewDelegate,TLAddCommentManagerDelegate>
{
    CustomSwitch *facebookSwitch,*twitterSwitch;
    CGFloat baseViewWidth,baseViewHeight;
}
@end
