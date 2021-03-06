//
//  TLCartViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCartViewController.h"
#import "JSON.h"
#import "TLTopUpViewController.h"

@interface TLCartViewController ()

@end

//static const int animationFramesPerSec = 8;

@implementation TLCartViewController

#pragma mark - View life cycle methods.

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"CART")];
    
    if(self.isMerchant)
    {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        [backBtn buttonWithIcon:getImage(@"back_arrow", NO) target:self action:@selector(backButtonAction) isLeft:YES];
        [self.navigationItem setLeftBarButtonItem:backBtn];
    }
    else
    {
        UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
        [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
        [self.navigationItem setLeftBarButtonItem:navleftButton];
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    numberOfCell=APP_DELEGATE.cartModel.products.count;
    tableHeight=numberOfCell * CART_CELL_HEIGHT;
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.backgroundColor=[UIColor clearColor];
    [baseView addSubview:scrollView];
    
    UILabel *itemsTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth-240, 40)];
    itemsTitleLbl.text=@"Items";
    itemsTitleLbl.textColor=UIColorFromRGB(0x00b3a4);
    itemsTitleLbl.textAlignment=NSTextAlignmentCenter;
    itemsTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    itemsTitleLbl.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:itemsTitleLbl];
    
    UILabel *swipeToEditLbl=[[UILabel alloc] initWithFrame:CGRectMake(220, 0, baseViewWidth-220, 40)];
    swipeToEditLbl.text=@"Swipe to edit";
    swipeToEditLbl.tag=1001;
    swipeToEditLbl.textColor=UIColorFromRGB(0x999999);
    swipeToEditLbl.textAlignment=NSTextAlignmentCenter;
    swipeToEditLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    swipeToEditLbl.backgroundColor=[UIColor clearColor];
    [swipeToEditLbl setUserInteractionEnabled:YES];
    [scrollView addSubview:swipeToEditLbl];
    
    contentView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemsTitleLbl.frame), baseViewWidth,baseViewHeight + tableHeight)];
    contentView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:contentView];
    
    itemsListTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0, contentView.frame.size.width, tableHeight)];
    itemsListTable.delegate=self;
    itemsListTable.dataSource=self;
    itemsListTable.scrollEnabled=NO;
    itemsListTable.separatorColor=[UIColor whiteColor];
    itemsListTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    itemsListTable.backgroundColor=[UIColor clearColor];
    [contentView addSubview:itemsListTable];
    
    debitCreditView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(itemsListTable.frame), contentView.frame.size.width,150)];
    debitCreditView.backgroundColor=[UIColor clearColor];
    debitCreditView.clipsToBounds = YES;
    [contentView addSubview:debitCreditView];
    
    UILabel *subtotalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,5, 108, 28)];
    subtotalTitleLbl.text=@"Sub total";
    subtotalTitleLbl.textColor=UIColorFromRGB(0x333333);
    subtotalTitleLbl.textAlignment=NSTextAlignmentLeft;
    subtotalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    subtotalTitleLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:subtotalTitleLbl];
    
    fixedAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subtotalTitleLbl.frame) + 85,5, 25, 28)];
    fixedAmtTotalLbl.text=@"£13";
    fixedAmtTotalLbl.textColor=[UIColor grayColor];
    fixedAmtTotalLbl.textAlignment=NSTextAlignmentCenter;
    fixedAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
    fixedAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:fixedAmtTotalLbl];
    
    discountAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fixedAmtTotalLbl.frame),5, 30, 28)];
    discountAmtTotalLbl.text=@"£10";
    discountAmtTotalLbl.textColor=UIColorFromRGB(0x00b3a4);
    discountAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    discountAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    discountAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:discountAmtTotalLbl];
    
    UILabel *vattotalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,CGRectGetMaxY(subtotalTitleLbl.frame), 108, 28)];
    vattotalTitleLbl.text=@"VAT";
    vattotalTitleLbl.textColor=UIColorFromRGB(0x333333);
    vattotalTitleLbl.textAlignment=NSTextAlignmentLeft;
    vattotalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    vattotalTitleLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:vattotalTitleLbl];
    
    vatAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subtotalTitleLbl.frame)+100,CGRectGetMinY(vattotalTitleLbl.frame), 30, 28)];
    vatAmtTotalLbl.text=@"£10";
    vatAmtTotalLbl.textColor=UIColorFromRGB(0x00b3a4);
    vatAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    vatAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    vatAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:vatAmtTotalLbl];
    
    UILabel *totalTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57,CGRectGetMaxY(vattotalTitleLbl.frame), 108, 28)];
    totalTitleLbl.text=@"Total";
    totalTitleLbl.textColor=UIColorFromRGB(0x333333);
    totalTitleLbl.textAlignment=NSTextAlignmentLeft;
    totalTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    totalTitleLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:totalTitleLbl];
    
    totalAmtTotalLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(vattotalTitleLbl.frame)+100,CGRectGetMinY(totalTitleLbl.frame), 30, 28)];
    totalAmtTotalLbl.text=@"£10";
    totalAmtTotalLbl.textColor=UIColorFromRGB(0x00b3a4);
    totalAmtTotalLbl.textAlignment=NSTextAlignmentRight;
    totalAmtTotalLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    totalAmtTotalLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:totalAmtTotalLbl];
    
    UILabel *creditTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(57, CGRectGetMaxY(totalTitleLbl.frame) + 2, 110, 28)];
    creditTitleLbl.text=@"Available credit";
    creditTitleLbl.textColor=UIColorFromRGB(0x999999);
    creditTitleLbl.textAlignment=NSTextAlignmentLeft;
    creditTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    creditTitleLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:creditTitleLbl];
    
    creditBalanceLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(creditTitleLbl.frame),CGRectGetMinY(creditTitleLbl.frame), creditTitleLbl.frame.size.width +28 , 28)];
    creditBalanceLbl.textColor=UIColorFromRGB(0x999999);
    creditBalanceLbl.textAlignment=NSTextAlignmentRight;
    creditBalanceLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    creditBalanceLbl.backgroundColor=[UIColor clearColor];
    [debitCreditView addSubview:creditBalanceLbl];
    
    checkoutView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(debitCreditView.frame), contentView.frame.size.width, 70)];
    checkoutView.backgroundColor= UIColorFromRGB(0xF5F5F5);
    [contentView addSubview:checkoutView];
    
    checksOutSubView = [[UIView alloc] initWithFrame:CGRectMake(50, 15, 221, 40)];
    checksOutSubView.backgroundColor=UIColorFromRGB(0xDbDbDb);
    [checkoutView addSubview:checksOutSubView];
    
    alertView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(checkoutView.frame), contentView.frame.size.width, 132)];
    alertView.backgroundColor=[UIColor clearColor];
    [contentView addSubview:alertView];
    
    alertLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,alertView.frame.size.width,37)];
    alertLbl.textColor=UIColorFromRGB(0x999999);
    alertLbl.textAlignment=NSTextAlignmentCenter;
    alertLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
    alertLbl.backgroundColor=[UIColor clearColor];
    
    scrollView.contentSize=CGSizeMake(baseViewWidth,CGRectGetMaxY(alertView.frame));
    
    errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    [errorView setBackgroundColor:[UIColor whiteColor]];
    [baseView addSubview:errorView];
    
    UILabel *errorLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100)];
    [errorLbl setTextAlignment:NSTextAlignmentCenter];
    [errorLbl setTextColor:[UIColor lightGrayColor]];
    [errorLbl setText:@"No items in cart."];
    [errorView addSubview:errorLbl];
    
    numberFormatter = [TuplitConstants getCurrencyFormat];
    
    if (numberOfCell != 0 )
    {
        cartSwipe=[[CVSwipe alloc] initWithFrame:CGRectMake(0, 0, 221, 40) withImage:[UIImage imageNamed:@"green_cart"]];
    }
    else
    {
        cartSwipe=[[CVSwipe alloc] initWithFrame:CGRectMake(0, 0, 221, 40) withImage:[UIImage imageNamed:@"grey_cart"]];
        [alertView addSubview:alertLbl];
    }
    
    cartSwipe.backgroundColor=[UIColor clearColor];
    [cartSwipe setDelegate:self];
    [checksOutSubView addSubview:cartSwipe];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    [self updateCart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UserDefined methods

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) callWebserviceForLocationMatch {
    
    NETWORK_TEST_PROCEDURE
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:APP_DELEGATE.window];
    
    NSString *lat = [NSString stringWithFormat:@"%lf",[CurrentLocation latitude]];
    NSString *lon = [NSString stringWithFormat:@"%lf",[CurrentLocation longitude]];
    
    TLCheckLocationManager *checkLocationManager = [[TLCheckLocationManager alloc] init];
    checkLocationManager.delegate = self;
    [checkLocationManager callCheckLocationWithMerchantId:APP_DELEGATE.cartModel.merchantID latitude:lat longitude:lon];
}


