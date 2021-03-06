//
//  CartAcknowledgementViewController.m
//  Tuplit
//
//  Created by ev_mac8 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CartDetailViewController.h"

@interface CartDetailViewController ()

@end

@implementation CartDetailViewController

@synthesize TransactionId;

#pragma mark - View life cycle methods.

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"Thank You!")];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] init];
    [navRightButton buttonWithIcon:getImage(@"close", NO) target:self action:@selector(closeViewController:) isLeft:NO];
    [self.navigationItem setRightBarButtonItem:navRightButton];
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    numberOfCell = APP_DELEGATE.cartModel.products.count;
    tableHeight=numberOfCell * CELL_HEIGHT;
    
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,baseViewWidth,baseViewHeight)];
    contentView.backgroundColor=[UIColor colorWithPatternImage:getImage(@"bg", NO)];
    [self.view addSubview:contentView];
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.backgroundColor=[UIColor clearColor];
    [contentView addSubview:scrollView];
    
    UILabel *redeemLbl=[[UILabel alloc] initWithFrame:CGRectMake(60,0,197, 92)];
    redeemLbl.text=@"Please, tell the shop staff your name in order to redeem the deal";
    redeemLbl.textAlignment = NSTextAlignmentCenter;
    redeemLbl.numberOfLines = 0;
    redeemLbl.textColor = UIColorFromRGB(0X333333);
    redeemLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    redeemLbl.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:redeemLbl];
    
    UIImage *detailImg=getImage(@"receipt", NO);
    detailImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(redeemLbl.frame),contentView.width-10, 254 + tableHeight)];
    detailImgView.image=detailImg;
    detailImgView.userInteractionEnabled = YES;
    detailImgView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:detailImgView];
    
    UILabel *merchantNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,27, detailImgView.width-28, 20)];
    merchantNameLbl.text=[APP_DELEGATE.cartModel.companyName stringWithTitleCase];
    merchantNameLbl.textAlignment=NSTextAlignmentCenter;
    merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    merchantNameLbl.textColor=UIColorFromRGB(0x333333);
    merchantNameLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:merchantNameLbl];
    
    UILabel *merchantAddressLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(merchantNameLbl.frame), detailImgView.width-28, 30)];
    merchantAddressLbl.text=APP_DELEGATE.cartModel.address;
    merchantAddressLbl.numberOfLines = 0;
    merchantAddressLbl.textAlignment=NSTextAlignmentCenter;
    merchantAddressLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    merchantAddressLbl.textColor = UIColorFromRGB(0x666666);
    merchantAddressLbl.backgroundColor = [UIColor clearColor];
    [detailImgView addSubview:merchantAddressLbl];
    
    float height = [APP_DELEGATE.cartModel.address heigthWithWidth:merchantAddressLbl.frame.size.width andFont:merchantAddressLbl.font];
    merchantAddressLbl.frame = CGRectMake(14,CGRectGetMaxY(merchantNameLbl.frame), detailImgView.width-28, height);
    
    NSDateFormatter *dateFormtter = [[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"MM/dd/yyyy, h:mm a"];
    NSString *dateString = [dateFormtter stringFromDate:[NSDate date]];
    
    UILabel *dateTimeLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(merchantAddressLbl.frame)+10, detailImgView.width-28,20)];
    dateTimeLbl.text=dateString;
    dateTimeLbl.textAlignment=NSTextAlignmentCenter;
    dateTimeLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    dateTimeLbl.textColor=UIColorFromRGB(0x999999);
    dateTimeLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:dateTimeLbl];
    
    UIImageView *lineImgView1=[[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(dateTimeLbl.frame)+12,detailImgView.frame.size.width-24, 3)];
    lineImgView1.backgroundColor=[UIColor clearColor];
    lineImgView1.image=getImage(@"line", NO);
    [detailImgView addSubview:lineImgView1];
    
    itemsListTable=[[UITableView alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(lineImgView1.frame), detailImgView.width-28, tableHeight)];
    itemsListTable.delegate=self;
    itemsListTable.dataSource=self;
    itemsListTable.scrollEnabled=NO;
    itemsListTable.backgroundColor=[UIColor clearColor];
    itemsListTable.separatorColor=[UIColor clearColor];
    [detailImgView addSubview:itemsListTable];
    
    lineImgView2=[[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(itemsListTable.frame),detailImgView.frame.size.width-24, 3)];
    lineImgView2.backgroundColor=[UIColor clearColor];
    lineImgView2.image=getImage(@"line", NO);
    [detailImgView addSubview:lineImgView2];
    
    UILabel *subtotalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(58,CGRectGetMaxY(lineImgView2.frame),detailImgView.width-150, 28)];
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
    
    UILabel *vattotalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,CGRectGetMaxY(subtotalTitleLbl.frame), 108, 28)];
    vattotalTitleLbl.text=@"VAT";
    vattotalTitleLbl.textColor=UIColorFromRGB(0x333333);
    vattotalTitleLbl.textAlignment=NSTextAlignmentLeft;
    vattotalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    vattotalTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:vattotalTitleLbl];
    
    vatAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subtotalTitleLbl.frame)+100,CGRectGetMinY(vattotalTitleLbl.frame), 30, 28)];
    vatAmtTotalLbl.text=@"£10";
    vatAmtTotalLbl.textColor=UIColorFromRGB(0x333333);
    vatAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    vatAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    vatAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:vatAmtTotalLbl];
    
    UILabel *totalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,CGRectGetMaxY(vattotalTitleLbl.frame), 108, 28)];
    totalTitleLbl.text=@"Total";
    totalTitleLbl.textColor=UIColorFromRGB(0x333333);
    totalTitleLbl.textAlignment=NSTextAlignmentLeft;
    totalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    totalTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:totalTitleLbl];
    
    totalAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vattotalTitleLbl.frame)+100,CGRectGetMinY(totalTitleLbl.frame), 30, 28)];
    totalAmtTotalLbl.text=@"£10";
    totalAmtTotalLbl.textColor=UIColorFromRGB(0x333333);
    totalAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    totalAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    totalAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:totalAmtTotalLbl];
    
    UIImageView *lineImgView3=[[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(totalTitleLbl.frame),detailImgView.width-24, 3)];
    lineImgView3.backgroundColor=[UIColor clearColor];
    lineImgView3.image=getImage(@"line", NO);
    [detailImgView addSubview:lineImgView3];
    
    UILabel *transactionTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(lineImgView3.frame)+14, detailImgView.width-28, 20)];
    transactionTitleLbl.text=@"Transaction ID";
    transactionTitleLbl.textColor=UIColorFromRGB(0x333333);
    transactionTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    transactionTitleLbl.textAlignment=NSTextAlignmentCenter;
    transactionTitleLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:transactionTitleLbl];
    
    UILabel *transactionIDLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(transactionTitleLbl.frame)-5, detailImgView.width-28, 20)];
    transactionIDLbl.text = self.TransactionId;
    transactionIDLbl.textColor=UIColorFromRGB(0x666666);
    transactionIDLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    transactionIDLbl.textAlignment=NSTextAlignmentCenter;
    transactionIDLbl.backgroundColor=[UIColor clearColor];
    [detailImgView addSubview:transactionIDLbl];
    
    thanksLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(transactionIDLbl.frame)+15, detailImgView.width-28, 20)];
    thanksLbl.textColor=UIColorFromRGB(0x666666);
    thanksLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    thanksLbl.textAlignment=NSTextAlignmentCenter;
    thanksLbl.backgroundColor=[UIColor clearColor];
    thanksLbl.text = LString(@"THANKS_TEXT");
    [detailImgView addSubview:thanksLbl];
    
    linkLbl=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(thanksLbl.frame)-5, detailImgView.width-28, 20)];
    linkLbl.textColor=UIColorFromRGB(0x666666);
    linkLbl.highlightedTextColor = [UIColor whiteColor];
    linkLbl.delegate = self;
    linkLbl.numberOfLines = 0;
    linkLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    linkLbl.textAlignment=NSTextAlignmentCenter;
    linkLbl.backgroundColor=[UIColor clearColor];
    linkLbl.text = LString(@"LINK_TEXT");
    linkLbl.linkAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],(NSString *)kCTUnderlineStyleAttributeName,APP_DELEGATE.defaultColor,(NSString *)kCTForegroundColorAttributeName, nil];
    
    NSRange r = [linkLbl.text rangeOfString:@"www.tuplit.com"];
    NSURL *url = [NSURL URLWithString:@"http://www.tuplit.com/"];
    NSLog(@"%@",url);
    [linkLbl addLinkToURL:url withRange:r];
    linkLbl.userInteractionEnabled = YES;
    [detailImgView addSubview:linkLbl];
    
    thanksLbl.frame = CGRectMake(5,CGRectGetMaxY(transactionIDLbl.frame)+15, detailImgView.width-10, 20);
    
    float linkTxtHeight = [linkLbl.text heigthWithWidth:linkLbl.width andFont:linkLbl.font];
    linkLbl.frame = CGRectMake(20,CGRectGetMaxY(thanksLbl.frame)-5, detailImgView.width-40, linkTxtHeight+1);
    [itemsListTable reloadData];
    
    
    detailImgView.frame = CGRectMake(5, CGRectGetMaxY(redeemLbl.frame),contentView.width-10, CGRectGetMaxY(linkLbl.frame) + 50);
    if([detailImgView.image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        UIImage *stretchableBackground = [detailImgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(20,15,40,15) resizingMode:UIImageResizingModeStretch];
        detailImgView.image = stretchableBackground;
    }
    scrollView.contentSize=CGSizeMake(contentView.width,CGRectGetMaxY(detailImgView.frame) + 50);
    
    numberFormatter = [TuplitConstants getCurrencyFormat];
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
    [self updateCart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UserDefined method

-(void) closeViewController:(id) sender
{
    
    OrderDetailModel *cmtDetail = [[OrderDetailModel alloc]init];
    cmtDetail.MerchantId = APP_DELEGATE.cartModel.merchantID;
    cmtDetail.CompanyName = APP_DELEGATE.cartModel.companyName;
    cmtDetail.OrderId = self.OrderId;
    
    [TLUserDefaults setCommentDetails:cmtDetail];
    
    NSLog(@"companyName = %@",cmtDetail.CompanyName);
    NSLog(@"companyName = %@",[TLUserDefaults getCommentDetails].CompanyName);
    
    [TLUserDefaults setIsCommentPromptOpen:YES];
    
    TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
    [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
    
    APP_DELEGATE.cartModel = [[CartModel alloc] init];
}

-(void) updateCart {
    
    numberOfCell=APP_DELEGATE.cartModel.products.count;
    tableHeight=numberOfCell * CART_CELL_HEIGHT;
    
    itemArray = APP_DELEGATE.cartModel.products;
    
    totalAmtLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.discountedTotal]];
    float totalAmountWidth = [totalAmtLbl.text widthWithFont:totalAmtLbl.font];
    totalAmtLbl.frame = CGRectMake((itemsListTable.frame.size.width - totalAmountWidth) + 2, totalAmtLbl.yPosition, totalAmountWidth, 28);
    
    vatAmtTotalLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.vat]];
    float vatAmtTWidth = [vatAmtTotalLbl.text widthWithFont:vatAmtTotalLbl.font];
    vatAmtTotalLbl.frame = CGRectMake((itemsListTable.frame.size.width - vatAmtTWidth) + 2 , vatAmtTotalLbl.yPosition, vatAmtTWidth, 28);
    
    totalAmtTotalLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.total]];
    float totalAmtTWidth = [totalAmtTotalLbl.text widthWithFont:totalAmtTotalLbl.font];
    totalAmtTotalLbl.frame = CGRectMake((itemsListTable.frame.size.width - totalAmtTWidth) + 2, totalAmtTotalLbl.yPosition, totalAmtTWidth, 28);
    
    [itemsListTable reloadData];
}

