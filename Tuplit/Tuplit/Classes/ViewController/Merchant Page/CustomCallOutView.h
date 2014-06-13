//
//  CustomCallOutViewController.h
//  Tuplit
//
//  Created by ev_mac1 on 20/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"
#import "TLMerchantsDetailViewController.h"
// #import "UILabel+Tuplit.h"

@interface CustomCallOutView : UIImageView
{
    EGOImageView *annLogoImgView;
    UIImageView *customCalloutView;
    UIImageView * nextImageView;
    UIImageView * annDistanceImgView;
    
    UIImage *stretchableBackButtonImage;
    UIImage * callOutImage;
    
    UILabel * annDistanceLbl;
    UILabel * annMerchantNameLbl;
    UILabel * annDiscountLbl;
    
    NSString * logoImageUrl;
}

@property (nonatomic, retain)MerchantModel *merchant;

@end