- (void) callWebserviceForCurrentBalance {
    
    if(APP_DELEGATE.cartModel.total > [TLUserDefaults getCurrentUser].AvailableBalance.doubleValue)
    {
        [UIAlertView alertViewWithTitle:LString(@"TUPLIT") message:@"Insufficient balance" cancelButtonTitle:LString(@"CANCEL") otherButtonTitles:[NSArray arrayWithObject:@"Topup"] onDismiss:^(int buttonIndex)
         {
             
             TLTopUpViewController *topupVC = [[TLTopUpViewController alloc] init];
             topupVC.viewController = self;
             [self.navigationController pushViewController:topupVC animated:YES];
             
         }
                               onCancel:^()
         {
             
         }];
        [[ProgressHud shared] hide];
    }
    else
    {
       [self callWebserviceForLocationMatch];
    }
    
//    TLCheckBalanceManager *checkBalanceManager = [[TLCheckBalanceManager alloc] init];
//    checkBalanceManager.delegate = self;
//    [checkBalanceManager getCurrentBalanceWithPaymentAmount:[NSString stringWithFormat:@"%lf",APP_DELEGATE.cartModel.total]];
}

- (void) callWebserviceForOrderItems {
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:APP_DELEGATE.window];
    
    NSMutableArray *cartArray = [[NSMutableArray alloc]init];
    
    for(SpecialProductsModel *specModel in APP_DELEGATE.cartModel.products)
    {
        NSMutableDictionary *cartDict = [[NSMutableDictionary alloc]init];
        [cartDict setValue:specModel.ProductId forKey:@"ProductId"];
        [cartDict setValue:specModel.quantity forKey:@"ProductsQuantity"];
        [cartDict setValue:specModel.Price forKey:@"ProductsCost"];
        if (specModel.DiscountPrice.doubleValue == 0.0) {
            [cartDict setValue:specModel.Price forKey:@"DiscountPrice"];
        }
        else
        {
            [cartDict setValue:specModel.DiscountPrice forKey:@"DiscountPrice"];
        }
        [cartDict setValue:specModel.ItemName forKey:@"ItemName"];
        
        [cartArray addObject:cartDict];
    }
    
    NSDictionary *queryParams=[NSDictionary dictionaryWithObjectsAndKeys:[TLUserDefaults getCurrentUser].UserId,@"UserId",@"1",@"OrderDoneBy",[NSNumber numberWithInteger:APP_DELEGATE.cartModel.products.count],@"TotalItems",[NSNumber numberWithDouble:APP_DELEGATE.cartModel.discountedTotal],@"TotalPrice",@"",@"TransactionId",APP_DELEGATE.cartModel.merchantID,@"MerchantId",[cartArray JSONRepresentation],@"CartDetails",nil];
    
    TLCreateOrdersManager *createOrdersManager = [[TLCreateOrdersManager alloc] init];
    createOrdersManager.delegate = self;
    [createOrdersManager addOrders:queryParams];
}

