//
//  TLCategoryViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 22/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MerchantsCell.h"
#import "MerchantSearchCell.h"
#import "CustomCallOutView.h"
#import "TLMerchantsDetailViewController.h"
#import "TLMerchantListingManager.h"
#import "TLAddCommentViewController.h"
#define MERCHANT_CELL_HEIGHT 130

@interface TLCategoryViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate,TLMerchantListingManagerDelegate,TLCategoryListingManagerDelegate,CustomCallOutViewDelegate>
{
    UIBarButtonItem *rightExpandButton;
    UIView *contentView,*menuView,*searchbarView;
    UIImageView *mapIconImgView;
    UITableView *merchantTable;
    UITableView * searchTable;
    MKMapView *mapView;
    UIButton *buttonDiscount;
    UIButton *butDiscount;
    UITextField *searchTxt;
    UIRefreshControl *refreshControl;
    UIButton *buttonNearby;
    UIView *cellContainer;
    UIView *cmtPromptView;
    UILabel *merchantNameLabel;
    
    UILabel *merchantErrorLabel,*searchErrorLabel;
    NSMutableArray *merchantsArray,*searchArray,*categoryArray;
    NSDictionary *disCountDict;
    
    UITableView * discountTable;
    UIView *discountView;
    
    TLMerchantListingModel *merchantListingModel;
    TLMerchantListingManager *merchantListingManager;
    
    BOOL isDiscountShown, isMapShown;
    BOOL isSearchTableShown;
    CGFloat baseViewWidth, baseViewHeight;
    int adjustHeight;
    int menuSelected,discountTierValue;
    int totalUserListCount,lastFetchCount;
    BOOL isLoadMorePressed,isPullRefreshPressed,isTextFieldClearPressed,isMerchantWebserviceRunning,isKeyBoardOpen,isnearBy;
    
    int adjustViewForIOS7,keyboardHeight;
    
    MerchantModel *callOutmerchant;
    
    NSMutableDictionary *catgDict;
    
}
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *navTitle;
@end

