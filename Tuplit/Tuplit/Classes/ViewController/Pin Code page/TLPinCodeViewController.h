//
//  PinCodeViewController.h
//  Tuplit
//
//  Created by ev_mac8 on 27/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLLoginViewController.h"
#import "TLSetPinManager.h"

@interface TLPinCodeViewController : UIViewController<TLSetPinManagerDelegate>
{
    UIScrollView *scrollView;
    UIView *codeSelectorView,*numberPadView;
    
    CGFloat baseViewWidth,baseViewHeight;
        
    NSMutableArray *normalNumberArray, *selectedNumberArray;
    
    NSString *pinCode;
    
    int count,clickCount;
    float xposition, yposition;
}

@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,retain) NSString *navigationTitle;
@property BOOL isConformPinCode;
@property (nonatomic,retain) NSString *pinCodeValue;


@end
