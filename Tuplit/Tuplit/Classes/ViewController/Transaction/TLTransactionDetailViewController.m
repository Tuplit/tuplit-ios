//
//  TransactionDetail.m
//  Tuplit
//
//  Created by ev_mac8 on 11/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTransactionDetailViewController.h"
#import "TLOrderConformViewController.h"
@interface TLTransactionDetailViewController ()
{
    UILabel *merchantNameLbl;
    UILabel *merchantAddressLbl;
    UILabel *dateTimeLbl;
    UILabel *totalAmtLbl;
    UILabel *transactionIDLbl;
    UIImageView *lineImgView1;
    UIImageView *lineImgView2;
    UILabel *subtotalTitleLbl;
    UIImageView *lineImgView3;
    UILabel *transactionTitleLbl;
    UILabel *vatAmtTotalLbl;
    UILabel *totalAmtTotalLbl;
    UILabel *vattotalTitleLbl;
    UILabel *totalTitleLbl;
    
    TLTransactionListingManager *transactionManager;
    BOOL isLoadMorePressed,isPullRefreshPressed,isMerchantWebserviceRunning;
}

@end

@implementation TLTransactionDetailViewController
@synthesize orderID,transActionList,index,lastFetchCount,totalUserListCount;

#pragma mark - View Life Cycle Methods