#pragma mark - TableView Delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    
    SpecialProductsModel *specialProductModel = [itemArray objectAtIndex:indexPath.row];
    
    UILabel *itemQuantityLbl= (UILabel *)[cell.contentView viewWithTag:1000];
    UILabel *itemNameLbl= (UILabel *)[cell.contentView viewWithTag:1001];
    UILabel *fixedAmountLbl=(UILabel *)[cell.contentView viewWithTag:1002];
    UILabel *discountAmountLbl=(UILabel *)[cell.contentView viewWithTag:1003];
    
    int adjust = 0;
    if ([specialProductModel.quantity intValue] > 1) {
        
        itemQuantityLbl.hidden = NO;
        itemQuantityLbl.text = [NSString stringWithFormat:@"%@x",specialProductModel.quantity];
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
    
    double discountPrice = [specialProductModel.DiscountPrice doubleValue];
    if ([specialProductModel.DiscountPrice doubleValue] == 0.0) {
        discountPrice = [specialProductModel.Price doubleValue];
        fixedAmountLbl.hidden = YES;
    }
    else
    {
        discountPrice = [specialProductModel.DiscountPrice doubleValue];
        fixedAmountLbl.hidden = NO;
    }
    
    double quantity = [specialProductModel.quantity intValue];
    double price = [specialProductModel.Price doubleValue];
    
    discountAmountLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(discountPrice * quantity)]];
    float discountWidth = [discountAmountLbl.text widthWithFont:discountAmountLbl.font];
    discountAmountLbl.frame = CGRectMake((tableView.frame.size.width - discountWidth) - 10, 0, discountWidth, CELL_HEIGHT);
    
    fixedAmountLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(price * quantity)]];
    float fixedAmountWidth = [fixedAmountLbl.text widthWithFont:fixedAmountLbl.font];
    fixedAmountLbl.frame = CGRectMake((discountAmountLbl.frame.origin.x - fixedAmountWidth) - 5, 0, fixedAmountWidth, CELL_HEIGHT);
    
    itemNameLbl.text = specialProductModel.ItemName;
    itemNameLbl.frame = CGRectMake(CGRectGetMaxX(itemQuantityLbl.frame) + adjust,0, fixedAmountLbl.frame.origin.x - CGRectGetMaxX(itemQuantityLbl.frame) - 4, CELL_HEIGHT);
    
    return cell;
}

#pragma  mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

@end