-(void) updateCart {
    
    if (APP_DELEGATE.cartModel.products.count == 0) {
        errorView.hidden = NO;
        APP_DELEGATE.cartModel = [[CartModel alloc] init];
    }
    else
    {
        errorView.hidden = YES;
    }
    
    numberOfCell=APP_DELEGATE.cartModel.products.count;
    tableHeight=numberOfCell * CART_CELL_HEIGHT;
    
    itemArray = APP_DELEGATE.cartModel.products;
    
    [itemsListTable reloadData];
    
    [APP_DELEGATE.cartModel calculateSubtotalPrice];
    [APP_DELEGATE.cartModel calculateVatPrice];
    [APP_DELEGATE.cartModel calculateTotalPrice];
    
    itemsListTable.frame = CGRectMake(0,0, contentView.frame.size.width, tableHeight);
    debitCreditView.frame = CGRectMake(0,CGRectGetMaxY(itemsListTable.frame), contentView.frame.size.width,150);
    checkoutView.frame = CGRectMake(0, CGRectGetMaxY(debitCreditView.frame), contentView.frame.size.width, 70);
    alertView.frame = CGRectMake(0, CGRectGetMaxY(checkoutView.frame), contentView.frame.size.width, 132);
    
    discountAmtTotalLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.discountedTotal]];
    float discountWidth = [discountAmtTotalLbl.text widthWithFont:discountAmtTotalLbl.font];
    discountAmtTotalLbl.frame = CGRectMake((baseViewWidth - discountWidth) - 5, 5, discountWidth, 28);
    
    fixedAmtTotalLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.subtotal]];
    float fixedAmttotalWidth = [fixedAmtTotalLbl.text widthWithFont:fixedAmtTotalLbl.font];
    fixedAmtTotalLbl.frame = CGRectMake((discountAmtTotalLbl.frame.origin.x - fixedAmttotalWidth) - 5, 5, fixedAmttotalWidth, 28);
    
    vatAmtTotalLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.vat]];
    float vatAmtTWidth = [vatAmtTotalLbl.text widthWithFont:vatAmtTotalLbl.font];
    vatAmtTotalLbl.frame = CGRectMake((baseViewWidth- vatAmtTWidth) - 5, vatAmtTotalLbl.yPosition, vatAmtTWidth, 28);
    
    totalAmtTotalLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.total]];
    float totalAmtTWidth = [totalAmtTotalLbl.text widthWithFont:totalAmtTotalLbl.font];
    totalAmtTotalLbl.frame = CGRectMake((baseViewWidth - totalAmtTWidth) - 5, totalAmtTotalLbl.yPosition, totalAmtTWidth, 28);
    
    
    creditBalanceLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[TLUserDefaults getCurrentUser].AvailableBalance doubleValue]]];
    float creditBalanceWidth = [creditBalanceLbl.text widthWithFont:creditBalanceLbl.font];
    creditBalanceLbl.frame = CGRectMake((baseViewWidth - creditBalanceWidth) - 5, creditBalanceLbl.yPosition, creditBalanceWidth, 28);
    
    [self checkingItemAvailable];
    
    scrollView.contentSize=CGSizeMake(baseViewWidth,CGRectGetMaxY(alertView.frame));
}