-(void)dealloc
{
    transactionManager.delegate = nil;
    transactionManager = nil;
}
-(void) loadView
{
    [super loadView];
    if([self.viewController isKindOfClass:[TLOrderConformViewController class]])
    {
        [self.navigationItem setTitle:LString(@"RECEIPT")];
    }
    else
    {
        [self.navigationItem setTitle:LString(@"TRANSACTION_DETAIL")];
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    [back backButtonWithTarget:self action:@selector(backUserProfileAction)];
    [self.navigationItem setLeftBarButtonItem:back];
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,baseViewWidth,baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseView.width, baseView.height)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.backgroundColor=[UIColor clearColor];
    [baseView addSubview:scrollView];
    
    UIImage *detailImg=[UIImage imageNamed:@"receipt"];
    detailImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 20,baseView.width-10, 254 + tableHeight)];
    detailImgView.image=detailImg;
    detailImgView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:detailImgView];
    
    merchantNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(5,27, detailImgView.width-10, 20)];
    merchantNameLbl.textAlignment=NSTextAlignmentCenter;
    merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    merchantNameLbl.textColor=UIColorFromRGB(0x333333);
    merchantNameLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:merchantNameLbl];
    
    merchantAddressLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(merchantNameLbl.frame),CGRectGetMaxY(merchantNameLbl.frame), CGRectGetWidth(merchantNameLbl.frame), 10)];
    merchantAddressLbl.textAlignment=NSTextAlignmentCenter;
    merchantAddressLbl.numberOfLines=0;
    merchantAddressLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    merchantAddressLbl.textColor=UIColorFromRGB(0x666666);
    merchantAddressLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:merchantAddressLbl];
    
    dateTimeLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(merchantNameLbl.frame),CGRectGetMaxY(merchantAddressLbl.frame)+10,CGRectGetWidth(merchantNameLbl.frame),20)];
    dateTimeLbl.textAlignment=NSTextAlignmentCenter;
    dateTimeLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    dateTimeLbl.textColor=UIColorFromRGB(0x999999);
    dateTimeLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:dateTimeLbl];
    
    lineImgView1=[[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(dateTimeLbl.frame)+12,detailImgView.width-24, 3)];
    lineImgView1.image=[UIImage imageNamed:@"line"];
    lineImgView1.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:lineImgView1];
    
    itemsListTable=[[UITableView alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(lineImgView1.frame), detailImgView.width-28, tableHeight)];
    itemsListTable.delegate=self;
    itemsListTable.dataSource=self;
    itemsListTable.scrollEnabled=NO;
    itemsListTable.separatorColor=[UIColor clearColor];
    [detailImgView addSubview:itemsListTable];
    
    lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(itemsListTable.frame),detailImgView.width-24, 3)];
    lineImgView2.image=[UIImage imageNamed:@"line"];
    lineImgView2.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:lineImgView2];
    
    subtotalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(58,CGRectGetMaxY(lineImgView2.frame)+2,detailImgView.width-150, 28)];
    subtotalTitleLbl.text=@"Sub total";
    subtotalTitleLbl.textColor=UIColorFromRGB(0x333333);
    subtotalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    subtotalTitleLbl.textAlignment=NSTextAlignmentLeft;
    subtotalTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:subtotalTitleLbl];
    
    totalAmtLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subtotalTitleLbl.frame) +2, CGRectGetMinY(subtotalTitleLbl.frame), 66, 28)];
    totalAmtLbl.textAlignment=NSTextAlignmentRight;
    totalAmtLbl.textColor=UIColorFromRGB(0x333333);
    totalAmtLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    totalAmtLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:totalAmtLbl];
    
    vattotalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,CGRectGetMaxY(subtotalTitleLbl.frame), 108, 28)];
    vattotalTitleLbl.text=@"VAT";
    vattotalTitleLbl.textColor=UIColorFromRGB(0x333333);
    vattotalTitleLbl.textAlignment=NSTextAlignmentLeft;
    vattotalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    vattotalTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:vattotalTitleLbl];
    
    vatAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subtotalTitleLbl.frame)+100,CGRectGetMinY(vattotalTitleLbl.frame), 30, 28)];
    vatAmtTotalLbl.text=@"";
    vatAmtTotalLbl.textColor=UIColorFromRGB(0x333333);
    vatAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    vatAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    vatAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:vatAmtTotalLbl];
    
    totalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,CGRectGetMaxY(vattotalTitleLbl.frame), 108, 28)];
    totalTitleLbl.text=@"Total";
    totalTitleLbl.textColor=UIColorFromRGB(0x333333);
    totalTitleLbl.textAlignment=NSTextAlignmentLeft;
    totalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    totalTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:totalTitleLbl];
    
    totalAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vattotalTitleLbl.frame)+100,CGRectGetMinY(totalTitleLbl.frame), 30, 28)];
    totalAmtTotalLbl.text=@"";
    totalAmtTotalLbl.textColor=UIColorFromRGB(0x333333);
    totalAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    totalAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    totalAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:totalAmtTotalLbl];
    
    lineImgView3=[[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(totalAmtTotalLbl.frame),detailImgView.width-24, 3)];
    lineImgView3.image=[UIImage imageNamed:@"line"];
    lineImgView3.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:lineImgView3];
    
    transactionTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(lineImgView3.frame)+14, detailImgView.width-28, 20)];
    transactionTitleLbl.text=@"Transaction ID";
    transactionTitleLbl.textColor=UIColorFromRGB(0x333333);
    transactionTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    transactionTitleLbl.textAlignment=NSTextAlignmentCenter;
    transactionTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:transactionTitleLbl];
    
    transactionIDLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(transactionTitleLbl.frame)-5, detailImgView.width-28, 20)];
    transactionIDLbl.textColor=UIColorFromRGB(0x666666);
    transactionIDLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    transactionIDLbl.textAlignment=NSTextAlignmentCenter;
    transactionIDLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:transactionIDLbl];
    
    scrollView.contentSize=CGSizeMake(baseView.width,CGRectGetMaxY(baseView.frame)+((numberOfCell-8)*CELL_HEIGHT));
    
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
    [self callServiceWithorderID:self.orderID];
    lastFetchCount = (int)self.transActionList.count;
    if(transActionList.count>1&&index!=transActionList.count-1)
    {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        [backBtn buttonWithTitle:LString(@"NEXT") withTarget:self action:@selector(nextViewController:)];
        [self.navigationItem setRightBarButtonItem:backBtn];
        
        if (lastFetchCount<totalUserListCount) {
            [self performSelectorInBackground:@selector(transactionListingWebserviceWithstartCount) withObject:nil];
            isLoadMorePressed = YES;
        }
    }

       
//    [self performSelectorInBackground:@selector(transactionListingWebserviceWithstartCount) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UserDefined method

