//
//  TLOtherUserProfileViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 09/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLOtherUserProfileViewController.h"

@interface TLOtherUserProfileViewController ()

@end

@implementation TLOtherUserProfileViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    if(self.isLeftMenu)
    {
        [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
    }
    else
    {
        [navleftButton buttonWithIcon:getImage(@"BackArrow", NO) target:self action:@selector(backToFriends) isLeft:NO];
    }
    
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    baseViewWidth= self.view.frame.size.width;
    baseViewHeight= self.view.frame.size.height;
    
    int adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    //  Content part
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,baseViewHeight - adjustHeight)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    userProfileTable = [[UITableView alloc] initWithFrame:baseView.bounds];
    [userProfileTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    userProfileTable.dataSource = self;
    userProfileTable.delegate = self;
    userProfileTable.backgroundColor = [UIColor clearColor];
    userProfileTable.tag = 1003;
    userProfileTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userProfileTable.frame.size.width, 20)];
    [baseView addSubview:userProfileTable];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callService];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User Defined Methods

-(void)callService
{
    NETWORK_TEST_PROCEDURE
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLUserDetailsManager *usermanager = [[TLUserDetailsManager alloc]init];
    usermanager.delegate = self;
    [usermanager getUserDetailsWithUserID:self.userID];
    
}
-(void)reloadOtherUserprofile
{
    [userProfileTable setContentOffset:CGPointZero animated:YES];
    [self callService];
}

-(void)updateUserDetails
{
    [self.navigationItem setTitle:[[NSString stringWithFormat:@"%@ %@",userModel.FirstName,userModel.LastName]stringWithTitleCase]];
    
    NSArray *recentActivityArray = [[NSArray alloc] init];
    NSArray *commentsArray = [[NSArray alloc] init];

    if(userdeatilmodel.Orders.count>0)
    {
        recentActivityArray = userdeatilmodel.Orders;
    }

    if(userdeatilmodel.comments.count>0)
    {
        commentsArray = userdeatilmodel.comments;
    }

    mainDict = @{
                 @"Recently Shopped...": recentActivityArray,
                 @"Comments":commentsArray,
                 };
    
    sectionHeader = [NSArray arrayWithObjects:@"User Details",@"Recently Shopped...",@"Comments", nil];
    
    [userProfileTable reloadData];
}


-(void) backToFriends
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) transferAction : (id) sender
{
    TLTransferViewController *transferVC=[[TLTransferViewController alloc] init];
    transferVC.userID = userModel.UserId;
    transferVC.UserName = [NSString stringWithFormat:@"%@ %@", userModel.FirstName,userModel.LastName];
    [self.navigationController pushViewController:transferVC animated:YES];
}
-(void) allTransaction
{
    TLAllTransactionsViewController *allTransViewControl=[[TLAllTransactionsViewController alloc] init];
    allTransViewControl.userID = userModel.UserId;
    [self.navigationController pushViewController:allTransViewControl animated:YES];
}

-(void)allcomments
{
    TLAllCommentsViewController *allCommentsVC=[[TLAllCommentsViewController alloc] init];
    allCommentsVC.userID = userModel.UserId;
    allCommentsVC.viewController = self;
    [self.navigationController pushViewController:allCommentsVC animated:YES];
}

