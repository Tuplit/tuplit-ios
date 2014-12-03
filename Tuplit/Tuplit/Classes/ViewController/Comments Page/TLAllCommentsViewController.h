//
//  AllComments.h
//  Tuplit
//
//  Created by ev_mac8 on 27/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCommentsListingManager.h"
#import "UserCommentsModel.h"

#define COMMENT_CELL_HEIGHT 50

@interface TLAllCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TLCommentsListingManagerDelegate,TLCommentDeleteManagerDelegate>
{
    UITableView *allCommentsTable;
    UIView *baseView;
    
    CGFloat baseViewWidth,baseViewHeight,height;
    NSInteger len;
    
    NSMutableArray *commentsArray;
    
    UIRefreshControl *refreshControl;
    UIView *cellContainer;
//    UIViewController *parentViewController;
    int totalUserListCount,lastFetchCount;
    BOOL isLoadMorePressed,isPullRefreshPressed,isMerchantWebserviceRunning;

}
@property (nonatomic,strong)NSString *userID;
@property (nonatomic,weak)UIViewController *viewController;
@end
