//
//  SearchTableCell.h
//  Tuplit
//
//  Created by ev_mac1 on 17/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "merchantModel.h"
#import "TLMerchantsViewController.h"
#import "CategoryModel.h"

@interface MerchantSearchCell : UITableViewCell
{
    EGOImageView *merchantImgView;
    UILabel *merchantNameLbl;
    UILabel *descriptionLbl;
    UIImageView * discountImageView;
    UILabel *distanceLbl;
    UILabel *discountLbl;
    UIImageView *distanceImageView;
}

@property (strong, nonatomic) MerchantModel *merchant;

- (void) setMerchant:(MerchantModel *) merchant;
- (void) setCategory:(CategoryModel *) categoryModel;

@end
