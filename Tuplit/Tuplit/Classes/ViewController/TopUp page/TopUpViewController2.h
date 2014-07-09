//
//  TopUpViewController2.h
//  Tuplit
//
//  Created by ev_mac8 on 13/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpViewController2 : UIViewController<UITextFieldDelegate>
{
    UIButton *tenRupeeTopUpBtn,*twentyRupeeTopUpBtn;
    UIButton *fiftyRupeeTopUpBtn;
    UITextField *topUpAmountTxt;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSString * amount;
    NSInteger amtType;
}

@end