-(void)callServiceWithorderID:(NSString*) _orderID
{
    NETWORK_TEST_PROCEDURE
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLOrderListingManager *orderlistManger = [[TLOrderListingManager alloc]init];
    orderlistManger.delegate = self;
    [orderlistManger callService:_orderID];
}

-(void)transactionListingWebserviceWithstartCount
{
    NETWORK_TEST_PROCEDURE
    
    if (isMerchantWebserviceRunning) {
        return;
    }
    
    isMerchantWebserviceRunning = YES;
    
    if (transactionManager==nil) {
        transactionManager = [[TLTransactionListingManager alloc]init];
    }
    transactionManager.delegate = self;
    [transactionManager callService:self.userID withStartCount:lastFetchCount];
}

-(void)updateOrderDetails
{
    tableHeight=orderdetail.Products.count * CELL_HEIGHT;
//    detailImgView.frame = CGRectMake(5, 20,baseViewWidth-10, 254 + tableHeight);
    merchantNameLbl.text = [orderdetail.CompanyName stringWithTitleCase];
    
    merchantAddressLbl.text = orderdetail.Address;
    float height = [merchantAddressLbl.text heigthWithWidth:merchantAddressLbl.frame.size.width andFont:merchantAddressLbl.font];
    merchantAddressLbl.frame = CGRectMake(14,CGRectGetMaxY(merchantNameLbl.frame), detailImgView.width-28, height);
    
    dateTimeLbl.text = [TuplitConstants getOrderDateTime:orderdetail.OrderDate];
    dateTimeLbl.frame = CGRectMake(CGRectGetMinX(merchantNameLbl.frame),CGRectGetMaxY(merchantAddressLbl.frame)+10,CGRectGetWidth(merchantNameLbl.frame),20);
    
    lineImgView1.frame = CGRectMake(12, CGRectGetMaxY(dateTimeLbl.frame)+12,detailImgView.width-24, 3);
    
    itemsListTable.frame = CGRectMake(14,CGRectGetMaxY(lineImgView1.frame), detailImgView.width-28, tableHeight);
    
    lineImgView2.frame = CGRectMake(12, CGRectGetMaxY(itemsListTable.frame),detailImgView.width-24, 3);
    
    subtotalTitleLbl.frame=CGRectMake(58,CGRectGetMaxY(lineImgView2.frame)+8,detailImgView.width-150, 28);
    totalAmtLbl.text = [[TuplitConstants getCurrencyFormat]stringFromNumber:[NSNumber numberWithDouble:orderdetail.SubTotal.doubleValue]];
    float titLblWidth = [totalAmtLbl.text widthWithFont:totalAmtLbl.font];
    totalAmtLbl.frame = CGRectMake((itemsListTable.frame.size.width - titLblWidth) + 2, subtotalTitleLbl.yPosition, titLblWidth, CELL_HEIGHT);
    
    vattotalTitleLbl.frame=CGRectMake(58,CGRectGetMaxY(subtotalTitleLbl.frame),detailImgView.width-150, 28);
    vatAmtTotalLbl.text = [[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:orderdetail.VAT.doubleValue]];
    float vatAmtTWidth = [vatAmtTotalLbl.text widthWithFont:vatAmtTotalLbl.font];
    vatAmtTotalLbl.frame = CGRectMake((itemsListTable.frame.size.width - vatAmtTWidth) + 2 , vattotalTitleLbl.yPosition, vatAmtTWidth, 28);
    
    totalTitleLbl.frame=CGRectMake(58,CGRectGetMaxY(vattotalTitleLbl.frame),detailImgView.width-150, 28);
    totalAmtTotalLbl.text = [[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:orderdetail.TotalPrice.doubleValue]];
    float totalAmtTWidth = [totalAmtTotalLbl.text widthWithFont:totalAmtTotalLbl.font];
    totalAmtTotalLbl.frame = CGRectMake((itemsListTable.frame.size.width - totalAmtTWidth) + 2, totalTitleLbl.yPosition, totalAmtTWidth, 28);
    
    lineImgView3.frame = CGRectMake(12, CGRectGetMaxY(totalTitleLbl.frame),detailImgView.width-24, 3);
    
    transactionTitleLbl.frame = CGRectMake(14, CGRectGetMaxY(lineImgView3.frame)+14, detailImgView.width-28, 20);
    transactionIDLbl.text = orderdetail.TransactionId;
    transactionIDLbl.frame = CGRectMake(5,CGRectGetMaxY(transactionTitleLbl.frame)-5, detailImgView.width-10, 20);
    [itemsListTable reloadData];
    
    if([transactionIDLbl.text length]==0)
        transactionTitleLbl.hidden = YES;
    
    detailImgView.frame = CGRectMake(5, 20,baseViewWidth-10, CGRectGetMaxY(transactionIDLbl.frame) + 50);
    if([detailImgView.image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        UIImage *stretchableBackground = [detailImgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20,15,40,15) resizingMode:UIImageResizingModeStretch];
        detailImgView.image = stretchableBackground;
    }
    
    scrollView.contentSize=CGSizeMake(baseViewWidth,CGRectGetMaxY(detailImgView.frame) + 50);
    lastFetchCount = (int)transActionList.count;
    
}

