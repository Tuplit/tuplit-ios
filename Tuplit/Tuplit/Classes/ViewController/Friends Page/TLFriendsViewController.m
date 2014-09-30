//
//  TLFriendsViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLFriendsViewController.h"
#import "NSArray+BlocksKit.h"
#define INVITEBTN_Y_POS 20

@interface TLFriendsViewController ()
{
    UITextField *searchTxt;
    UIButton *inviteFriendsBtn;
    BOOL isSearchShown;
    int adjustHeight;
    
    UILabel *errorLbl;
    UIView *errorView;
    
    TLFriendsListingManager *friendsManager;
}

@end

@implementation TLFriendsViewController


#pragma mark - View Life Cycle Methods.

- (void)dealloc
{
    friendsManager.delegate = nil;
    friendsManager = nil;
}

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setTitle:LString(@"FRIENDS")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] init];
    [navRightButton buttonWithIcon:getImage(@"fsearch", NO) target:self action:@selector(searchAction) isLeft:NO];
    [self.navigationItem setRightBarButtonItem:navRightButton];
    
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    //SearchBar View
    searchbarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseView.frame.size.width,40)];
    searchbarView.backgroundColor = [UIColor whiteColor];
    searchbarView.hidden = YES;
    [baseView addSubview:searchbarView];
    
    searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, searchbarView.frame.size.width - 10, searchbarView.frame.size.height)];
    searchTxt.delegate = self;
    searchTxt.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    searchTxt.textColor = UIColorFromRGB(0xb2b2b2);
    searchTxt.backgroundColor = [UIColor clearColor];
    searchTxt.placeholder = @"Search";
    [searchTxt addTarget:self action:@selector(searchTxtAction) forControlEvents:UIControlEventEditingChanged];
    searchTxt.textAlignment = NSTextAlignmentLeft;
    searchTxt.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [searchTxt setReturnKeyType:UIReturnKeySearch];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, searchbarView.frame.size.height, searchbarView.frame.size.width, 1)];
    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    [searchbarView addSubview:lineView2];
    
    if ([searchTxt respondsToSelector:@selector(tintColor)]) // Check for property before calling because calling it crashes the app on iOS6
    {
        searchTxt.tintColor = UIColorFromRGB(0x01b3a5);
    }
    searchTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTxt.userInteractionEnabled = YES;
    [searchbarView addSubview:searchTxt];
    
    UIImage *searchImg = [UIImage imageNamed:@"search.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, searchImg.size.width + 20, searchImg.size.height)];
    [searchImgView setContentMode:UIViewContentModeScaleAspectFit];
    searchImgView.image = searchImg;
    [searchTxt setLeftView:searchImgView];
    [searchTxt setLeftViewMode:UITextFieldViewModeAlways];
    
    inviteFriendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteFriendsBtn.frame=CGRectMake(15, INVITEBTN_Y_POS,290,45);
    [inviteFriendsBtn setTitle:LString(@"INVITE_FRIENDS") forState:UIControlStateNormal];
    inviteFriendsBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [inviteFriendsBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    inviteFriendsBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    [inviteFriendsBtn addTarget:self action:@selector(inviteFriendsAction:) forControlEvents:UIControlEventTouchUpInside];
    [inviteFriendsBtn setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
    [baseView addSubview:inviteFriendsBtn];
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    friendsTable=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(inviteFriendsBtn.frame) + 18,baseViewWidth, baseViewHeight-CGRectGetMaxY(inviteFriendsBtn.frame) - adjustHeight - 18) style:UITableViewStylePlain];
    friendsTable.delegate=self;
    friendsTable.dataSource=self;
    friendsTable.backgroundColor=[UIColor whiteColor];
    friendsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [baseView addSubview:friendsTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [friendsTable addSubview:refreshControl];
    
    cellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,friendsTable.frame.size.width, 64)];
    [cellContainer setBackgroundColor:[UIColor clearColor]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cellContainer.frame.size.width - 30)/2, (cellContainer.frame.size.height - 30)/2, 30, 30)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [cellContainer addSubview:activity];
    
    errorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(inviteFriendsBtn.frame) + 18, baseViewWidth,baseViewHeight-CGRectGetMaxY(inviteFriendsBtn.frame) - adjustHeight - 18)];
    [errorView setBackgroundColor:[UIColor whiteColor]];
    [baseView addSubview:errorView];
    
    errorLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100)];
    [errorLbl setTextAlignment:NSTextAlignmentCenter];
    [errorLbl setTextColor:[UIColor lightGrayColor]];
    errorLbl.numberOfLines = 0;
    [errorView addSubview:errorLbl];
    
    isSearchShown = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callFriendslistWebserviceWithstartCount:0 showProgress:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - User Defined Methods

