//
//  MerchantsCell.h
//  Tuplit
//
//  Created by ev_mac1 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"
//#import "FXBlurView.h"

@interface MerchantsCell : UITableViewCell<EGOImageViewDelegate>
{
    EGOImageView *productImgView;
    UILabel *discountLbl;
    UIImageView * discountImageView;
    //FXBlurView *blurView;
    EGOImageView *merchantImgView;
    UILabel *merchantNameLbl;
    UILabel *descriptionLbl;
    UILabel *distanceLbl;
    UIImageView *distanceImageView;
}

@property (strong, nonatomic) MerchantModel * merchant;

- (void) setMerchant:(MerchantModel *) merchant;

@end
