//
//  TransactionDetail.h
//  Tuplit
//
//  Created by ev_mac8 on 11/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLOrderListingManager.h"
#import "OrderDetailModel.h"
#import "OrderProductModel.h"
#import "TLTransactionListingManager.h"
#define CELL_HEIGHT 30

@interface TLTransactionDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TLOrderListingManagerDelegate,TLTransactionListingManagerDelegate>
{
    UITableView *itemsListTable;
    UIImageView *detailImgView;
    UIScrollView *scrollView;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSInteger numberOfCell,tableHeight;
    OrderDetailModel *orderdetail;
    
}
@property(nonatomic,retain)NSString *orderID;
@property(nonatomic,strong)NSMutableArray *transActionList;
@property (nonatomic,strong)NSString *userID;
@property int index;

@end
