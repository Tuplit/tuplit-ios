//
//  AllTransactions.m
//  Tuplit
//
//  Created by ev_mac8 on 11/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAllTransactionsViewController.h"
#import "RecentActivityModel.h"

@interface TLAllTransactionsViewController ()
{
    UITableView *allTransactionTableView;
    TLTransactionListingManager *transactionManager;
}

@end

@implementation TLAllTransactionsViewController

#pragma mark - View Life Cycle Methods.

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"ALL_TRANSACTION")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] initWithImage:getImage(@"BackArrow", NO) style:UIBarButtonItemStylePlain target:self action:@selector(backToUserProfile)];
    [self.navigationItem setLeftBarButtonItem:navleftButton];    
    
    baseViewWidth = self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    allTransactionTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight-65)];
    allTransactionTableView.delegate=self;
    allTransactionTableView.dataSource=self;
    allTransactionTableView.backgroundColor=[UIColor clearColor];
    allTransactionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [baseView addSubview:allTransactionTableView];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [allTransactionTableView addSubview:refreshControl];
    
    cellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,allTransactionTableView.frame.size.width, 64)];
    [cellContainer setBackgroundColor:[UIColor clearColor]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cellContainer.frame.size.width - 30)/2, (cellContainer.frame.size.height - 30)/2, 30, 30)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [cellContainer addSubview:activity];
    
    merchantIconArray=[NSMutableArray arrayWithObjects:@"burgerking.png",@"McDonalds.png",@"burgerking.png",@"burgerking.png",@"McDonalds.png",@"burgerking.png",@"burgerking.png",@"McDonalds.png",@"McDonalds.png",@"burgerking.png",@"burgerking.png",@"McDonalds.png", nil];
    
     merchantNameArray=[NSMutableArray arrayWithObjects:@"Burger King New York",@"McDonald's Barcelona",@"Burger King New York",@"Burger King New York",@"McDonald's Barcelona",@"Burger King New York",@"McDonald's Barcelona",@"Burger King New York",@"McDonald's Barcelona",@"Burger King New York",@"McDonald's Barcelona",@"Burger King New York", nil];
    
     transactionDateArray=[NSMutableArray arrayWithObjects:@"06/10/2014",@"05/10/2014",@"06/10/2014",@"06/10/2014",@"05/10/2014",@"06/10/2014",@"06/10/2014",@"05/10/2014",@"05/10/2014",@"06/10/2014",@"06/10/2014",@"05/10/2014", nil];
    
     numberOfItemArray=[NSMutableArray arrayWithObjects:@"3 items",@"Big Mac Menu",@"3 items",@"3 items",@"Big Mac Menu",@"3 items",@"Big Mac Menu",@"3 items",@"Big Mac Menu",@"3 items",@"Big Mac Menu",@"3 items", nil];
    
     totalAmountArray=[NSMutableArray arrayWithObjects:@"-$10.00",@"-$2.00",@"-$10.00",@"-$10.00",@"-$2.00",@"-$10.00",@"-$10.00",@"-$2.00",@"-$2.00",@"-$10.00",@"-$10.00",@"-$2.00", nil];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self transactionListingWebserviceWithstartCount:0 showProgress:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods

-(void)backToUserProfile
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)transactionListingWebserviceWithstartCount:(long) start showProgress:(BOOL)showProgressIndicator
{
    NETWORK_TEST_PROCEDURE
    
    if (isMerchantWebserviceRunning) {
        return;
    }
    
    isMerchantWebserviceRunning = YES;
    
    if (showProgressIndicator) {
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    }
    if (transactionManager==nil) {
        transactionManager = [[TLTransactionListingManager alloc]init];
    }
    transactionManager.delegate = self;
    [transactionManager callService:@"" withStartCount:start];
}

-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    [self transactionListingWebserviceWithstartCount:0 showProgress:NO];
}

-(void) loadMoreUsers {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self transactionListingWebserviceWithstartCount:lastFetchCount showProgress:NO];
    }
}

