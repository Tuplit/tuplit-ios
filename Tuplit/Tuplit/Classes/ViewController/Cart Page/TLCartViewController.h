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

#define CART_CELL_HEIGHT 52

@interface TLCartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,CartSwipeCellProtocol,TLCheckBalanceManagerDelegate,TLCreateOrdersManagerDelegate>
{
    UIView *contentView,*alertView,*checksOutSubView,*debitCreditView;
    UIView *checkoutView,*actionView;
    UITableView *itemsListTable;
    UILabel *discountAmtTotalLbl,*creditBalanceLbl;
    UILabel *alertLbl, *fixedAmtTotalLbl;
    UIScrollView *scrollView;
    UILabel	*swipeLbl ;
    UISlider *swipeSlider;
    UIView *errorView;
    
    NSTimer *animationTimer;
    BOOL touchIsDown;
	int animationTimerCount;
    CGFloat centerX;
    CGFloat baseViewWidth,baseViewHeight;
    NSIndexPath *swipeIndexPath;
    NSInteger numberOfCell,tableHeight;
    NSNumberFormatter *numberFormatter;
    NSMutableArray *itemArray;
}


@end