-(void) closeViewController:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backUserProfileAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextViewController : (id) sender
{
    index++;
    if([transActionList count]>index)
    {
        RecentActivityModel* transaction = [transActionList objectAtIndex:index];
        [self callServiceWithorderID:transaction.OrderId];
        
        if([transActionList count]-1==index)
        {
            if (lastFetchCount<totalUserListCount) {
                [self performSelectorInBackground:@selector(transactionListingWebserviceWithstartCount) withObject:nil];
                isLoadMorePressed = YES;
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
        
    }
}

#pragma mark - TableView Delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderdetail.Products.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        
        UILabel *itemQuantityLbl=[[UILabel alloc]initWithFrame:CGRectMake(10 ,0, 30, CELL_HEIGHT)];
        itemQuantityLbl.textColor=UIColorFromRGB(0x666666);
        itemQuantityLbl.tag=1000;
        itemQuantityLbl.numberOfLines=0;
        itemQuantityLbl.textAlignment=NSTextAlignmentCenter;
        itemQuantityLbl.adjustsFontSizeToFitWidth=YES;
        itemQuantityLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:14.0];
        itemQuantityLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:itemQuantityLbl];
        
        UILabel *itemNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(itemQuantityLbl.frame) ,0, 160, CELL_HEIGHT)];
        itemNameLbl.textColor=UIColorFromRGB(0x333333);
        itemNameLbl.tag=1001;
        itemNameLbl.numberOfLines=0;
        itemNameLbl.adjustsFontSizeToFitWidth=YES;
        itemNameLbl.textAlignment=NSTextAlignmentLeft;
        itemNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        itemNameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:itemNameLbl];
        
        UILabel *fixedAmountLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(itemNameLbl.frame), 0, 20, CELL_HEIGHT)];
        fixedAmountLbl.textColor=UIColorFromRGB(0x808080);
        fixedAmountLbl.tag=1002;
        fixedAmountLbl.textAlignment=NSTextAlignmentRight;
        fixedAmountLbl.backgroundColor=[UIColor clearColor];
        fixedAmountLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
        [cell.contentView addSubview:fixedAmountLbl];
        
        UILabel *discountAmountLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fixedAmountLbl.frame), 0, 30, CELL_HEIGHT)];
        discountAmountLbl.tag=1003;
        discountAmountLbl.textAlignment=NSTextAlignmentCenter;
        discountAmountLbl.textColor=UIColorFromRGB(0x333333);
        discountAmountLbl.backgroundColor=[UIColor clearColor];
        discountAmountLbl.textAlignment=NSTextAlignmentRight;
        discountAmountLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        [cell.contentView addSubview:discountAmountLbl];
    }
    
    OrderProductModel *productDetails = [orderdetail.Products objectAtIndex:indexPath.row];
    
    UILabel *itemQuantityLbl= (UILabel *)[cell.contentView viewWithTag:1000];
    UILabel *itemNameLbl= (UILabel *)[cell.contentView viewWithTag:1001];
    UILabel *fixedAmountLbl=(UILabel *)[cell.contentView viewWithTag:1002];
    UILabel *discountAmountLbl=(UILabel *)[cell.contentView viewWithTag:1003];
    
    int adjust = 0;
    if ([productDetails.ProductsQuantity intValue] > 1) {
        
        itemQuantityLbl.hidden = NO;
        itemQuantityLbl.text = [NSString stringWithFormat:@"%@x",productDetails.ProductsQuantity];
        itemQuantityLbl.frame = CGRectMake(10,0, [itemQuantityLbl.text widthWithFont:itemQuantityLbl.font], CELL_HEIGHT);
        adjust = 2;
    }
    else
    {
        itemQuantityLbl.hidden = YES;
        itemQuantityLbl.text = @"";
        itemQuantityLbl.frame = CGRectMake(10,0, 0, CELL_HEIGHT);
        
        adjust = 0;
    }
    
    double discountPrice = [productDetails.DiscountPrice doubleValue];
    double quantity = [productDetails.ProductsQuantity intValue];
    double price = [productDetails.ProductsCost doubleValue];
    
    if (discountPrice == 0.0 || (discountPrice == price)) {
        discountPrice = price;
        fixedAmountLbl.hidden = YES;
    }
    else
    {
        discountPrice = discountPrice;
        fixedAmountLbl.hidden = NO;
    }
    
    discountAmountLbl.text = [[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:(discountPrice * quantity)]];
    float discountWidth = [discountAmountLbl.text widthWithFont:discountAmountLbl.font];
    discountAmountLbl.frame = CGRectMake((tableView.frame.size.width - discountWidth) - 10, 0, discountWidth, CELL_HEIGHT);
    
    fixedAmountLbl.text = [[TuplitConstants getCurrencyFormat] stringFromNumber:[NSNumber numberWithDouble:(price * quantity)]];
    float fixedAmountWidth = [fixedAmountLbl.text widthWithFont:fixedAmountLbl.font];
    fixedAmountLbl.frame = CGRectMake((discountAmountLbl.frame.origin.x - fixedAmountWidth) - 5, 0, fixedAmountWidth, CELL_HEIGHT);
    
    itemNameLbl.text = productDetails.ItemName;
    itemNameLbl.frame = CGRectMake(CGRectGetMaxX(itemQuantityLbl.frame) + adjust,0, fixedAmountLbl.frame.origin.x - CGRectGetMaxX(itemQuantityLbl.frame) - 4, CELL_HEIGHT);
    
    return cell;
}
#pragma  mark - TLOrderDetailsManager Delegate Methods
- (void)orderDetailsManagerSuccessful:(TLOrderListingManager *)orderDetailsManager withorderDetails:(OrderDetailModel*) orderDetailModel
{
    orderdetail=orderDetailModel;
    [self updateOrderDetails];
    [[ProgressHud shared] hide];
}
- (void)orderDetailsManager:(TLOrderListingManager *)orderDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)orderDetailsManagerFailed:(TLOrderListingManager *)orderDetailsManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma  mark - TLTransactionListingManager Delegate Methods
- (void)transactionListingManagerSuccess:(TLTransactionListingManager *)trancactionListingManager withTrancactionListingManager:(NSArray*)_transactionList;
{
    
    if (isLoadMorePressed) {
        [transActionList addObjectsFromArray:_transactionList];
    }
    else
    {
        transActionList = [NSMutableArray arrayWithArray:_transactionList];
        lastFetchCount = 0;
        if(transActionList.count>1&&index!=transActionList.count-1)
        {
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
            [backBtn buttonWithTitle:LString(@"NEXT") withTarget:self action:@selector(nextViewController:)];
            [self.navigationItem setRightBarButtonItem:backBtn];
        }
    }
    
    totalUserListCount = (int)trancactionListingManager.totalCount;
    
    lastFetchCount = lastFetchCount + (int)trancactionListingManager.listedCount;
    
    
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isMerchantWebserviceRunning = NO;
}
- (void)transactionListingManager:(TLTransactionListingManager *)trancactionListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    isMerchantWebserviceRunning =NO;
    [UIAlertView alertViewWithMessage:errorMsg];
    
}
- (void)transactionListingManagerFailed:(TLTransactionListingManager *)trancactionListingManager
{
    isMerchantWebserviceRunning =NO;
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end
