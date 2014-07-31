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
#import "TLVerifyPinManager.h"

@class TLPinCodeViewController;
@protocol TLPinCodeVerifiedDelegate <NSObject>
@optional
-(void)pincodeVerified;

@end

@interface TLPinCodeViewController : UIViewController<TLSetPinManagerDelegate,TLVerifyPinManagerDelegate>
{
    UIScrollView *scrollView;
    UIView *codeSelectorView,*numberPadView;
    
    CGFloat baseViewWidth,baseViewHeight;
        
    NSMutableArray *normalNumberArray, *selectedNumberArray;
    
    NSString *pinCode;
    
    int count,clickCount;
    float xposition, yposition;
    BOOL isPinVerfied;
}

@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,retain) NSString *navigationTitle;
@property BOOL isConformPinCode;
@property (nonatomic,retain) NSString *pinCodeValue;
@property BOOL isverifyPin;

@property(nonatomic, unsafe_unretained) id <TLPinCodeVerifiedDelegate> delegate;

@end