-(void)addFriend
{
    NSLog(@"AddFriend Action");
    
    NETWORK_TEST_PROCEDURE
//    NSDictionary *queryParams = @{
//                 @"userID": NSNonNilString(self.userID),
//                 };
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    TLAddFriendManager *addFriendManager = [[TLAddFriendManager alloc]init];
    addFriendManager.delegate = self;
    [addFriendManager callService:self.userID];
    
}
-(void)openMerchantDetails:(UITapGestureRecognizer *)gesture
{
    EGOImageView *imgView = (EGOImageView*)gesture.view;
    
    CGPoint buttonPosition = [imgView convertPoint:CGPointZero toView:userProfileTable];
    NSIndexPath *indexPath = [userProfileTable indexPathForRowAtPoint:buttonPosition];
    
    UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    
    TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
    detailsVC.detailsMerchantID = comments.merchantId;
    detailsVC.viewController = self;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionHeader count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [[mainDict valueForKey:[sectionHeader objectAtIndex:section]]count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        if(userModel.IsFriend.intValue == 1)
            return 173;  // top view height
//        else
//            return 173 - 50;
    }
    if(indexPath.section==2)
    {
        UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        float cmtLblHeight = [comments.CommentsText heigthWithWidth:self.view.frame.size.width-120 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        return cmtLblHeight + 25;
    }
    return PROFILE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if([[mainDict valueForKey:[sectionHeader objectAtIndex:section]]count] > 0)
            return HEADER_HEIGHT;
        else
            return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *leftHeaderNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15,0,190,HEADER_HEIGHT)];
    leftHeaderNameLbl.textColor = UIColorFromRGB(0x00b3a4);
    leftHeaderNameLbl.textAlignment=NSTextAlignmentLeft;
    leftHeaderNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    leftHeaderNameLbl.backgroundColor=[UIColor clearColor];
    leftHeaderNameLbl.text = [sectionHeader objectAtIndex:section];
    
    UILabel *rightHeaderNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftHeaderNameLbl.frame),0,100,HEADER_HEIGHT)];
    rightHeaderNameLbl.textColor = UIColorFromRGB(0x999999);
    rightHeaderNameLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    rightHeaderNameLbl.textAlignment = NSTextAlignmentRight;
    rightHeaderNameLbl.userInteractionEnabled=YES;
    rightHeaderNameLbl.backgroundColor=[UIColor clearColor];
    
    if(section == 1)
    {
        if(totalOrders>3)
        {
            rightHeaderNameLbl.text = @"See All" ;// LString(@"SEE_ALL");
            
            UITapGestureRecognizer *allTransactionTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTransaction)];
            [rightHeaderNameLbl addGestureRecognizer:allTransactionTap];
        }
    }
    else if(section == 2)
    {
        if(totalComments >3)
        {
            rightHeaderNameLbl.text = @"See All"; // LString(@"SEE_ALL");    }
            UITapGestureRecognizer *allTransactionTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allcomments)];
            [rightHeaderNameLbl addGestureRecognizer:allTransactionTap];
        }
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:leftHeaderNameLbl];
    [headerView addSubview:rightHeaderNameLbl];
    [tableView addSubview:headerView];
    
    return  headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifire[]={@"OtherUserDetails",@"RecentShopped",@"MyComments",nil};
    
    UserProfileCell *cell = (UserProfileCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire[indexPath.section]];
    
    if (cell == nil)
    {
        cell = [[UserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire[indexPath.section]];
        if(indexPath.section == 1)
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.indexPaths=indexPath;
    cell.delegate=self;
    
    if (indexPath.section == 0)
    {
        EGOImageView *profileImgView=(EGOImageView *) [cell.contentView viewWithTag:5000];
        UILabel *userIDLbl=(UILabel *) [cell.contentView viewWithTag:5001];
        UIButton *sendCreditBtn=(UIButton *) [cell.contentView viewWithTag:5002];
        
        if(userModel.IsFriend.intValue == 1)
        {
//            [sendCreditBtn setHidden:NO];
            [sendCreditBtn addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
            [sendCreditBtn setTitle:[NSString stringWithFormat:@"Send credit to %@",[userModel.FirstName stringWithTitleCase]] forState:UIControlStateNormal];
        }
        else
        {
//            [sendCreditBtn setHidden:YES];
            [sendCreditBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
            [sendCreditBtn setTitle:@"Add Friend" forState:UIControlStateNormal];
        }
        
        profileImgView.imageURL = [NSURL URLWithString:userModel.Photo];
        userIDLbl.text = userModel.UserId;
    }
    else if (indexPath.section == 1)
    {
        EGOImageView *merchantIconImgView=(EGOImageView *)[cell.contentView viewWithTag:2000];
        UILabel *merchantNameLbl=(UILabel*) [cell.contentView viewWithTag:2001];
        //        UILabel *numberofItemLbl=(UILabel*) [cell.contentView viewWithTag:2002];
        UILabel *transactionDateLbl=(UILabel*) [cell.contentView viewWithTag:2003];
        //        UILabel *totalAmountLbl=(UILabel*) [cell.contentView viewWithTag:2004];
        
        RecentActivityModel *recentActivity = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        
        merchantIconImgView.imageURL = [NSURL URLWithString:recentActivity.MerchantIcon];
        merchantNameLbl.text=recentActivity.CompanyName;
        
        transactionDateLbl.text=[TuplitConstants getOrderDate:recentActivity.OrderDate];
        transactionDateLbl.frame = CGRectMake(tableView.frame.size.width-59-12, 0, 59,PROFILE_CELL_HEIGHT-2);
        
    }
    else if (indexPath.section == 2)
    {
        EGOImageView *merchantIconImgView=(EGOImageView *) [cell.contentView viewWithTag:3000];
        UITapGestureRecognizer *friendsImgGesture1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMerchantDetails:)];
        [merchantIconImgView addGestureRecognizer:friendsImgGesture1];
        UILabel *merchantNameLbl=(UILabel *) [cell.contentView viewWithTag:3001];
        UILabel *commentLbl=(UILabel *) [cell.contentView viewWithTag:3002];
        UILabel *totalDaysLbl=(UILabel *) [cell.contentView viewWithTag:3003];
        
        UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        merchantIconImgView.imageURL = [NSURL URLWithString:comments.MerchantIcon];
        merchantNameLbl.text=comments.MerchantName;
        
        commentLbl.text = comments.CommentsText;
        float cmtLblHeight = [commentLbl.text heigthWithWidth:commentLbl.frame.size.width andFont:commentLbl.font];
        CGRect newRect = commentLbl.frame;
        newRect.size.height = cmtLblHeight;
        commentLbl.frame = newRect;
        
        totalDaysLbl.text=[TuplitConstants calculateTimeDifference:comments.CommentDate];
        int timeLblWidth = [totalDaysLbl.text widthWithFont:totalDaysLbl.font]+1;
        totalDaysLbl.frame =  CGRectMake(cell.frame.size.width-timeLblWidth-16,15, timeLblWidth, 20);
        
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        NSArray *transactionList = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
        TLTransactionDetailViewController *transactionDetail=[[TLTransactionDetailViewController alloc] init];
        RecentActivityModel* transaction = [transactionList objectAtIndex:indexPath.row];
        transactionDetail.orderID = transaction.OrderId;
        transactionDetail.transActionList = [transactionList mutableCopy];
        transactionDetail.userID = [TLUserDefaults getCurrentUser].UserId;
        transactionDetail.index = (int)indexPath.row;
        [userProfileTable deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:transactionDetail animated:YES];
    }
}


#pragma mark - Scroll View Delegate Methods

// Change Default Scrolling Behavior of TableView Section
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    CGFloat sectionHeaderHeight = HEADER_HEIGHT;
    if (_scrollView.contentOffset.y<=sectionHeaderHeight&&_scrollView.contentOffset.y>=0) {
        _scrollView.contentInset = UIEdgeInsetsMake(-_scrollView.contentOffset.y, 0, 0, 0);
    } else if (_scrollView.contentOffset.y>=sectionHeaderHeight) {
        _scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma  mark - TLUserDetailManager Delegate Methods
- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel *)userDetail_
{
    userModel = user_;
    userdeatilmodel = userDetail_;
    totalOrders = userDetailsManager.totalOrders.intValue;
    totalComments = userDetailsManager.totalComments.intValue;
    [self updateUserDetails];
    
    [[ProgressHud shared] hide];
}
- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma  mark - TLAddFriendManager Delegate Methods
- (void)addFriendManagerSuccessfull:(TLAddFriendManager *) addFriendManager
{
    UserModel *tempUsermodal = [UserModel new];
    tempUsermodal = userModel;
    tempUsermodal.IsFriend = @"1";
    userModel = tempUsermodal;
    [userProfileTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateFriendsActivity object:nil];
    [[ProgressHud shared] hide];
}
- (void)addFriendManager:(TLAddFriendManager *) addFriendManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)addFriendManagerFailed:(TLAddFriendManager *) addFriendManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end
