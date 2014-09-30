//
//  TLUserProfileViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLUserProfileViewController.h"

@interface TLUserProfileViewController ()
{
    
}
@end

@implementation TLUserProfileViewController

#pragma mark - View Life Cycle Methods.

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    userProfileTable.editing = NO;
}

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] init];
    [navRightButton buttonWithIcon:getImage(@"edit_icon", NO) target:self action:@selector(editProfileAction) isLeft:NO];
    [self.navigationItem setRightBarButtonItem:navRightButton];
    
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
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        userProfileTable.delaysContentTouches = NO;
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
    
    if (APP_DELEGATE.isUserProfileEdited) {
        APP_DELEGATE.isUserProfileEdited = NO;
        [self callService];
    }
    [self updateUserDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods

//   User details service
-(void)callService
{
    NETWORK_TEST_PROCEDURE
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLUserDetailsManager *usermanager = [[TLUserDetailsManager alloc]init];
    usermanager.delegate = self;
    [usermanager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
    
}

//   Credit card delete service
-(void)callCardDeleteService
{
    
}

-(void)updateUserDetails
{
    UserModel *usermodel = [TLUserDefaults getCurrentUser];
    [self.navigationItem setTitle:[[NSString stringWithFormat:@"%@ %@",usermodel.FirstName,usermodel.LastName]stringWithTitleCase]];
    
    NSArray *recentActivityArray = [[NSArray alloc] init];
    NSArray *commentsArray = [[NSArray alloc] init];
    NSArray *UserLinkedCardsArray = [[NSArray alloc]init];
    
    if(userdeatilmodel.UserLinkedCards.count>0)
    {
        UserLinkedCardsArray = userdeatilmodel.UserLinkedCards;
    }
    if(userdeatilmodel.Orders.count>0)
    {
        recentActivityArray = userdeatilmodel.Orders;
    }
    
    if(userdeatilmodel.comments.count>0)
    {
        commentsArray = userdeatilmodel.comments;
    }
    
    mainDict = @{
                 @"Recent Activity": recentActivityArray,
                 @"My Comments":commentsArray,
                 @"Credit Cards":UserLinkedCardsArray,
                 };
    
    sectionHeader = [NSArray arrayWithObjects:@"User Details",@"Credit Cards",@"Recent Activity",@"My Comments", nil];
    
    [userProfileTable reloadData];
}

- (void) buttonTopUpTransferActions:(UIButton*) button
{
    if (button.tag == 1001)
    {
        
    }
    else
    {
        
    }
}

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath
{
    if ([swipeIndexPath compare:indexPath] != NSOrderedSame)
    {
        UserProfileCell *currentSwipeCell = (UserProfileCell *)[userProfileTable cellForRowAtIndexPath:swipeIndexPath];
        [currentSwipeCell didSwipeLeftInCell:self];
    }
    swipeIndexPath = indexPath;
}

-(void) addCreditCardAction
{
    TLAddCreditCardViewController *addCrCardViewController=[[TLAddCreditCardViewController alloc]init];
    addCrCardViewController.viewController = self;
    [self.navigationController pushViewController:addCrCardViewController animated:YES];
}

-(void) editProfileAction
{
    APP_DELEGATE.isUserProfileEdited = NO;
    
    TLEditProfileViewController * editProfileVC = [[TLEditProfileViewController alloc] init];
    editProfileVC.userDetail = userdeatilmodel;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editProfileVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) topUpAction:(id) sender
{
    TLTopUpViewController *topUp=[[TLTopUpViewController alloc] init];
    topUp.userLinkedCards = userdeatilmodel.UserLinkedCards;
    [self.navigationController pushViewController:topUp animated:YES];
}

-(void) transferAction : (id) sender
{
    TLTransferViewController *transferVC=[[TLTransferViewController alloc] init];
    [self.navigationController pushViewController:transferVC animated:YES];
}

-(void) allTransaction
{
    TLAllTransactionsViewController *allTransViewControl=[[TLAllTransactionsViewController alloc] init];
    allTransViewControl.userID = [TLUserDefaults getCurrentUser].UserId;
    [self.navigationController pushViewController:allTransViewControl animated:YES];
}

-(void)allcomments
{
    TLAllCommentsViewController *allCommentsVC=[[TLAllCommentsViewController alloc] init];
    allCommentsVC.userID = [TLUserDefaults getCurrentUser].UserId;
    [self.navigationController pushViewController:allCommentsVC animated:YES];
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
    else if(section == 1) {
        
        NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:section]];
        if (creditCardArray.count > 0) {
            return creditCardArray.count;
        }
        else
        {
            return 1;
        }
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
        return 173;  // top view height
    }
    if(indexPath.section==3)
    {
        UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        float cmtLblHeight = [comments.CommentsText heigthWithWidth:self.view.frame.size.width-120 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        return cmtLblHeight+25;
    }
    return PROFILE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if(section == 1) {
        
        return HEADER_HEIGHT;
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
    UILabel *leftHeaderNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15,0,150,HEADER_HEIGHT)];
    leftHeaderNameLbl.textColor = UIColorFromRGB(0x00b3a4);
    leftHeaderNameLbl.textAlignment=NSTextAlignmentLeft;
    leftHeaderNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    leftHeaderNameLbl.backgroundColor=[UIColor clearColor];
    leftHeaderNameLbl.text = [sectionHeader objectAtIndex:section];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];//[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftHeaderNameLbl.frame),0,140,HEADER_HEIGHT)];
    headerBtn.frame = CGRectMake(CGRectGetMaxX(leftHeaderNameLbl.frame),0,140,HEADER_HEIGHT);
    headerBtn.backgroundColor = [UIColor clearColor];
    headerBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    headerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    headerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIImage * topUpImage = getImage(@"btn_img", NO);
    UIImage * stretchableTopUpImage = [topUpImage stretchableImageWithLeftCapWidth:9 topCapHeight:0];
    
    [headerBtn setBackgroundImage:stretchableTopUpImage forState:UIControlStateNormal];
    [headerBtn setBackgroundImage:stretchableTopUpImage forState:UIControlStateHighlighted];
    [headerBtn setBackgroundImage:stretchableTopUpImage forState:UIControlStateSelected];
    
    [headerBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    
    if(section == 1)
    {
        [headerBtn setTitle: @"Add Credit Card" forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(addCreditCardAction) forControlEvents:UIControlEventTouchUpInside];
        float btnWidth = [@"Add Credit Card" widthWithFont:headerBtn.titleLabel.font]+2;
        headerBtn.width = btnWidth;
        [headerBtn positionAtX:baseViewWidth-btnWidth-15];
    }
    else if(section == 2)
    {
        if(totalOrders>3)
        {
            [headerBtn setTitle: @"See All" forState:UIControlStateNormal];
            [headerBtn addTarget:self action:@selector(allTransaction) forControlEvents:UIControlEventTouchUpInside];
            float btnWidth = [ @"See All" widthWithFont:headerBtn.titleLabel.font]+2;
            headerBtn.width = btnWidth;
            [headerBtn positionAtX:baseViewWidth-btnWidth-15];
        }
    }
    else if(section == 3)
    {
        if(totalComments >3)
        {
            [headerBtn setTitle: @"See All" forState:UIControlStateNormal];
            [headerBtn addTarget:self action:@selector(allcomments) forControlEvents:UIControlEventTouchUpInside];
            
            float btnWidth = [ @"See All" widthWithFont:headerBtn.titleLabel.font]+2;
            headerBtn.width = btnWidth;
            [headerBtn positionAtX:baseViewWidth-btnWidth-15];
            
        }
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:leftHeaderNameLbl];
    [headerView addSubview:headerBtn];
    [headerView setAutoresizingMask:UIViewAutoresizingNone];
    [tableView addSubview:headerView];
    
    return  headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifire[]={@"UserDetails",@"Credit Cards",@"RecentActivity",@"MyComments",nil};
    
    UserProfileCell *cell = (UserProfileCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire[indexPath.section]];
    
    if (cell == nil)
    {
        cell = [[UserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire[indexPath.section]];
    }
    cell.indexPaths=indexPath;
    cell.delegate=self;
    
    if (indexPath.section == 0)
    {
        EGOImageView *profileImgView=(EGOImageView *) [cell.contentView viewWithTag:4000];
        UILabel *balAmountLbl=(UILabel *) [cell.contentView viewWithTag:4001];
        UILabel *userIDLbl=(UILabel *) [cell.contentView viewWithTag:4002];
        UIButton *topUpBtn=(UIButton *) [cell.contentView viewWithTag:4003];
        UIButton *transferBtn=(UIButton *) [cell.contentView viewWithTag:4004];
        
        UserModel *usermodel = [TLUserDefaults getCurrentUser];
        profileImgView.imageURL = [NSURL URLWithString:usermodel.Photo];
        balAmountLbl.text = [[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:usermodel.AvailableBalance.doubleValue]];
        userIDLbl.text = usermodel.UserId;
        
        [transferBtn addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
        [topUpBtn addTarget:self action:@selector(topUpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.section == 1)
    {
        NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
        
        if (creditCardArray.count > 0) {
            
            CreditCardModel *creditCard = [creditCardArray objectAtIndex:indexPath.row];
            
            EGOImageView *cardImgView=(EGOImageView *) [cell.contentView viewWithTag:1000];
            UILabel *cardNumberLbl=(UILabel *) [cell.contentView viewWithTag:1001];
            UILabel *expiryDateLbl=(UILabel *) [cell.contentView viewWithTag:1002];
            UILabel *noCardLbl = (UILabel *) [cell.contentView viewWithTag:1003];
            
            noCardLbl.hidden  = YES;
            
            NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CARDAMEX];
            NSString *cardNum;
            if ([predicate evaluateWithObject:creditCard.CardNumber])
            {
                cardNum = [TuplitConstants filteredPhoneStringFromString:creditCard.CardNumber withFilter:CARDAMEX];
            }
            else
            {
                cardNum = [TuplitConstants filteredPhoneStringFromString:creditCard.CardNumber withFilter:CARDDEFAULT];
            }
            
            cardImgView.imageURL = [NSURL URLWithString:creditCard.Image];
            cardNumberLbl.text= cardNum;
            expiryDateLbl.text=[TuplitConstants filteredPhoneStringFromString:creditCard.ExpirationDate withFilter:DATEFORMAT];
        }
        else
        {
            EGOImageView *cardImgView=(EGOImageView *) [cell.contentView viewWithTag:1000];
            UILabel *cardNumberLbl=(UILabel *) [cell.contentView viewWithTag:1001];
            UILabel *expiryDateLbl=(UILabel *) [cell.contentView viewWithTag:1002];
            UILabel *noCardLbl = (UILabel *) [cell.contentView viewWithTag:1003];
            
            cardImgView.image = nil;
            cardNumberLbl.text= @"";
            expiryDateLbl.text=@"";
            
            
            noCardLbl.hidden  = NO;
            noCardLbl.text = @"No Credit Cards Added";
        }
    }
    else if (indexPath.section == 2)
    {
        EGOImageView *merchantIconImgView=(EGOImageView *)[cell.contentView viewWithTag:2000];
        UILabel *merchantNameLbl=(UILabel*) [cell.contentView viewWithTag:2001];
        UILabel *numberofItemLbl=(UILabel*) [cell.contentView viewWithTag:2002];
        UILabel *transactionDateLbl=(UILabel*) [cell.contentView viewWithTag:2003];
        UILabel *totalAmountLbl=(UILabel*) [cell.contentView viewWithTag:2004];
        
        RecentActivityModel *recentActivity = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        
        merchantIconImgView.imageURL = [NSURL URLWithString:recentActivity.MerchantIcon];
        merchantNameLbl.text=recentActivity.CompanyName;
        
        if(recentActivity.TotalItems.doubleValue>1)
            numberofItemLbl.text=[NSString stringWithFormat:@"%@ items",recentActivity.TotalItems];
        else
            numberofItemLbl.text=[NSString stringWithFormat:@"%@ item",recentActivity.TotalItems];
        
        transactionDateLbl.text=[TuplitConstants getOrderDate:recentActivity.OrderDate];
        transactionDateLbl.frame = CGRectMake(tableView.frame.size.width-59-12, 10, 59, (PROFILE_CELL_HEIGHT-2)/2 - 8);
        
        totalAmountLbl.text=[NSString stringWithFormat:@"-%@",[[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:recentActivity.TotalPrice.doubleValue]]];
        int totLblWidth = [totalAmountLbl.text widthWithFont:totalAmountLbl.font];
        totalAmountLbl.frame = CGRectMake(tableView.frame.size.width-totLblWidth-15, CGRectGetMaxY(transactionDateLbl.frame), totLblWidth+3, (PROFILE_CELL_HEIGHT-2)/2 -8 );
        
    }
    else if (indexPath.section == 3)
    {
        EGOImageView *merchantIconImgView=(EGOImageView *) [cell.contentView viewWithTag:3000];
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
        return;
    }
    else if (indexPath.section == 2) {
        
        NSArray *transactionList = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
        TLTransactionDetailViewController *transactionDetail=[[TLTransactionDetailViewController alloc] init];
        RecentActivityModel* transaction = [transactionList objectAtIndex:indexPath.row];
        transactionDetail.orderID = transaction.OrderId;
        transactionDetail.transActionList = [transactionList mutableCopy];
        transactionDetail.userID = [TLUserDefaults getCurrentUser].UserId;
        transactionDetail.index = indexPath.row;
        [self.navigationController pushViewController:transactionDetail animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
        if (creditCardArray.count > 0)
            return YES;
        else
            return NO;
    }
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            //            [UIAlertView alertViewWithMessage:@"Deleting a Credit Card is under construction. Will be available in future demos."];
            NETWORK_TEST_PROCEDURE
            
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            
            NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
            
            if (creditCardArray.count > 0) {
                
                CreditCardModel *creditCard = [creditCardArray objectAtIndex:indexPath.row];
                TLCreditCardDeleteManager *cardDeletemanager = [[TLCreditCardDeleteManager alloc]init];
                cardDeletemanager.delegate = self;
                [cardDeletemanager deleteCreditCard:creditCard.Id];
            }
        }
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
    [TLUserDefaults setCurrentUser:user_];
    userdeatilmodel = userDetail_;
    totalOrders = userDetailsManager.totalOrders.intValue;
    totalComments = userDetailsManager.totalComments.intValue;
    [self updateUserDetails];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserData object:nil];
    
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

#pragma  mark - TLCreditCardDeleteManager Delegate Methods

- (void)creditCardDeleteManagerSuccess:(TLCreditCardDeleteManager *)creditCardDeleteManager
{
    [self callService];
}
- (void)creditCardDeleteManager:(TLCreditCardDeleteManager *)creditCardDeleteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)creditCardDeleteManagerFailed:(TLCreditCardDeleteManager *)creditCardDeleteManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end
