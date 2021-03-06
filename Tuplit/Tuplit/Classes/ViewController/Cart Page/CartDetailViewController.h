//
//  CartAcknowledgementViewController.h
//  Tuplit
//
//  Created by ev_mac8 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

#define CELL_HEIGHT 30

@interface CartDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate>
{
    UITableView *itemsListTable;
    UIImageView *detailImgView;
    UIScrollView *scrollView;
    UIImageView *lineImgView2;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSInteger numberOfCell,tableHeight;
    NSNumberFormatter *numberFormatter;
    NSMutableArray *itemArray;
    UILabel *totalAmtLbl;
    UILabel *vatAmtTotalLbl;
    UILabel * totalAmtTotalLbl;
    
    UILabel *thanksLbl;
    TTTAttributedLabel *linkLbl;
}

@property(nonatomic,strong) NSString *TransactionId;
@property(nonatomic,strong) NSString *OrderId;

@end