-(void) inviteFriendsAction :(UIButton *) sender
{
    TLInviteFriendsViewController *inviteFriendsViewController=[[TLInviteFriendsViewController alloc] init];
    [self.navigationController pushViewController:inviteFriendsViewController animated:YES];
}

-(void) callFriendslistWebserviceWithstartCount:(long) start showProgress:(BOOL)showProgressIndicator
{
    
    NETWORK_TEST_PROCEDURE
    
    //    if (isFriendsWebserviceRunning) {
    //        return;
    //    }
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    
//    dispatch_async(queue, ^{
    
        isFriendsWebserviceRunning = YES;
        
        if (showProgressIndicator) {
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        }
        if (friendsManager==nil) {
            friendsManager = [[TLFriendsListingManager alloc]init];
        }
        
        NSString *searchText;
        if(searchbarView.hidden)
            searchText = @"";
        else
            searchText = searchTxt.text;
        
        NSDictionary *queryParams = @{
                                      @"Search"            :  NSNonNilString(searchText),
                                      @"Start"             :  NSNonNilString([NSString stringWithFormat:@"%ld",start]),
                                      };
        
        friendsManager.delegate = self;
        [friendsManager cancelRequest];
        [friendsManager callService:queryParams];
//    });
}
-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    [self callFriendslistWebserviceWithstartCount:0 showProgress:NO];
}

-(void) loadMoreFriends {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self callFriendslistWebserviceWithstartCount:lastFetchCount showProgress:NO];
    }
}

-(void)searchTxtAction
{
    if (searchTxt.text.length == 0)
    {
        [self callFriendslistWebserviceWithstartCount:0 showProgress:NO];
    }
}

-(void)searchAction
{
    
    [UIView animateWithDuration:0.35 animations:^{
        
        if(!isSearchShown)
        {
            isSearchShown = YES;
            
//            inviteFriendsBtn.hidden = YES;
            searchbarView.hidden = NO;
            [inviteFriendsBtn positionAtY:CGRectGetMaxY(searchbarView.frame)+10];
            
            friendsTable.frame = CGRectMake(0,CGRectGetMaxY(inviteFriendsBtn.frame)+1,baseViewWidth, baseViewHeight-CGRectGetMaxY(inviteFriendsBtn.frame) - adjustHeight - 11);
            errorView.frame = friendsTable.frame;
            errorLbl.frame = CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100);
        }
        else
        {
            if(searchTxt.isFirstResponder)
                [searchTxt resignFirstResponder];
            else
            {
                isSearchShown = NO;
                //            inviteFriendsBtn.hidden = NO;
                searchbarView.hidden = YES;
                
                [inviteFriendsBtn positionAtY:INVITEBTN_Y_POS];
                
                friendsTable.frame =  CGRectMake(0,CGRectGetMaxY(inviteFriendsBtn.frame) + 18,baseViewWidth, baseViewHeight-CGRectGetMaxY(inviteFriendsBtn.frame) - adjustHeight - 18);
                errorView.frame = friendsTable.frame;
                errorLbl.frame = CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100);
            }
            
             searchTxt.text = @"";
        }
        
    }];
}

#pragma mark - TextFieldButtonDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.35 animations:^{
        friendsTable.frame = CGRectMake(0,CGRectGetMaxY(inviteFriendsBtn.frame)+1,baseViewWidth, baseViewHeight-adjustHeight-CGRectGetMaxY(inviteFriendsBtn.frame)-216) ;
        errorView.frame = friendsTable.frame;
        errorLbl.frame = CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.35 animations:^{
        if(isSearchShown)
        {
            friendsTable.frame =  CGRectMake(0,CGRectGetMaxY(inviteFriendsBtn.frame) + 18,baseViewWidth, baseViewHeight-CGRectGetMaxY(inviteFriendsBtn.frame) - adjustHeight - 18);
            errorView.frame = friendsTable.frame;
            errorLbl.frame = CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100);
        }
        
    }];
    [self searchTxtAction] ;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [searchTxt resignFirstResponder];
//    isSearchShown = NO;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString* searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    searchTxt.text = searchString;
    if (searchString.length >= 3)
        [self callFriendslistWebserviceWithstartCount:0 showProgress:NO];
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    
    if (offset >= 0.0 && offset <= 50.0) {
        
        [self loadMoreFriends];
    }
}

