//
//  TLOrderDetailViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLOrderConformViewController.h"
#import "TLOrderListingManager.h"
#import "TLOrderManager.h"
#import "TLPinCodeViewController.h"


#define TRANS_CELL_HEIGHT 52

@interface TLOrderDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TLOrderListingManagerDelegate,TLPinCodeVerifiedDelegate,TLOrderManagerDelegate>
{
    UITableView *itemsListTable;
    UIImageView *detailImgView;
    UIScrollView *scrollView;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSInteger numberOfCell,tableHeight;
    OrderDetailModel *orderdetail;
    
    TLOrderManager *orderManager;
}
@property(nonatomic,strong)NSString *orderID;

@end