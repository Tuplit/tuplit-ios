//
//  TLMerchantsViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MerchantsCell.h"
#import "MerchantSearchCell.h"
#import "CustomCallOutView.h"
#import "TLMerchantsDetailViewController.h"
#import "TLMerchantListingManager.h"
#import "TLCategoryListingManager.h"
#import "ChoiceButton.h"
#import "TLAddCommentViewController.h"
#define MERCHANT_CELL_HEIGHT 130
#define SEARCH_CELL_HEIGHT    50

typedef NS_ENUM(NSInteger, ActionRequestType) {
    MCSearch = 0,
    MCCategory = 1,
    MCNearBy = 2,
    MCPopular = 3,
};

@interface TLMerchantsViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,TLMerchantListingManagerDelegate,ChoiceButtonDelegate,TLCategoryListingManagerDelegate,CustomCallOutViewDelegate>
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
    ChoiceButton *choiceButton;
    UILabel *merchantErrorLabel,*searchErrorLabel;
    NSMutableArray *merchantsArray,*searchArray,*categoryArray;
    
    TLMerchantListingModel *merchantListingModel;
    TLMerchantListingManager *merchantListingManager;
    
    BOOL isDiscountShown, isMapShown;
    BOOL isSearchTableShown;
    CGFloat baseViewWidth, baseViewHeight;
    int adjustHeight;
    int menuSelected,discountTierValue;
    int totalUserListCount,lastFetchCount;
    BOOL isLoadMorePressed,isPullRefreshPressed,isTextFieldClearPressed,isMerchantWebserviceRunning,isKeyBoardOpen;
    
    int adjustViewForIOS7;
    NSString *categoryId;
    
    MerchantModel *callOutmerchant;
}
@end
