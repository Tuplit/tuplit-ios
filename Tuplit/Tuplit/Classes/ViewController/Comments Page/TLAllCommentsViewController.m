//
//  AllComments.m
//  Tuplit
//
//  Created by ev_mac8 on 27/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAllCommentsViewController.h"

@interface TLAllCommentsViewController ()
{
    TLCommentsListingManager *commentsManager;
    int deletedCmtIndex;
}

@end

@implementation TLAllCommentsViewController

#pragma mark - View Life Cycle Methods.

-(void)dealloc
{
    commentsManager.delegate = nil;
    commentsManager = nil;
}

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"ALL_COMMENTS")];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"BackArrow", NO) target:self action:@selector(backToUserProfile) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];    
    
    baseViewWidth = self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
   
    int adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight-adjustHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    allCommentsTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight-adjustHeight)];
   
    allCommentsTable.delegate=self;
    allCommentsTable.dataSource=self;
    allCommentsTable.backgroundColor=[UIColor clearColor];
    [allCommentsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [baseView addSubview:allCommentsTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [allCommentsTable addSubview:refreshControl];
    
    cellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,allCommentsTable.frame.size.width, 64)];
    [cellContainer setBackgroundColor:[UIColor clearColor]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cellContainer.frame.size.width - 30)/2, (cellContainer.frame.size.height - 30)/2, 30, 30)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [cellContainer addSubview:activity];
    
    commentsArray = [[NSMutableArray alloc] init];
    [self callCommentWebserviceWithstartCount:0 showProgress:YES];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - User Defined Methods

//-(void)callWebService
//{
//    NETWORK_TEST_PROCEDURE
//    
//    commentsManager = [[TLCommentsListingManager alloc]init];
//    commentsManager.delegate = self;
//    [commentsManager callService:[TLUserDefaults getCurrentUser].UserId withIDType:1];
//}

-(void) callCommentWebserviceWithstartCount:(long) start showProgress:(BOOL)showProgressIndicator
{
    
    NETWORK_TEST_PROCEDURE
    
    if (isMerchantWebserviceRunning) {
        return;
    }
    
    isMerchantWebserviceRunning = YES;

    if (showProgressIndicator) {
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    }
    if (commentsManager==nil) {
         commentsManager = [[TLCommentsListingManager alloc]init];
    }
   
    commentsManager.delegate = self;
    [commentsManager callService:self.userID withStartCount:start];
}
-(void)backToUserProfile
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    [self callCommentWebserviceWithstartCount:0 showProgress:NO];
}

-(void) loadMoreComments {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self callCommentWebserviceWithstartCount:lastFetchCount showProgress:NO];
    }
}


#pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCommentsModel *comments = [commentsArray objectAtIndex:indexPath.row];
    float cmtLblHeight = [comments.CommentsText heigthWithWidth:self.view.frame.size.width-120 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
    return cmtLblHeight+25;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellID";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *cellBaseview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        cellBaseview.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cellBaseview];
        
        EGOImageView *merchantIconImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(15, 10,30,30)];
        merchantIconImgView.tag=1000;
        merchantIconImgView.layer.cornerRadius =15;
        [cellBaseview addSubview:merchantIconImgView];
        
        UILabel *merchantNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(55,4,cellBaseview.frame.size.width-120, 20)];
        merchantNameLbl.textColor=UIColorFromRGB(0x333333);
        merchantNameLbl.tag=1001;
        merchantNameLbl.textAlignment=NSTextAlignmentLeft;
        merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        merchantNameLbl.backgroundColor=[UIColor clearColor];
        [cellBaseview addSubview:merchantNameLbl];
        
        UILabel *commentLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(merchantNameLbl.frame),CGRectGetMaxY(merchantNameLbl.frame), CGRectGetWidth(merchantNameLbl.frame), (cellBaseview.frame.size.height-2)/2-8)];
        commentLbl.tag=1002;
        commentLbl.textColor=UIColorFromRGB(0x333333);
        commentLbl.textAlignment=NSTextAlignmentLeft;
        commentLbl.numberOfLines = 0;
        commentLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
        commentLbl.backgroundColor=[UIColor clearColor];
        [cellBaseview addSubview:commentLbl];
        
        UILabel * totalDaysLbl=[[UILabel alloc] initWithFrame:CGRectMake(cellBaseview.frame.size.width-46,15, 30, 20)];
        totalDaysLbl.textColor=UIColorFromRGB(0x808080);
        totalDaysLbl.tag=1003;
        totalDaysLbl.textAlignment=NSTextAlignmentRight;
        totalDaysLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
        totalDaysLbl.backgroundColor=[UIColor clearColor];
        [cellBaseview addSubview:totalDaysLbl];
    }
    
    EGOImageView *merchantIconImgView=(EGOImageView *) [cell.contentView viewWithTag:1000];
    UILabel *merchantNameLbl=(UILabel *) [cell.contentView viewWithTag:1001];
    UILabel *commentLbl=(UILabel *) [cell.contentView viewWithTag:1002];
    UILabel *totalDaysLbl=(UILabel *) [cell.contentView viewWithTag:1003];
    
    UserCommentsModel *comments = [commentsArray objectAtIndex:indexPath.row];
    merchantIconImgView.imageURL = [NSURL URLWithString:comments.MerchantIcon];
    merchantNameLbl.text=comments.MerchantName;
    
    commentLbl.text = comments.CommentsText;
    float cmtLblHeight = [commentLbl.text heigthWithWidth:commentLbl.frame.size.width andFont:commentLbl.font];
    CGRect newRect = commentLbl.frame;
    newRect.size.height = cmtLblHeight;
    commentLbl.frame = newRect;
    
    totalDaysLbl.text=[TuplitConstants calculateTimeDifference:comments.CommentDate];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isOtherUser)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isOtherUser)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            NETWORK_TEST_PROCEDURE
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            deletedCmtIndex =indexPath.row;
            UserCommentsModel *comments = [commentsArray objectAtIndex:deletedCmtIndex];
            TLCommentDeleteManager *commentManager = [[TLCommentDeleteManager alloc]init];
            [commentManager setDelegate:self];
            [commentManager deleteComment:comments.CommentId];
            [self.view endEditing:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    
    if (offset >= 0.0 && offset <= 50.0) {
        
        [self loadMoreComments];
    }
}


#pragma mark - TLCommentsListingManagerDelegate
- (void)commentsListingManagerSuccess:(TLCommentsListingManager *)commentsListingManager withcommentsList:(NSArray*) _commentsList
{
    if (isLoadMorePressed) {

        [commentsArray addObjectsFromArray:_commentsList];
    }
    else
    {
        commentsArray = [NSMutableArray arrayWithArray:_commentsList];
        lastFetchCount = 0;
    }
    
    totalUserListCount = commentsListingManager.totalCount;
    
    if ((commentsListingManager.listedCount % 20) == 0) {
        lastFetchCount = lastFetchCount + commentsListingManager.listedCount;
    }
    else
    {
        lastFetchCount = commentsArray.count;
    }

       [allCommentsTable reloadData];
    
    if (lastFetchCount < totalUserListCount)
        [allCommentsTable setTableFooterView:cellContainer];
    else
        [allCommentsTable setTableFooterView:nil];
    
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)commentsListingManager:(TLCommentsListingManager *)commentsListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [commentsArray removeAllObjects];
    [allCommentsTable reloadData];
    isMerchantWebserviceRunning =NO;
    
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)commentsListingManagerFailed:(TLCommentsListingManager *)commentsListingManager
{
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}

#pragma  mark - TLCommentDeleteManager Delegate Methods

- (void)commentDeleteManagerSuccess:(TLCommentDeleteManager *)loginManager
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [commentsArray removeObjectAtIndex:deletedCmtIndex];
    [allCommentsTable reloadData];
    [[ProgressHud shared] hide];
}
- (void)commentDeleteManager:(TLCommentDeleteManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)commentDeleteManagerFailed:(TLCommentDeleteManager *)loginManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}
@end