#pragma mark - Table View Delegate Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendsArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FRIENDS_CEL_HEIGHT;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListModel *friend = [friendsArray objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier=@"CellWithComName";
    if(friend.CompanyName.length==0)
        cellIdentifier=@"CellWithoutComName";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        
        EGOImageView *profileImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(16, 2, 45, FRIENDS_CEL_HEIGHT -1 -5 )];
        profileImgView.backgroundColor = [UIColor whiteColor];
        profileImgView.layer.cornerRadius=45/2;
        //        profileImgView.userInteractionEnabled=YES;
        profileImgView.clipsToBounds=YES;
        profileImgView.tag=1000;
        [cell.contentView addSubview:profileImgView];
        
        UIImageView *fbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(profileImgView.frame)-10, CGRectGetHeight(profileImgView.frame)-10, 10, 10)];
        fbImageView.backgroundColor = [UIColor redColor];
        fbImageView.layer.cornerRadius=10/2;
        [profileImgView addSubview:fbImageView];
        
        UILabel *profileNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) +75 ,5, baseViewWidth-CGRectGetMaxX(profileImgView.frame)-75-10,(FRIENDS_CEL_HEIGHT-1)/2)];
        profileNameLbl.textColor=UIColorFromRGB(0x333333);
        profileNameLbl.numberOfLines=0;
        profileNameLbl.tag=1001;
        profileNameLbl.textAlignment=NSTextAlignmentLeft;
        profileNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        profileNameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:profileNameLbl];
        
        UILabel *companyNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) + 75 ,CGRectGetMaxY(profileNameLbl.frame), baseViewWidth-CGRectGetMaxX(profileImgView.frame)-75-10,(FRIENDS_CEL_HEIGHT-1)/2 -10)];
        companyNameLbl.textColor=UIColorFromRGB(0x333333);
        companyNameLbl.numberOfLines=0;
        companyNameLbl.tag=1002;
        companyNameLbl.textAlignment=NSTextAlignmentLeft;
        companyNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        companyNameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:companyNameLbl];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(companyNameLbl.frame) + 5, baseViewWidth - 75, 1)];
        lineView.backgroundColor=UIColorFromRGB(0xCCCCCC);
        [cell.contentView addSubview:lineView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    EGOImageView *profileImgView=(EGOImageView *)[cell.contentView viewWithTag:1000];
    UILabel *profileNameLbl=(UILabel *)[cell.contentView viewWithTag:1001];
    UILabel *companyNameLbl=(UILabel *)[cell.contentView viewWithTag:1002];
    
    profileImgView.imageURL = [NSURL URLWithString:friend.Photo];
    profileNameLbl.text=[[NSString stringWithFormat:@"%@ %@",friend.FirstName,friend.LastName]stringWithTitleCase];
    
    if([cellIdentifier isEqualToString:@"CellWithoutComName"])
        profileNameLbl.height = cell.contentView.frame.size.height-10;
    else
        companyNameLbl.text=friend.CompanyName;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DISMISS_KEYBOARD;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendsListModel *friend  = [friendsArray objectAtIndex:indexPath.row];
    TLOtherUserProfileViewController *otherUserProfile = [[TLOtherUserProfileViewController alloc]init];
    otherUserProfile.userID = friend.Id;
    [self.navigationController pushViewController:otherUserProfile animated:YES];
}
#pragma mark - TLFriendsListingManager

- (void)friendsListingManagerSuccess:(TLFriendsListingManager *)friendsListingManager withFriendsListingManager:(NSArray*) _friendsList
{
    errorView.hidden = YES;
    if (isLoadMorePressed) {
        
        [friendsArray addObjectsFromArray:_friendsList];
    }
    else
    {
        friendsArray = [NSMutableArray arrayWithArray:_friendsList];
        lastFetchCount = 0;
    }
    
    totalUserListCount = friendsListingManager.totalCount;
    
    if ((friendsListingManager.listedCount % 20) == 0) {
        lastFetchCount = lastFetchCount + friendsListingManager.listedCount;
    }
    else
    {
        lastFetchCount = friendsArray.count;
    }
    
    [friendsTable reloadData];
    
    if (lastFetchCount < totalUserListCount)
        [friendsTable setTableFooterView:cellContainer];
    else
        [friendsTable setTableFooterView:nil];
    
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isFriendsWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)friendsListingManager:(TLFriendsListingManager *)friendsListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    errorView.hidden = NO;
    errorLbl.text = LString(@"NO_FRIEND_FOUND");
    
    [friendsTable setTableFooterView:nil];
    
    [friendsArray removeAllObjects];
    [friendsTable reloadData];
    isFriendsWebserviceRunning =NO;
    
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)friendsListingManagerFailed:(TLFriendsListingManager *)friendsListingManager
{
    errorView.hidden = NO;
    errorLbl.text = LString(@"SERVER_CONNECTION_ERROR");
    
    [friendsTable setTableFooterView:nil];
    
    isFriendsWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
    
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end
