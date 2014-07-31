//
//  TLOrderConformViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLOrderConformViewController : UIViewController
{
     CGFloat baseViewWidth,baseViewHeight;
    
    UILabel *informativeLbl;
    UIImageView *statusImgView;
    UIButton *backButton;
    UILabel *backLbl;
}
@property(nonatomic,strong)NSString *informativeTxt;
@property(nonatomic,strong)UIImage *acceptOrRejectImg;
@property(nonatomic,strong)NSString *btnTitle;
@property(nonatomic,strong)NSString *lblTitle;
@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *orderStatus;
@property(nonatomic,strong)NSString *merchatID;
@property(nonatomic,strong)NSString *merchatName;
@end
