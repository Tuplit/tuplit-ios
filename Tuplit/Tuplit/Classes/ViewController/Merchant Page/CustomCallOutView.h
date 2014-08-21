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
#import "CalloutAnnotation.h"
// #import "UILabel+Tuplit.h"

@class CustomCallOutView;
@protocol CustomCallOutViewDelegate
@required
- (void)calloutButtonClicked:(NSString *)title;
@end

@interface CustomCallOutView : MKAnnotationView
{
    EGOImageView *annLogoImgView;
    UIImageView *customCalloutView;
    UIImageView * nextImageView;
    UIImageView * annDistanceImgView;
    UIImageView * anncustomerShoppedImg;
    
    UIImage *stretchableBackButtonImage;
    UIImage * callOutImage;
    
    UILabel * annDistanceLbl;
    UILabel * annMerchantNameLbl;
    UILabel * annMerchantCatgLbl;
    UILabel * customershoppedLbl;
    UILabel * annDiscountLbl;
    
    NSString * logoImageUrl;
    
    MerchantModel *merModel;
}

@property (nonatomic, retain)MerchantModel *merchant;
@property(nonatomic, unsafe_unretained) id<CustomCallOutViewDelegate> delegate;
-(void)loadView;

@end
