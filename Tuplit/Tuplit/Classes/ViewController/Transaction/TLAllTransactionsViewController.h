//
//  AllTransactions.h
//  Tuplit
//
//  Created by ev_mac8 on 11/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTransactionDetailViewController.h"
#import "TLTransactionListingManager.h"
#import "RecentActivityModel.h"

#define TRANS_CELL_HEIGHT 52

@interface TLAllTransactionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TLTransactionListingManagerDelegate>
{
    UIView *baseView;
    CGFloat baseViewHeight,baseViewWidth;
    
    NSMutableArray *merchantNameArray,*transactionDateArray;
    NSMutableArray *numberOfItemArray,*totalAmountArray;
    NSMutableArray *merchantIconArray;
    
    NSMutableArray *transactionList;
    
    UIRefreshControl *refreshControl;
    UIView *cellContainer;
    int totalUserListCount,lastFetchCount;
    BOOL isLoadMorePressed,isPullRefreshPressed,isMerchantWebserviceRunning;
}

@end