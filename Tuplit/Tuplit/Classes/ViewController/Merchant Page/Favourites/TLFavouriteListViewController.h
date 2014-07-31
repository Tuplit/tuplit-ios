//
//  TLFavouriteListViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 14/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MerchantsCell.h"
#import "MerchantSearchCell.h"
#import "TLMerchantsDetailViewController.h"
#import "TLCategoryListingManager.h"
#import "TLAddCommentViewController.h"
#import "TLFavouriteListingManager.h"
#define MERCHANT_CELL_HEIGHT 130
#define SEARCH_CELL_HEIGHT    50

@class CustomCallOutView;
@interface TLFavouriteListViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,TLFavouriteListingManagerDelegate,TLCategoryListingManagerDelegate>
{
    UIView *contentView,*searchbarView;
    UIImageView *mapIconImgView;
    UITableView *merchantTable;
    UITableView * searchTable;
    MKMapView *mapView;
    UIButton *buttonDiscount;
    UITextField *searchTxt;
    UIRefreshControl *refreshControl;
    UIView *cellContainer;
    UIView *cmtPromptView;
    UILabel *merchantNameLabel;
    UILabel *merchantErrorLabel,*searchErrorLabel;
    NSMutableArray *favouritesArray,*searchArray;//,*categoryArray;
    
    TLMerchantListingModel *merchantListingModel;
    TLFavouriteListingManager *favouriteListingManager;
    
    BOOL isDiscountShown, isMapShown,isSearch;
    BOOL isSearchTableShown;
    CGFloat baseViewWidth, baseViewHeight;
    int adjustHeight;
    int menuSelected,discountTierValue;
    int totalUserListCount,lastFetchCount;
    BOOL isLoadMorePressed,isPullRefreshPressed,isTextFieldClearPressed,isMerchantWebserviceRunning,isKeyBoardOpen;
    
    int adjustViewForIOS7;
    NSString *categoryId;
}

@end
