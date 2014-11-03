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
#import "FriendsListModel.h"
#import "OpeningHoursModel.h"
#import "CommentsModel.h"
#import "ProductListModel.h"
#import "SpecialProductsModel.h"
#import "MenuProductsModel.h"
#import "TLAddFavouriteManager.h"
#import "TLOtherUserProfileViewController.h"
#import <MessageUI/MessageUI.h>
#import "TLFavouriteListViewController.h"
#import "TLAllCommentsViewController.h"


@interface TLMerchantsDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, MKMapViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,TLMerchantDetailsManagerDelegate,TLAddFavouriteManagerDelegate>
{
    EGOImageView * merchantImageView;
    UILabel * customerLabel,*specialSoldLabel;
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
    UIImageView * discountImageView;
    
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
    
    UIView *blurView;
    
    int totalComments;

}

@property (nonatomic,retain) NSString * detailsMerchantID;
@property (nonatomic,retain)  MerchantModel * merchantModel;


@end