#pragma mark - Table View Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionList count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRANS_CELL_HEIGHT;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellID";
    
   UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=UIColorFromRGB(0xF5F5F5);
            
        EGOImageView *merchantIconImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(0, 0, 50, PROFILE_CELL_HEIGHT-2)];
        merchantIconImgView.tag=1000;
        merchantIconImgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:merchantIconImgView];
        
        UILabel *merchantNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(50 + 10,10, 186, (PROFILE_CELL_HEIGHT-2)/2 - 8)];
        merchantNameLbl.textColor=UIColorFromRGB(0x333333);
        merchantNameLbl.tag=1001;
        merchantNameLbl.textAlignment=NSTextAlignmentLeft;
        merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        merchantNameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:merchantNameLbl];
        
        UILabel *numberofItemLbl=[[UILabel alloc] initWithFrame:CGRectMake(50 +10,CGRectGetMaxY(merchantNameLbl.frame), 150, (PROFILE_CELL_HEIGHT-2)/2-8)];
        numberofItemLbl.tag=1002;
        numberofItemLbl.textColor=UIColorFromRGB(0x333333);
        numberofItemLbl.textAlignment=NSTextAlignmentLeft;
        numberofItemLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        numberofItemLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:numberofItemLbl];
        
        UILabel *transactionDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-46, 10, 59, (PROFILE_CELL_HEIGHT-2)/2 - 8)];
        transactionDateLbl.textColor=UIColorFromRGB(0x808080);
        transactionDateLbl.tag=1003;
        transactionDateLbl.textAlignment=NSTextAlignmentRight;
        transactionDateLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
        transactionDateLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:transactionDateLbl];
        
        UILabel *totalAmountLbl=[[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-46, CGRectGetMaxY(transactionDateLbl.frame), 98, (PROFILE_CELL_HEIGHT-2)/2 -8 )];
        totalAmountLbl.textColor=UIColorFromRGB(0x00b3a4);
        totalAmountLbl.textAlignment=NSTextAlignmentRight;
        totalAmountLbl.tag=1004;
        totalAmountLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        totalAmountLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:totalAmountLbl];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, TRANS_CELL_HEIGHT-2,baseViewWidth,2)];
        lineView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:lineView];
    }
    
    RecentActivityModel* transaction = [transactionList objectAtIndex:indexPath.row];
    
    EGOImageView *merchantIconImgView=(EGOImageView *) [cell.contentView viewWithTag:1000];
    merchantIconImgView.imageURL = [NSURL URLWithString:transaction.MerchantIcon];
    
    UILabel *merchantNameLbl=(UILabel *) [cell.contentView viewWithTag:1001];
    merchantNameLbl.text=transaction.CompanyName;
    
    UILabel *numberofItemLbl=(UILabel *) [cell.contentView viewWithTag:1002];
    if(transaction.TotalItems.doubleValue>1)
        numberofItemLbl.text=[NSString stringWithFormat:@"%@ items",transaction.TotalItems];
    else
        numberofItemLbl.text=[NSString stringWithFormat:@"%@ item",transaction.TotalItems];
    
    UILabel *transactionDateLbl=(UILabel *) [cell.contentView viewWithTag:1003];
    transactionDateLbl.text= [TuplitConstants getOrderDate:transaction.OrderDate];
    transactionDateLbl.frame = CGRectMake(tableView.frame.size.width-59-12, 10, 59, (PROFILE_CELL_HEIGHT-2)/2 - 8);
    
    UILabel *totalAmountLbl=(UILabel *) [cell.contentView viewWithTag:1004];
    totalAmountLbl.text=[NSString stringWithFormat:@"-%@",[[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:transaction.TotalPrice.doubleValue]]];
    int totLblWidth = [totalAmountLbl.text widthWithFont:totalAmountLbl.font];
    totalAmountLbl.frame = CGRectMake(tableView.frame.size.width-totLblWidth-15, CGRectGetMaxY(transactionDateLbl.frame), totLblWidth+3, (PROFILE_CELL_HEIGHT-2)/2 -8 );
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLTransactionDetailViewController *transactionDetail=[[TLTransactionDetailViewController alloc] init];
     RecentActivityModel* transaction = [transactionList objectAtIndex:indexPath.row];
    transactionDetail.orderID = transaction.OrderId;
    transactionDetail.transActionList = transactionList;
    transactionDetail.index = indexPath.row;
    [self.navigationController pushViewController:transactionDetail animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    
    if (offset >= 0.0 && offset <= 50.0) {
        
        [self loadMoreUsers];
    }
}

#pragma  mark - TLTransactionListingManager Delegate Methods
- (void)transactionListingManagerSuccess:(TLTransactionListingManager *)trancactionListingManager withTrancactionListingManager:(NSArray*)_transactionList;
{
    if (isLoadMorePressed) {
        
        [transactionList addObjectsFromArray:_transactionList];
    }
    else
    {
        transactionList = [NSMutableArray arrayWithArray:_transactionList];
        lastFetchCount = 0;
    }
    
    totalUserListCount = trancactionListingManager.totalCount;
    
    if ((trancactionListingManager.listedCount % 20) == 0) {
        lastFetchCount = lastFetchCount + trancactionListingManager.listedCount;
    }
    else
    {
        lastFetchCount = transactionList.count;
    }
    
    [allTransactionTableView reloadData];
    
    if (lastFetchCount < totalUserListCount)
        [allTransactionTableView setTableFooterView:cellContainer];
    else
        [allTransactionTableView setTableFooterView:nil];
    
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];

    
}
- (void)transactionListingManager:(TLTransactionListingManager *)trancactionListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [transactionList removeAllObjects];
    [allTransactionTableView reloadData];
    isMerchantWebserviceRunning =NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)transactionListingManagerFailed:(TLTransactionListingManager *)trancactionListingManager
{
    [[ProgressHud shared] hide];
    [transactionList removeAllObjects];
    [allTransactionTableView reloadData];
    isMerchantWebserviceRunning =NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
@end
