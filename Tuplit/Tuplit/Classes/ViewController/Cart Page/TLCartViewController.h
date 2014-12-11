//
//  TLCartViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartSwipeCell.h"
#import "CartDetailViewController.h"
#import "TLCheckBalanceManager.h"
#import "TLCreateOrdersManager.h"
#import "TLCheckLocationManager.h"
#import "CVSwipe.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define CART_CELL_HEIGHT 52

@interface TLCartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,CartSwipeCellProtocol,TLCheckBalanceManagerDelegate,TLCreateOrdersManagerDelegate,TLPinCodeVerifiedDelegate,TLCheckLocationManagerDelegate,CVSwipeProtocol>
{
    UIView *contentView,*alertView,*checksOutSubView,*debitCreditView;
    UIView *checkoutView,*actionView;
    UITableView *itemsListTable;
    UILabel *discountAmtTotalLbl,*creditBalanceLbl;
    UILabel *vatAmtTotalLbl;
    UILabel *totalAmtTotalLbl;
    UILabel *alertLbl, *fixedAmtTotalLbl;
    UIScrollView *scrollView;
    UILabel	*swipeLbl ;
    UISlider *swipeSlider;
    UIView *errorView;
    
    CGFloat centerX;
    CGFloat baseViewWidth,baseViewHeight;
    NSIndexPath *swipeIndexPath;
    NSInteger numberOfCell,tableHeight;
    NSNumberFormatter *numberFormatter;
    NSMutableArray *itemArray;
    
    CVSwipe *cartSwipe;
}

-(void) updateCart;
@property BOOL isMerchant;
@end