-(void) checkingItemAvailable
{
    
    if (itemArray.count > 0)
    {
        UIImage *thumbImage = [UIImage imageNamed:@"green_cart"];
        cartSwipe.swipeSlider.userInteractionEnabled=YES;
        alertLbl.text=@"";
        [cartSwipe setSliderImage:thumbImage];
        
    }
    else
    {
        UIImage *thumbImage = [UIImage imageNamed:@"grey_cart"];
        [cartSwipe setSliderImage:thumbImage];
        cartSwipe.swipeSlider.userInteractionEnabled=NO;
        [alertView addSubview:alertLbl];
        alertLbl.text=@"It seems like you are not in the store or you are too far.";
    }
    
}
#pragma mark - CartSwipeCellDelegates

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath
{
    if ([swipeIndexPath compare:indexPath] != NSOrderedSame)
    {
        CartSwipeCell *currentSwipeCell = (CartSwipeCell *)[itemsListTable cellForRowAtIndexPath:swipeIndexPath];
        [currentSwipeCell didSwipeLeftInCell:self];
    }
    swipeIndexPath = indexPath;
}

- (void) didPlusOrMinusPressed {
    
    [self updateCart];
}

#pragma mark - TableView Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CART_CELL_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    
    CartSwipeCell *cell = (CartSwipeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CartSwipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    SpecialProductsModel *specialProductModel = [itemArray objectAtIndex:indexPath.row];
    [cell updateRow:specialProductModel];
    
    return cell;
}

#pragma mark - CVSwipeProtocol Delegate

-(void) performAction
{
    if([TLUserDefaults getCurrentUser].Passcode.boolValue)
    {
        
        LAContext *context = [[LAContext alloc] init];
        NSError *error;
        BOOL isFingerSupported;
        
        
        isFingerSupported = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (isFingerSupported) {
            
            APP_DELEGATE.isSocialhandeled = YES;
//                            [[ProgressHud shared] showWithMessage:@"" inTarget:APP_DELEGATE.window];
//             show the authentication UI with our reason string
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"UNLOCK_ACCESS_TO_LOCKED_FATURE", nil) reply:
             ^(BOOL success, NSError *authenticationError) {
                 
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                      [[ProgressHud shared]hide];
//                                  });
                 
                 if (success) {
                     dispatch_async(dispatch_get_main_queue(),^{
                         [self callWebserviceForCurrentBalance];
                     });
                 }
                 else {
                     
                     if(authenticationError.code == -3)
                     {
                         TLPinCodeViewController *verifyPINVC = [[TLPinCodeViewController alloc]init];
                         verifyPINVC.isverifyPin = YES;
                         verifyPINVC.delegate = self;
                         verifyPINVC.navigationTitle = LString(@"ENTER_PIN_CODE");
                         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:verifyPINVC];
                         [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
                         [self presentViewController:nav animated:YES completion:nil];
                         [[ProgressHud shared]hide];
                         return;
                     }
                     else if(authenticationError.code == -2)
                     {
                         return;
                     }
                     else
                     {                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [UIAlertView alertViewWithMessage:@"There was a problem verifying your identity."];
                         });
                     }
                 }
                 
             }];
        } else {
            
            TLPinCodeViewController *verifyPINVC = [[TLPinCodeViewController alloc]init];
            verifyPINVC.isverifyPin = YES;
            verifyPINVC.delegate = self;
            verifyPINVC.navigationTitle = LString(@"ENTER_PIN_CODE");
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:verifyPINVC];
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else
    {
        //            [self callWebserviceForLocationMatch];
        [self callWebserviceForCurrentBalance];
    }
    
}

