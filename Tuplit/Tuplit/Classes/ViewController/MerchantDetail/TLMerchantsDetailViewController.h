//
//  TLMerchantsDetailViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLMerchantsViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TLMerchantDetailsManager.h"
#import "MerchantsDetailsModel.h"
#import "MerchantModel.h"
#import "OrderedFriendsListModel.h"
#import "OpeningHoursModel.h"
#import "CommentsModel.h"
#import "ProductListModel.h"
#import "SpecialProductsModel.h"
#import "MenuProductsModel.h"



@interface TLMerchantsDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,TLMerchantDetailsManagerDelegate, MKMapViewDelegate,UIAlertViewDelegate>
{
    EGOImageView * merchantImageView;
    UILabel * customerLabel;
    UILabel* labelDiscount;
    EGOImageView *merchantLogoView;
    UILabel * friendsLabel;
    EGOImageView *friendsImgView1;
    EGOImageView *friendsImgView2;
    EGOImageView *friendsImgView3;
    
    UITableView * merchantDetailTable;
    
    UIButton * detailsButton;
    UIButton * orderButton;
    UIButton *buttonDiscount;
    UIButton *butDiscount;
    UIBarButtonItem *rightExpandButton;
    
    UIImage *mapIconImg;
    UIImageView *mapIconImgView;
    
    NSMutableArray *merchantsArray;
    CGFloat baseViewWidth, baseViewHeight;
    BOOL isDetailButton,isAllowCartEnabled;
    
    MerchantsDetailsModel * merchantdetailmodel;
    SpecialProductsModel *specialProductDetails;
    MenuProductsModel *menuProductDetails;
    SpecialProductsModel *discountProductDetails;
    
    NSDictionary *detailMainDict;
    NSDictionary *orderedMainDict;
    
    NSArray *merchantDetailsArray;
    
    NSNumberFormatter *numberFormatter;
    
    UILabel *cartItemCountLbl;
    UILabel *totItemPrizeLbl;
    UIView *cartBarView;
    UIButton *selectedCartButton;

}

@property (nonatomic,retain) NSString * detailsMerchantID;
@property (nonatomic,retain)  MerchantModel * merchantModel;


@end
