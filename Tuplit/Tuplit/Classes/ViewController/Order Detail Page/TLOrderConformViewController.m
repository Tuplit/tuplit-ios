//
//  TLOrderConformViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLOrderConformViewController.h"

@interface TLOrderConformViewController ()

@end

@implementation TLOrderConformViewController
@synthesize informativeTxt,acceptOrRejectImg,btnTitle,lblTitle,orderID,orderStatus,merchatID,merchatName;

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"YOUR_ORDER")];
    self.navigationItem.hidesBackButton = YES;
    
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
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight-64)];
    baseView.backgroundColor=[UIColor colorWithPatternImage:getImage(@"bg", NO)];
    [self.view addSubview:baseView];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseView.width, baseView.height)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.backgroundColor=[UIColor clearColor];
    [baseView addSubview:scrollView];
    
    if(orderStatus.integerValue==1)
        informativeLbl=[[UILabel alloc] initWithFrame:CGRectMake(55,0,210, 92)];
    else
        informativeLbl=[[UILabel alloc] initWithFrame:CGRectMake(35,0,250, 92)];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        informativeLbl.textAlignment=NSTextAlignmentCenter;
    informativeLbl.numberOfLines=0;
    informativeLbl.textColor=UIColorFromRGB(0X333333);
    informativeLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:14.0];
    informativeLbl.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:informativeLbl];
    
    UIImageView *detailImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(informativeLbl.frame),baseView.width-10, 325)];
    detailImgView.image= getImage(@"receipt", NO);
    detailImgView.backgroundColor=[UIColor clearColor];
    [detailImgView setUserInteractionEnabled:YES];
    [scrollView addSubview:detailImgView];
    
    statusImgView=[[UIImageView alloc] initWithFrame:CGRectMake(76,45 ,147, 130)];
    statusImgView.backgroundColor=[UIColor clearColor];
    [statusImgView setContentMode:UIViewContentModeScaleAspectFill];
    [detailImgView addSubview:statusImgView];
    
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(30, CGRectGetMaxY(statusImgView.frame)+40, 250, 45)];
    [backButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    backButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [backButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [detailImgView addSubview:backButton];
    
    backLbl=[[UILabel alloc] initWithFrame:CGRectMake(60,CGRectGetMaxY(detailImgView.frame) + 10,197, 30)];
    backLbl.textAlignment=NSTextAlignmentCenter;
    backLbl.numberOfLines=0;
    backLbl.textColor=UIColorFromRGB(0x02B3A8);
    backLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    backLbl.backgroundColor=[UIColor clearColor];
    backLbl.userInteractionEnabled = YES;
    [scrollView addSubview:backLbl];
    UITapGestureRecognizer *backTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblAction)];
    [backLbl addGestureRecognizer:backTap];
    
    scrollView.contentSize=CGSizeMake(baseViewWidth,CGRectGetMaxY(backLbl.frame) + 40);
    
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
    
    if(orderStatus.integerValue==1)
    {
        informativeLbl.text = LString(@"ORDER_COMPLETED_INFO");
        statusImgView.image = getImage(@"Completed", NO);
        [backButton setTitle:LString(@"BACK_TO_HOME") forState:UIControlStateNormal];
        backLbl.text = LString(@"SHOW_RECEIPT");
    }
    else
    {
        informativeLbl.text = LString(@"ORDER_REJECTED_INFO");
        statusImgView.image = getImage(@"Rejected", NO);
        [backButton setTitle:LString(@"BACK_TO_MERCHANT") forState:UIControlStateNormal];
        backLbl.text = LString(@"BACK_TO_HOME");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods.

-(void) btnAction
{
    if(orderStatus.integerValue==1)
    {
        TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
        
        if(NSNonNilString(self.merchatID).length>0 && NSNonNilString(self.merchatName).length>0)
        {
            OrderDetailModel *cmtDetail = [[OrderDetailModel alloc]init];
            cmtDetail.MerchantId = self.merchatID;
            cmtDetail.CompanyName = self.merchatName;
            cmtDetail.OrderId = self.orderID;
            
            [TLUserDefaults setCommentDetails:cmtDetail];
            [TLUserDefaults setIsCommentPromptOpen:YES];
        }
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
        
    }
    else
    {
        TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
        
        //        TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
        //        detailsVC.detailsMerchantID = self.merchatID;
        //        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
}
-(void) lblAction
{
    if(self.orderStatus.integerValue==1)
    {
        TLTransactionDetailViewController *transactionDetail=[[TLTransactionDetailViewController alloc] init];
        transactionDetail.orderID = orderID;
        [self.navigationController pushViewController:transactionDetail animated:YES];
    }
    else
    {
        TLMerchantsViewController *merchantVC = [[TLMerchantsViewController alloc] init];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:merchantVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
    }
}

@end