-(void)checkpass
{
   
}

#pragma mark - TLPinCodeVerifiedDelegate

-(void)pincodeVerified
{
//    [self callWebserviceForLocationMatch];
    [self callWebserviceForCurrentBalance];

}

#pragma mark - TLCheckLocationManager Delegates

- (void)checkLocationManagerSuccessfull:(TLCheckLocationManager *)checkLocationManager allowCart:(int)allowCart withMessage:(NSString*) message {
    
    if (allowCart == 1) {
        
        if([TuplitConstants isMerchantClosed:APP_DELEGATE.cartModel.openHrsArray])
        {
            [UIAlertView alertViewWithMessage:[NSString stringWithFormat:LString(@"MERCHANT_CLOSED"),APP_DELEGATE.cartModel.companyName]];
            [[ProgressHud shared] hide];
        }
        else
        {
            [self callWebserviceForOrderItems];
        }

    }
    else
    {
        [UIAlertView alertViewWithMessage:message];
        [[ProgressHud shared] hide];
    }
}

- (void)checkLocationManager:(TLCheckLocationManager *)checkLocationManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
//    [UIAlertView alertViewWithMessage:errorMsg];
    [[ProgressHud shared] hide];
}

- (void)checkLocationManagerFailed:(TLCheckLocationManager *)checkLocationManager {
    
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    [[ProgressHud shared] hide];
}

#pragma mark - TLCheckBalanceManager Delegates

- (void)checkBalanceManagerSuccessfull:(TLCheckBalanceManager *)checkBalanceManager paymentModel:(PaymentModel *)paymentModel {
    
    if([paymentModel.AllowPayment intValue] == 0) {
        [UIAlertView alertViewWithTitle:LString(@"TUPLIT") message:paymentModel.Message cancelButtonTitle:LString(@"CANCEL") otherButtonTitles:[NSArray arrayWithObject:@"Topup"] onDismiss:^(int buttonIndex)
         {
             
             TLTopUpViewController *topupVC = [[TLTopUpViewController alloc] init];
             topupVC.viewController = self;
             [self.navigationController pushViewController:topupVC animated:YES];
             
         }
                               onCancel:^()
         {
             
         }];
        
        [[ProgressHud shared] hide];
    }
    else
    {
        if([TuplitConstants isMerchantClosed:APP_DELEGATE.cartModel.openHrsArray])
        {
            [UIAlertView alertViewWithMessage:[NSString stringWithFormat:LString(@"MERCHANT_CLOSED"),APP_DELEGATE.cartModel.companyName]];
            [[ProgressHud shared] hide];
        }
        else
        {
            [self callWebserviceForOrderItems];
        }
    }
    
}

- (void)checkBalanceManager:(TLCheckBalanceManager *)checkBalanceManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)checkBalanceManagerFailed:(TLCheckBalanceManager *)checkBalanceManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma mark - TLCreateOrdersManager Delegates

- (void)createOrdersManagerSuccessfull:(TLCreateOrdersManager *)createOrdersManager orderId:(NSString*)orderID transactionID:(NSString*) transID {
    
    UserModel *userModel = [TLUserDefaults getCurrentUser];
    double balance = userModel.AvailableBalance.doubleValue;
    userModel.AvailableBalance = [NSString stringWithFormat:@"%lf",(balance - APP_DELEGATE.cartModel.total)];
    [TLUserDefaults setCurrentUser:userModel];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserData object:nil];
    
    CartDetailViewController *cartDetail=[[CartDetailViewController alloc]init];
    cartDetail.TransactionId = transID;
    cartDetail.OrderId = orderID;
    [self.navigationController pushViewController:cartDetail animated:YES];
    
    [[ProgressHud shared] hide];
}

- (void)createOrdersManager:(TLCreateOrdersManager *)createOrdersManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)createOrdersManagerFailed:(TLCreateOrdersManager *)createOrdersManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end

