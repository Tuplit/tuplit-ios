//
//  TLMerchantsDetailViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLMerchantsDetailViewController.h"

@interface TLMerchantsDetailViewController ()
{
    NSArray * detailSectionNamesArray;
    NSMutableArray * orderSectionNamesArray;
    NSMutableArray * modelsArray;
    UIImageView *backShadeImgView;
    UILabel *errorLbl;
    UIView *errorView;
    int favouriteType;
}

@end

@implementation TLMerchantsDetailViewController

#pragma mark - View life cycle methods.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)loadView
{
    [super loadView];
    
    // navigation controll
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn buttonWithIcon:getImage(@"back_arrow", NO) target:self action:@selector(backButtonAction) isLeft:YES];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    UIBarButtonItem * upLoadBtn = [[UIBarButtonItem alloc] init];
    [upLoadBtn buttonWithIcon:getImage(@"download.png", NO) target:self action:@selector(shareAction) isLeft:NO];
    [self.navigationItem setRightBarButtonItem:upLoadBtn];
    
    // Content Part
    baseViewWidth = self.view.frame.size.width;
    baseViewHeight = self.view.frame.size.height;
    
    int adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,baseViewHeight-adjustHeight)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,130)];
    containerView.backgroundColor = [UIColor lightGrayColor];
    [baseView addSubview:containerView];
    
    merchantImageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(0,0,containerView.size.width,containerView.size.height)];
    merchantImageView.backgroundColor = [UIColor clearColor];
    merchantImageView.tag = 101;
    [merchantImageView setContentMode:UIViewContentModeScaleAspectFit];
    [containerView addSubview:merchantImageView];
    
    UIImage * customerShoppedImage1 = getImage(@"shop_bag", NO);;
    UIImageView * customerShopedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,8 ,customerShoppedImage1.size.width, customerShoppedImage1.size.height)];
    customerShopedImageView.backgroundColor = [UIColor clearColor];
    customerShopedImageView.image = customerShoppedImage1;
    [containerView addSubview:customerShopedImageView];
    
    customerLabel = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(customerShopedImageView.frame)+4,6,250,15)];
    customerLabel.textColor = UIColorFromRGB(0Xffffff);
    customerLabel.backgroundColor = [UIColor clearColor];
    customerLabel.font= [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    customerLabel.userInteractionEnabled = YES;
//    customerLabel.numberOfLines= 3;
    customerLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    customerLabel.textAlignment= NSTextAlignmentLeft;
    [containerView addSubview : customerLabel];
    
    UIImageView * customerShopedImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(8,CGRectGetMaxY(customerLabel.frame)+2 ,customerShoppedImage1.size.width, customerShoppedImage1.size.height)];
    customerShopedImageView1.backgroundColor = [UIColor clearColor];
    customerShopedImageView1.image = customerShoppedImage1;
    [containerView addSubview:customerShopedImageView1];
    
    specialSoldLabel = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(customerShopedImageView.frame)+4,CGRectGetMaxY(customerLabel.frame),250,15)];
    specialSoldLabel.textColor = UIColorFromRGB(0Xffffff);
    specialSoldLabel.backgroundColor = [UIColor clearColor];
    specialSoldLabel.font= [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    specialSoldLabel.userInteractionEnabled = YES;
//    specialSoldLabel.numberOfLines= 3;
    specialSoldLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    specialSoldLabel.textAlignment= NSTextAlignmentLeft;
    [containerView addSubview : specialSoldLabel];
    
    labelDiscount = [[UILabel alloc ] initWithFrame:CGRectMake(CGRectGetMaxX(containerView.frame)-35,6,30,14)];
    [labelDiscount setUpLabelCommonStyle];
    labelDiscount.textColor = UIColorFromRGB(0Xffffff);
    labelDiscount.font= [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [containerView addSubview:labelDiscount];
    
    UIImage* discountImage = getImage(@"DiscountMap",NO);
    discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(labelDiscount.frame)-discountImage.size.width - 3 ,6,discountImage.size.width, discountImage.size.height)];
    discountImageView.backgroundColor = [UIColor clearColor];
//    discountImageView.image= discountImage;
    [containerView addSubview:discountImageView];
    
    backShadeImgView = [[UIImageView alloc]initWithFrame:CGRectMake((containerView.frame.size.width-68)/2,(containerView.frame.size.height-68)/3,68,68)];
    backShadeImgView.backgroundColor = [UIColor clearColor];
    backShadeImgView.image = getImage(@"shade", NO);
    backShadeImgView.hidden = YES;
    [containerView addSubview:backShadeImgView];
    
    merchantLogoView=[[EGOImageView alloc]initWithPlaceholderImage:nil imageViewFrame:CGRectMake((containerView.frame.size.width-60)/2,(containerView.frame.size.height-60)/3,60,60)];
    merchantLogoView.backgroundColor = [UIColor clearColor];
    merchantLogoView.layer.cornerRadius = 30;
    merchantLogoView.clipsToBounds = YES;
    [containerView addSubview:merchantLogoView];
    
    // OrderedFriends details
    UIView *friendsListView = [[UIView alloc]initWithFrame:CGRectMake(0, containerView.frame.size.height-35, containerView.frame.size.width, 31)];
    [friendsListView setBackgroundColor:[UIColor clearColor]];
    [containerView addSubview:friendsListView];
    
    friendsLabel= [[UILabel alloc ] initWithFrame:CGRectMake(9,0,180,30)];
    friendsLabel.textColor= UIColorFromRGB(0Xffffff);
    friendsLabel.backgroundColor = [UIColor clearColor];
    friendsLabel.font= [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    friendsLabel.userInteractionEnabled = YES;
    friendsLabel.numberOfLines = 3;
    friendsLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    friendsLabel.textAlignment= NSTextAlignmentLeft;
    [friendsListView addSubview : friendsLabel];
    
    friendsImgView1=[[EGOImageView alloc]initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake(CGRectGetMaxX(friendsLabel.frame)+30,5,25,25)];
    friendsImgView1.tag = 200;
    friendsImgView1.backgroundColor = [UIColor clearColor];
    friendsImgView1.layer.cornerRadius = 12.5;
    friendsImgView1.clipsToBounds = YES;
    friendsImgView1.userInteractionEnabled = YES;
    friendsImgView1.hidden = YES;
    UITapGestureRecognizer *friendsImgGesture1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOtherUserDetails:)];
    [friendsImgView1 addGestureRecognizer:friendsImgGesture1];
    [friendsListView addSubview:friendsImgView1];
    
    friendsImgView2=[[EGOImageView alloc]initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake(CGRectGetMaxX(friendsLabel.frame)+60,5,25,25)];
    friendsImgView2.tag = 201;
    friendsImgView2.backgroundColor = [UIColor clearColor];
    friendsImgView2.layer.cornerRadius = 12.5;
    friendsImgView2.clipsToBounds = YES;
    friendsImgView2.userInteractionEnabled = YES;
    friendsImgView2.hidden=YES;
    UITapGestureRecognizer *friendsImgGesture2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOtherUserDetails:)];
    [friendsImgView2 addGestureRecognizer:friendsImgGesture2];
    [friendsListView addSubview:friendsImgView2];
    
    friendsImgView3=[[EGOImageView alloc]initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake(CGRectGetMaxX(friendsLabel.frame)+90,5,25,25)];
    friendsImgView3.tag = 202;
    friendsImgView3.backgroundColor = [UIColor clearColor];
    friendsImgView3.layer.cornerRadius = 12.5;
    friendsImgView3.clipsToBounds = YES;
    friendsImgView3.userInteractionEnabled = YES;
    friendsImgView3.hidden = YES;
    UITapGestureRecognizer *friendsImgGesture3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOtherUserDetails:)];
    [friendsImgView3 addGestureRecognizer:friendsImgGesture3];
    [friendsListView addSubview:friendsImgView3];
    
    //Menu Bar
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(containerView.frame), baseView.frame.size.width, 34)];
    [menuView setBackgroundColor:[UIColor clearColor]];
    [menuView setUserInteractionEnabled:YES];
    [baseView addSubview:menuView];
    
    detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailsButton.tag = 101;
    [detailsButton addTarget:self action:@selector(buttonDetailOrderAction:) forControlEvents:UIControlEventTouchDown];
    [detailsButton setTitle:@"Details" forState:UIControlStateNormal];
    detailsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    detailsButton.frame = CGRectMake(0,0, baseViewWidth/2, 35);
    detailsButton.backgroundColor = UIColorFromRGB(0X01b3a5);
    [detailsButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [menuView addSubview:detailsButton];
    
    orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.tag = 102;
    [orderButton addTarget:self action:@selector(buttonDetailOrderAction:) forControlEvents:UIControlEventTouchDown];
    [orderButton setTitle:@"Order" forState:UIControlStateNormal];
    orderButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    orderButton.frame = CGRectMake(CGRectGetMaxX(detailsButton.frame),0,baseViewWidth/2, 35);
    orderButton.backgroundColor = UIColorFromRGB(0X01b3a5);
    [orderButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [menuView addSubview:orderButton];
    
    merchantDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(menuView.frame),baseViewWidth,baseViewHeight-CGRectGetMaxY(menuView.frame)-adjustHeight)style:UITableViewStylePlain];
    [merchantDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    merchantDetailTable.dataSource = self;
    merchantDetailTable.delegate= self;
    merchantDetailTable.delaysContentTouches = NO;
    merchantDetailTable.tag= 103;
    [merchantDetailTable reloadData];
    [baseView addSubview:merchantDetailTable];
    
    [merchantDetailTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, merchantDetailTable.frame.size.width, 50)]];
    
    cartBarView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(merchantDetailTable.frame)-50, CGRectGetWidth(merchantDetailTable.frame), 50)];
    cartBarView.backgroundColor = UIColorFromRGB(0x00b3a4);
    cartBarView.hidden = YES;
    [baseView addSubview:cartBarView];
    
    UIImage *cartBagImg = getImage(@"bag", NO);
    UIImageView *cartBagImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (50-cartBagImg.size.height)/2, cartBagImg.size.width, cartBagImg.size.height)];
    cartBagImgView.image = cartBagImg;
    cartBagImgView.backgroundColor = [UIColor clearColor];
    [cartBarView addSubview:cartBagImgView];
    
    cartItemCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cartBagImgView.frame)+10,(CGRectGetHeight(cartBarView.frame)-25)/2, 80, 25)];
    cartItemCountLbl.backgroundColor = [UIColor clearColor];
    cartItemCountLbl.textColor = UIColorFromRGB(0xffffff);
    cartItemCountLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [cartBarView addSubview:cartItemCountLbl];
    
    UIButton *checkoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(cartBarView.frame)- 50 - 15, (CGRectGetHeight(cartBarView.frame)-30)/2, 50, 30)];
    [checkoutBtn addTarget:self action:nil forControlEvents:UIControlEventTouchDown];
    [checkoutBtn setBackgroundColor:UIColorFromRGB(0xC2FEF9)];
    [checkoutBtn setTitle:@"Cart" forState:UIControlStateNormal];
    checkoutBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    [checkoutBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
    [checkoutBtn addTarget:self action:@selector(openCartPage) forControlEvents:UIControlEventTouchUpInside];
    [cartBarView addSubview:checkoutBtn];
    
    totItemPrizeLbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(checkoutBtn.frame)-25-5, (CGRectGetHeight(cartBarView.frame)-25)/2, 40, 25)];
    totItemPrizeLbl.backgroundColor = [UIColor clearColor];
    totItemPrizeLbl.textColor = UIColorFromRGB(0xffffff);
    totItemPrizeLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12];;
    [cartBarView addSubview:totItemPrizeLbl];
  
//  error handling
    errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, merchantDetailTable.frame.size.width, merchantDetailTable.frame.size.height-10)];
    [errorView setBackgroundColor:[UIColor whiteColor]];
     errorView.hidden=YES;
    [merchantDetailTable addSubview:errorView];
    
    errorLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (errorView.frame.size.height - 100)/2, errorView.frame.size.width - 20, 100)];
    [errorLbl setTextAlignment:NSTextAlignmentCenter];
    [errorLbl setTextColor:[UIColor lightGrayColor]];
    errorLbl.text =LString(@"NO_ITEM_FOUND");
    errorLbl.numberOfLines = 0;
    [errorView addSubview:errorLbl];
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
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
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    [self buttonDetailOrderAction:detailsButton];
    [self callMerchantDetailsWebservice];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
  
-(void) callMerchantDetailsWebservice
{
    if(self.merchantModel)
        self.detailsMerchantID = self.merchantModel.MerchantID;
    
    NETWORK_TEST_PROCEDURE
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLMerchantListingModel *merchantListingModel = [[TLMerchantListingModel alloc] init];
    merchantListingModel.Latitude = [NSString stringWithFormat:@"%lf",[CurrentLocation latitude]];
    merchantListingModel.Longitude = [NSString stringWithFormat:@"%lf",[CurrentLocation longitude]];
    merchantListingModel.UserID = [TLUserDefaults getCurrentUser].UserId;
    merchantListingModel.MerchantID = self.detailsMerchantID;
    
    TLMerchantDetailsManager * MDetailsObject = [[TLMerchantDetailsManager alloc] init];
    MDetailsObject.delegate = self;
    [MDetailsObject callService:merchantListingModel];
}

-(void)callAddToFavouriteServiceWith
{
    if([TLUserDefaults isGuestUser])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"You need to login in the app to do the purchase. Would you like to register?" delegate:self cancelButtonTitle:LString(@"NO") otherButtonTitles:@"YES", nil];
        alertView.tag = 9002;
        [alertView show];
    }
    else
    {
        NETWORK_TEST_PROCEDURE
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        
        NSDictionary *queryParams = @{
                                      @"MerchantId": NSNonNilString(merchantdetailmodel.MerchantId),
                                      @"FavouriteType": NSNonNilString([NSString stringWithFormat:@"%d",!favouriteType]),
                                      };
        TLAddFavouriteManager *addToFavourite = [[TLAddFavouriteManager alloc]init];
        addToFavourite.delegate = self;
        [addToFavourite callService:queryParams];
    }
}

-(void) openCartPage {
    
    TLCartViewController *cartVC = [[TLCartViewController alloc] init];
    UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:cartVC];
    [slideNavigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [slideNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
}

-(void) updateCartView
{
    [UIView transitionWithView:cartBarView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];

    cartBarView.hidden = NO;
    
    [APP_DELEGATE.cartModel calculateTotalPrice];
    
    cartItemCountLbl.text = [NSString stringWithFormat:@"%d item(s) in cart",APP_DELEGATE.cartModel.products.count];;
    float cartLblWidth = [cartItemCountLbl.text widthWithFont:cartItemCountLbl.font];
    CGRect tempRect = cartItemCountLbl.frame;
    tempRect.size.width = cartLblWidth;
    cartItemCountLbl.frame =tempRect;
    
    
    totItemPrizeLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:APP_DELEGATE.cartModel.discountedTotal]];
    float prizeLblWidth = [totItemPrizeLbl.text widthWithFont:totItemPrizeLbl.font];
    CGRect tempRect1 = cartItemCountLbl.frame;
    tempRect1.origin.x = CGRectGetWidth(cartBarView.frame) - 70 - prizeLblWidth;
    tempRect1.size.width = prizeLblWidth;
    totItemPrizeLbl.frame = tempRect1;
    
}

- (void) buttonDetailOrderAction:(UIButton*) button
{
    if (button.tag==101)
    {
        errorView.hidden=YES;
        isDetailButton = YES;
        [orderButton setBackgroundImage:getImage(@"ButtonLightBg",NO) forState:UIControlStateNormal];
        [orderButton setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        orderButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        [detailsButton setBackgroundImage:Nil forState:UIControlStateNormal];
        [detailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        
    }
    else
    {
        isDetailButton = NO;
        [detailsButton setBackgroundImage:getImage(@"ButtonLightBg",NO) forState:UIControlStateNormal];
        [detailsButton setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        detailsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        [orderButton setBackgroundImage:Nil forState:UIControlStateNormal];
        [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        
        if(orderSectionNamesArray.count==1)
        {
            NSString *keyString = [orderSectionNamesArray objectAtIndex:0];
            if( [[orderedMainDict valueForKey:keyString] count]==0)
            {
                errorView.hidden=NO;
            }
        }
    }

    [merchantDetailTable reloadData];
    
    //   Set visible to top in merchantDetailTable
    [self scrollToTop];
}

-(void)updateMerchantDetails
{
    [self.navigationItem setTitle:[merchantdetailmodel.CompanyName stringWithTitleCase]];
    
    merchantImageView.imageURL = [NSURL URLWithString:merchantdetailmodel.Image];
    labelDiscount.text  = merchantdetailmodel.DiscountTier;
    merchantLogoView.imageURL = [NSURL URLWithString:merchantdetailmodel.Icon];
    backShadeImgView.hidden = NO;
    favouriteType = merchantdetailmodel.AlreadyFavourited.intValue;
    
    if(merchantdetailmodel.IsGoldenTag.intValue)
        discountImageView.image = getImage(@"specialIcon",NO);
    else
        discountImageView.image = getImage(@"DiscountMap",NO);
    
    if (merchantdetailmodel.CustomersCount != nil)
    {
        customerLabel.text = [NSString stringWithFormat:@"%@ Customers shopped here",merchantdetailmodel.CustomersCount];
        
        if (merchantdetailmodel.SpecialsSold.intValue >1) {
            specialSoldLabel.text = [NSString stringWithFormat:@"%@ Specials sold",merchantdetailmodel.SpecialsSold];
        }
        else
        {
            specialSoldLabel.text = [NSString stringWithFormat:@"%@ Special sold",merchantdetailmodel.SpecialsSold];
        }
        
        if (merchantdetailmodel.CustomersCount.intValue >1) {
            customerLabel.text = [NSString stringWithFormat:@"%@ Customers shopped here",merchantdetailmodel.CustomersCount];
        }
        else
        {
            customerLabel.text = [NSString stringWithFormat:@"%@ Customer shopped here",merchantdetailmodel.CustomersCount];
        }
    }
    
    // friends maintains
    int orderedFriendsCount = merchantdetailmodel.OrderedFriendsCount.intValue;
    if(orderedFriendsCount==1)
    {
        FriendsListModel *friendModel3 =[merchantdetailmodel.OrderedFriendsList objectAtIndex:0];
        
        if([friendModel3.Id isEqualToString:[TLUserDefaults getCurrentUser].UserId])
            friendsLabel.text =[NSString stringWithFormat:@"You shopped here!"];
        else
            friendsLabel.text =[NSString stringWithFormat:@"%@ %@ shopped here!",friendModel3.FirstName,friendModel3.LastName];
        
        friendsImgView3.imageURL = [NSURL URLWithString:friendModel3.Photo];
        friendsImgView1.hidden = YES;
        friendsImgView2.hidden = YES;
        friendsImgView3.hidden = NO;
    }
    else  if(orderedFriendsCount==2)
    {
        FriendsListModel *friendModel3 =[merchantdetailmodel.OrderedFriendsList objectAtIndex:0];
        FriendsListModel *friendModel2 =[merchantdetailmodel.OrderedFriendsList objectAtIndex:1];
        
        if([friendModel3.Id isEqualToString:[TLUserDefaults getCurrentUser].UserId])
            friendsLabel.text =[NSString stringWithFormat:@"You & %@ %@ shopped here!",[friendModel2.FirstName stringWithTitleCase],[friendModel2.LastName stringWithTitleCase]];
        else if([friendModel2.Id isEqualToString:[TLUserDefaults getCurrentUser].UserId])
            friendsLabel.text =[NSString stringWithFormat:@"You & %@ %@ shopped here!",[friendModel3.FirstName stringWithTitleCase],[friendModel3.LastName stringWithTitleCase]];
        else
            friendsLabel.text =[NSString stringWithFormat:@"%@ %@ & %@ %@ shopped here!",[friendModel3.FirstName stringWithTitleCase],[friendModel3.LastName stringWithTitleCase],[friendModel2.FirstName stringWithTitleCase],[friendModel2.LastName stringWithTitleCase]];
        
        friendsImgView3.imageURL = [NSURL URLWithString:friendModel3.Photo];
        friendsImgView2.imageURL = [NSURL URLWithString:friendModel2.Photo];
        
        friendsImgView1.hidden = YES;
        friendsImgView2.hidden = NO;
        friendsImgView3.hidden = NO;
    }
    else  if(orderedFriendsCount>2)
    {
        FriendsListModel *friendModel1 =[merchantdetailmodel.OrderedFriendsList objectAtIndex:2];
        FriendsListModel *friendModel2 =[merchantdetailmodel.OrderedFriendsList objectAtIndex:1];
        FriendsListModel *friendModel3 =[merchantdetailmodel.OrderedFriendsList objectAtIndex:0];
        
        NSString *checkplural;
        if(orderedFriendsCount==3)
            checkplural = @"friend shopped here!";
        else
            checkplural = @"friends shopped here!";
            
        if([friendModel3.Id isEqualToString:[TLUserDefaults getCurrentUser].UserId])
            friendsLabel.text =[NSString stringWithFormat:@"You, %@ %@ & another %d %@",[friendModel2.FirstName stringWithTitleCase],[friendModel2.LastName stringWithTitleCase],orderedFriendsCount-2,checkplural];
        else if([friendModel2.Id isEqualToString:[TLUserDefaults getCurrentUser].UserId])
            friendsLabel.text =[NSString stringWithFormat:@"You, %@ %@ & another %d %@",[friendModel3.FirstName stringWithTitleCase],[friendModel3.LastName stringWithTitleCase],orderedFriendsCount-2,checkplural];
        else if([friendModel1.Id isEqualToString:[TLUserDefaults getCurrentUser].UserId])
            friendsLabel.text =[NSString stringWithFormat:@"You, %@ %@ & another %d %@",[friendModel3.FirstName stringWithTitleCase],[friendModel3.LastName stringWithTitleCase],orderedFriendsCount-2,checkplural];
        else
            friendsLabel.text =[NSString stringWithFormat:@"%@ %@, %@ %@ & another %d %@",[friendModel3.FirstName stringWithTitleCase],[friendModel3.LastName stringWithTitleCase],[friendModel2.FirstName stringWithTitleCase],[friendModel2.LastName stringWithTitleCase],orderedFriendsCount-2,checkplural];
        
        friendsImgView1.imageURL = [NSURL URLWithString:friendModel1.Photo];
        friendsImgView2.imageURL = [NSURL URLWithString:friendModel2.Photo];
        friendsImgView3.imageURL = [NSURL URLWithString:friendModel3.Photo];
        
        friendsImgView1.hidden = NO;
        friendsImgView2.hidden = NO;
        friendsImgView3.hidden = NO;
    }
    else  if(orderedFriendsCount==0)
    {
        friendsImgView1.hidden = YES;
        friendsImgView2.hidden = YES;
        friendsImgView3.hidden = YES;
        friendsLabel.hidden = YES;
    }
    
    [merchantDetailTable reloadData];
    
    if ([APP_DELEGATE.cartModel.merchantID isEqualToString:merchantdetailmodel.MerchantId]) {
        
        [self updateCartView];
    }
    else{
        
        [UIView transitionWithView:cartBarView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        
        cartBarView.hidden = YES;
    }
}

-(void)openFavouriteList
{
    TLFavouriteListViewController *favouriteListVC = [[TLFavouriteListViewController alloc]init];
    [self.navigationController pushViewController:favouriteListVC animated:YES];
}

-(void)openOtherUserDetails:(UITapGestureRecognizer *)gesture
{
    if ([TLUserDefaults isGuestUser]) {
        return;
    }
    
    EGOImageView *imgView = (EGOImageView*)gesture.view;
    
    NSString *userID;
    if(imgView.tag == 5001)
    {
        UITableViewCell *cell = (UITableViewCell *)[gesture view].superview.superview.superview;
        NSIndexPath *indexPath = [merchantDetailTable indexPathForCell:cell];
        
        NSString *keyString = [detailSectionNamesArray objectAtIndex:indexPath.section];
        CommentsModel *cmtdata = [[detailMainDict valueForKey:keyString] objectAtIndex:indexPath.row];
        NSLog(@"%@",cmtdata.UsersId);
        userID = cmtdata.UsersId;
    }
   
    else
    {
        int index;
        if(imgView.tag == 202)
            index = 0;
        else if(imgView.tag == 201)
            index =  1;
        else
            index = 2;

          FriendsListModel *friendModel =[merchantdetailmodel.OrderedFriendsList objectAtIndex:index];
        userID = friendModel.Id;
       
    }
    
    if([userID isEqualToString:[TLUserDefaults getCurrentUser].UserId])
    {
        TLUserProfileViewController *userProfile = [[TLUserProfileViewController alloc]init];
        [self.navigationController pushViewController:userProfile animated:YES];
    }
    else
    {
        TLOtherUserProfileViewController *otherUserProfile = [[TLOtherUserProfileViewController alloc]init];
        otherUserProfile.userID = userID;
        [self.navigationController pushViewController:otherUserProfile animated:YES];
    }
}

-(void) addToCart:(UIButton*) sender {
    
    selectedCartButton = sender;
    
    if ([TLUserDefaults getCurrentUser] == nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"You need to login in the app to do the purchases. Would you like to register?" delegate:self cancelButtonTitle:LString(@"NO") otherButtonTitles:LString(@"YES"), nil];
        alertView.tag = 9001;
        [alertView show];
        
        return;
    }
    
    if (!isAllowCartEnabled) {
        
        [UIAlertView alertViewWithMessage:@"Your location is too far to order this item."];
        
        return;
    }
    
    if ([APP_DELEGATE.cartModel.merchantID isEqualToString:@""]) {
        
        // Dont handle anything
    }
    else if (![APP_DELEGATE.cartModel.merchantID isEqualToString:merchantdetailmodel.MerchantId]) {
     
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"You can purchase items from one merchant at a time. Would you like to remove all the items in the cart?" delegate:self cancelButtonTitle:LString(@"NO") otherButtonTitles:LString(@"YES"), nil];
        alertView.tag = 9000;
        [alertView show];
        
        return;
    }
    
    APP_DELEGATE.cartModel.merchantID = merchantdetailmodel.MerchantId;
    APP_DELEGATE.cartModel.companyName = [merchantdetailmodel.CompanyName stringWithTitleCase];
    APP_DELEGATE.cartModel.address = merchantdetailmodel.Address;
    APP_DELEGATE.cartModel.latitude = merchantdetailmodel.Latitude.doubleValue;
    APP_DELEGATE.cartModel.longitude = merchantdetailmodel.Longitude.doubleValue;
    
    CGPoint buttonOrigin = [sender frame].origin;
    CGPoint pointInTableview = [merchantDetailTable convertPoint:buttonOrigin fromView:[sender superview]];
    NSIndexPath *indexPath = [merchantDetailTable indexPathForRowAtPoint:pointInTableview];
    
    SpecialProductsModel *specialProduct;
    
    if(isDetailButton)
    {
        specialProduct = [[detailMainDict valueForKey:[detailSectionNamesArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    else
    {
        specialProduct = [[orderedMainDict valueForKey:[orderSectionNamesArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    [APP_DELEGATE.cartModel addItems:specialProduct];
    [self updateCartView];
}

-(void) scrollToTop
{
    if ([self numberOfSectionsInTableView:merchantDetailTable] > 0)
    {
       merchantDetailTable.contentOffset = CGPointMake(0, 0 -merchantDetailTable.contentInset.top);
    }
}

-(void)phoneNumCallAction
{
    NSString *phoneString =  [TuplitConstants formatPhoneNumber:merchantdetailmodel.PhoneNumber];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:phoneString delegate:self cancelButtonTitle:LString(@"CANCEL") otherButtonTitles:LString(@"Call"), nil];
    alertView.tag = 9010;
    [alertView show];
}
-(void)openWebUrlAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:merchantdetailmodel.WebsiteUrl]];
}

-(void)shareAction
{
    NSString *subject = [NSString stringWithFormat:@"I found good deals and specials in the %@ on tuplit iPhone app",merchantdetailmodel.CompanyName];
    NSString *textToShare = [NSString stringWithFormat:@"Hey, I found good deals and specials in the %@ on tuplit iPhone app. Link to tuplit app: %@",merchantdetailmodel.CompanyName,[TLUserDefaults getItunesURL]];
    
    NSArray *objectsToShare = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [activityVC setValue:subject forKey:@"subject"];
    NSArray *excludeActivities;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    else
        excludeActivities = @[UIActivityTypePrint,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeSaveToCameraRoll,
                            ];
    
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isDetailButton)
        return [detailSectionNamesArray count];
    else
        return [orderSectionNamesArray count];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isDetailButton)
    {
        NSString *keyString = [detailSectionNamesArray objectAtIndex:section];
        
        if (section == 1 || section == detailSectionNamesArray.count - 1) {
            return [[detailMainDict valueForKey:keyString] count];
        }
        else
            return 1;
    }
    else
    {
        NSString *keyString = [orderSectionNamesArray objectAtIndex:section];
        return [[orderedMainDict valueForKey:keyString] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isDetailButton)
    {
        if (indexPath.section==0)
        {
            float shortheight;
            float stringHeight = [merchantdetailmodel.Description heigthWithWidth:285 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
           
            if(merchantdetailmodel.CategoryList.count==0)
                shortheight = [merchantdetailmodel.ShortDescription heigthWithWidth:130 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            else
                return stringHeight + 35;

            return stringHeight + shortheight+ 16;
        }
        
        else if (indexPath.section==1)
            return 50;
        
        else if (indexPath.section==2){
            
            NSString *addressStr = [NSString stringWithFormat:@"%@\n%@\n%@",merchantdetailmodel.Address,merchantdetailmodel.PhoneNumber,merchantdetailmodel.WebsiteUrl];
            float stringHeight = [addressStr heigthWithWidth:150 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            if(stringHeight > 80)
                return stringHeight + 30 + 15;
            else
                return 115;

        }
        else if (indexPath.section==3)
        {
            OpeningHoursModel *openingHrsModel = [merchantdetailmodel.OpeningHours objectAtIndex:0];
            
            if(openingHrsModel.Open.count == 0)
                return 75;
            else {
                
                float height = 30 + (openingHrsModel.Open.count * 15);
                if (height > 75) {
                    return height;
                }
                else{
                    return 75;
                }
            }
        }
        else if (indexPath.section == 4) {
            
            CommentsModel *cmtDetails = [[detailMainDict valueForKey:@"Customer's Comments"] objectAtIndex:indexPath.row];
            float cmtLblHeight = [cmtDetails.CommentsText heigthWithWidth:self.view.frame.size.width-120 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            return cmtLblHeight + 25;
        }
        else
            return 60;
    }
    else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isDetailButton)
    {
        if (section ==1 || section == detailSectionNamesArray.count - 1)
        {
            if ([[detailMainDict valueForKey:[detailSectionNamesArray objectAtIndex:section]] count] > 0) {
                return 30;
            }
            else
            {
                return 0;
            }
        }
        else
            return 0;
    }
    else{
        
        if ([[orderedMainDict valueForKey:[orderSectionNamesArray objectAtIndex:section]] count] > 0) {
            return 30;
        }
        else
        {
            return 0;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width - 20, view.frame.size.height)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [label setTextColor:UIColorFromRGB(0x00b3a4)];
    [label setBackgroundColor:[UIColor clearColor]];
    
    NSString *headerTitle;
    if(isDetailButton)
        headerTitle = [detailSectionNamesArray objectAtIndex:section];
    else
        headerTitle = [orderSectionNamesArray objectAtIndex:section];
    
    [label setText:headerTitle];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isDetailButton)
    {
        static NSString *CellIdentifier[] = {@"Description",@"Specials",@"Address",@"OpenAndPrice",@"Commments",nil};
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier[indexPath.section]];
        
        CGFloat dummyViewHeight = 40;
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, dummyViewHeight)];
        tableView.tableHeaderView = dummyView;
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier[indexPath.section]];
            cell.selectionStyle = UITableViewCellStyleDefault;
            cell.backgroundColor = [UIColor clearColor];
            
            if (indexPath.section == 0)
            {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
                [categoryView setBackgroundColor:[UIColor clearColor]];
                categoryView.tag = 1005;
                [cell.contentView addSubview:categoryView];
                
                UIImage * categoryImg = getImage(@"res", NO);
                EGOImageView *categoryImgView = [[EGOImageView alloc] initWithPlaceholderImage:categoryImg imageViewFrame:CGRectMake(10,(categoryView.frame.size.height - categoryImg.size.height)/2,categoryImg.size.width, categoryImg.size.height)];
                categoryImgView.tag = 1000;
                categoryImgView.backgroundColor = [UIColor clearColor];
                [categoryView addSubview:categoryImgView];
                
                UILabel * categoryLbl = [[UILabel alloc] initWithFrame:CGRectMake(10 + 20,0,130,categoryView.frame.size.height)];
                categoryLbl.tag = 1001;
                categoryLbl.numberOfLines = 0;
                categoryLbl.backgroundColor = [UIColor clearColor];
                categoryLbl.textColor = UIColorFromRGB(0x999999);
                categoryLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                [categoryView addSubview:categoryLbl];
                
                UILabel * favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 100 - 10,0,100,categoryView.frame.size.height)];
                favoriteLabel.tag = 1003;
                favoriteLabel.backgroundColor = [UIColor clearColor];
                favoriteLabel.textColor = UIColorFromRGB(0x00b3a4);
                favoriteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
                UITapGestureRecognizer* favoriteLabelGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callAddToFavouriteServiceWith)];
                [favoriteLabel setUserInteractionEnabled:YES];
                [favoriteLabel addGestureRecognizer:favoriteLabelGeture];
                [categoryView addSubview:favoriteLabel];
                
                UIImage * favoriteImage = getImage(@"fav", NO);
                UIImageView *favoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake((favoriteLabel.frame.origin.x - favoriteImage.size.width) - 5,(categoryView.frame.size.height - favoriteImage.size.height)/2,favoriteImage.size.width, favoriteImage.size.height)];
                favoriteImageView.tag = 1002;
                favoriteImageView.backgroundColor = [UIColor clearColor];
                favoriteImageView.userInteractionEnabled = YES;
                 UITapGestureRecognizer* favoriteImgGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callAddToFavouriteServiceWith)];
                 [favoriteImageView addGestureRecognizer:favoriteImgGeture];
                [categoryView addSubview:favoriteImageView];
                
                UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(13,CGRectGetMaxY(categoryView.frame),285,60)];
                descriptionLabel.tag = 1004;
                descriptionLabel.backgroundColor = [UIColor clearColor];
                descriptionLabel.numberOfLines = 0;
                descriptionLabel.textColor = UIColorFromRGB(0x333333);
                descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                [cell.contentView addSubview:descriptionLabel];
            }
            
            else if (indexPath.section == 1)
            {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UIView *cellBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, cell.contentView.frame.size.width, 48)];
                cellBaseView.backgroundColor = UIColorFromRGB(0xf5f5f5);
                [cell.contentView addSubview:cellBaseView];
                
                EGOImageView *iconImageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(0,0,cellBaseView.frame.size.height,cellBaseView.frame.size.height)];
                iconImageView.tag = 2000;
                iconImageView.backgroundColor = [UIColor clearColor];
                [cellBaseView addSubview:iconImageView];
                
                UILabel * itemNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(cellBaseView.frame.size.height + 10, 0, 160, cellBaseView.frame.size.height)];
                itemNameLbl.tag = 2001;
                itemNameLbl.backgroundColor = [UIColor clearColor];
                itemNameLbl.textColor = UIColorFromRGB(0x333333);
                itemNameLbl.numberOfLines = 2;
                itemNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
                itemNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
                [cellBaseView addSubview:itemNameLbl];
                
                UILabel * priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(225,0, 15,cellBaseView.frame.size.height)];
                priceLbl.tag = 2002;
                priceLbl.backgroundColor = [UIColor clearColor];
                priceLbl.textColor = UIColorFromRGB(0x808080);
                priceLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
                [cellBaseView addSubview:priceLbl];
                
                UILabel * discountPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLbl.frame)+6,0, 20, cellBaseView.frame.size.height)];
                discountPriceLbl.tag = 2003;
                discountPriceLbl.backgroundColor = [UIColor clearColor];
                discountPriceLbl.textColor = UIColorFromRGB(0x00b3a4);
                discountPriceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
                [cellBaseView addSubview:discountPriceLbl];
                
                UIImage * addcartImage = getImage(@"add_bag", NO);
                UIButton * addCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(discountPriceLbl.frame)+4,8,addcartImage.size.width, addcartImage.size.height)];
                addCartBtn.tag = 2004;
                [addCartBtn setImage:addcartImage forState:UIControlStateNormal];
                addCartBtn.backgroundColor = [UIColor clearColor];
                [addCartBtn addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
                [cellBaseView addSubview:addCartBtn];
            }
            
            else if ( indexPath.section == 2)
            {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,5, 150,50)];
                addressLabel.tag = 3001;
                addressLabel.backgroundColor = [UIColor clearColor];
                addressLabel.textColor = UIColorFromRGB(0x333333);
                addressLabel.numberOfLines = 0;
                addressLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                [cell.contentView addSubview:addressLabel];
                
                UILabel * phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(addressLabel.frame), 150,20)];
                phoneNumLabel.tag = 3002;
                phoneNumLabel.backgroundColor = [UIColor clearColor];
                phoneNumLabel.textColor = UIColorFromRGB(0x333333);
                phoneNumLabel.numberOfLines = 0;
                phoneNumLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                UITapGestureRecognizer *phoneNumGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumCallAction)];
                [phoneNumLabel addGestureRecognizer:phoneNumGestureRecognizer];
                [cell.contentView addSubview:phoneNumLabel];
                phoneNumLabel.userInteractionEnabled = YES;
                
                UILabel * webUrlLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(phoneNumLabel.frame), 150,20)];
                webUrlLabel.tag = 3003;
                webUrlLabel.backgroundColor = [UIColor clearColor];
                webUrlLabel.textColor = UIColorFromRGB(0x333333);
                webUrlLabel.numberOfLines = 0;
                webUrlLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                UITapGestureRecognizer *webUrlGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openWebUrlAction)];
                [webUrlLabel addGestureRecognizer:webUrlGestureRecognizer];
                [cell.contentView addSubview:webUrlLabel];
                webUrlLabel.userInteractionEnabled = YES;
                
                MKMapView * mapView = [[MKMapView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 125 - 15,10,125,75)];
                mapView.mapType = MKMapTypeStandard;
                mapView.userInteractionEnabled=NO;
                mapView.tag = 3004;
                mapView.delegate = self;
                mapView.layer.borderColor = [UIColorFromRGB(0x00b3a4) CGColor];
                mapView.layer.borderWidth = 1.0;
                [cell.contentView addSubview:mapView];
                
            }
            else if ( indexPath.section == 3)
            {
                [cell.contentView setBackgroundColor:[UIColor clearColor]];
                
                UIView *openHrsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width/2, 75)];
                openHrsView.tag = 4005;
                [openHrsView setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:openHrsView];
                
                UILabel *openHeaderLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, openHrsView.frame.size.width - 20, 30)];
                openHeaderLbl.tag = 4000;
                openHeaderLbl.backgroundColor = [UIColor clearColor];
                openHeaderLbl.textColor = UIColorFromRGB(0x00b3a4);
                openHeaderLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
                [openHrsView addSubview:openHeaderLbl];
                
                UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(openHeaderLbl.frame)+1,58,30)];
                dayLabel.tag = 4006;
                dayLabel.backgroundColor = [UIColor clearColor];
                [openHrsView addSubview:dayLabel];
                
                UILabel *openingHourLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dayLabel.frame)+5,CGRectGetMaxY(openHeaderLbl.frame)+1,75,30)];
                openingHourLabel.tag = 4001;
                openingHourLabel.backgroundColor = [UIColor clearColor];
                [openHrsView addSubview:openingHourLabel];
                
                UIView *priceRangeView = [[UIView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width/2, 0, cell.contentView.frame.size.width/2, 75)];
                [priceRangeView setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:priceRangeView];
                
                UILabel *priceHeaderLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, priceRangeView.frame.size.width - 20, 30)];
                priceHeaderLbl.tag = 4004;
                priceHeaderLbl.backgroundColor = [UIColor clearColor];
                priceHeaderLbl.textColor = UIColorFromRGB(0x00b3a4);
                priceHeaderLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
                [priceRangeView addSubview:priceHeaderLbl];
                
                UILabel * priceRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(priceHeaderLbl.frame), priceRangeView.frame.size.width - 20,20)];
                priceRangeLabel.tag = 4003;
                priceRangeLabel.backgroundColor = [UIColor clearColor];
                [priceRangeView addSubview:priceRangeLabel];
                
            }
            else if (indexPath.section == 4)
            {
                EGOImageView *iconImageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake(15,10,30,30)];
                iconImageView.tag = 5001;
                iconImageView.layer.cornerRadius=15;
                iconImageView.clipsToBounds = YES;
                iconImageView.userInteractionEnabled = YES;
                [iconImageView setContentMode:UIViewContentModeScaleAspectFit];
                iconImageView.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:iconImageView];
                UITapGestureRecognizer *friendsImgGesture1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOtherUserDetails:)];
                [iconImageView addGestureRecognizer:friendsImgGesture1];
                
                UILabel * firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45+8, 13,200, 17)];
                firstNameLabel.tag = 5002;
                firstNameLabel.backgroundColor = [UIColor clearColor];
                firstNameLabel.textColor = UIColorFromRGB(0x333333);
                firstNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
                [cell.contentView addSubview:firstNameLabel];
                
                UILabel * commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(45+8,CGRectGetMaxY(firstNameLabel.frame), 230,30)];
                commentsLabel.tag = 5004;
                commentsLabel.backgroundColor = [UIColor clearColor];
                commentsLabel.textColor = UIColorFromRGB(0x333333);
                commentsLabel.numberOfLines = 0;
                commentsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                [cell.contentView addSubview:commentsLabel];
                
                UILabel * daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseViewWidth-85,10, 75, 20)];
                daysLabel.tag = 5005;
                daysLabel.backgroundColor = [UIColor clearColor];
                daysLabel.textColor = UIColorFromRGB(0x999999);
                daysLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
                daysLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:daysLabel];
            }
        }
        
        // Assigning Values
        if ( indexPath.section == 0 )
        {
            EGOImageView *restaurantImageView = (EGOImageView*)[cell.contentView viewWithTag:1000];
            UILabel *restaurantLabel = (UILabel*)[cell.contentView viewWithTag:1001];
            UIImageView *favoriteImageView = (UIImageView*)[cell.contentView viewWithTag:1002];
            UILabel *favoriteLabel = (UILabel*)[cell.contentView viewWithTag:1003];
            UILabel *descriptionLabel = (UILabel*)[cell.contentView viewWithTag:1004];
            UIView *catgView = (UIView*)[cell.contentView viewWithTag:1005];
            
            if(merchantdetailmodel.CategoryList.count > 0) {
                
                CategoryModel *categoryModel = [merchantdetailmodel.CategoryList objectAtIndex:0];
                [restaurantImageView setImageURL:[NSURL URLWithString:categoryModel.CategoryIcon]];
                restaurantLabel.text = categoryModel.CategoryName;
            }
            else
            {
                restaurantImageView.image = getImage(@"res", NO);
                restaurantLabel.text = [merchantdetailmodel.ShortDescription capitaliseFirstLetter];
                int height = [restaurantLabel.text heigthWithWidth:CGRectGetWidth(restaurantLabel.frame) andFont:restaurantLabel.font];
                restaurantLabel.height = height+1;
                if(height>30)
                    catgView.height = height;
            }
            
            if(favouriteType)
            {
                favoriteImageView.image =  getImage(@"fav_y", NO);
                favoriteLabel.text = LString(@"REMOVE_FROM_FAVOURITE");
            }
            else
            {
                favoriteImageView.image =  getImage(@"fav", NO);
                favoriteLabel.text =LString(@"ADD_TO_FAVOURITE");
            }
            int width = [favoriteLabel.text widthWithFont:favoriteLabel.font];
            favoriteLabel.frame = CGRectMake(baseViewWidth- width+5 - 10,0,width+5,favoriteLabel.frame.size.height);
            CGRect imgViewRect = favoriteImageView.frame;
            imgViewRect.origin.x = (favoriteLabel.frame.origin.x - favoriteImageView.size.width) - 5;
            favoriteImageView.frame = imgViewRect;
            
            descriptionLabel.text = [merchantdetailmodel.Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            float newLblHeight =[descriptionLabel.text heigthWithWidth:285 andFont:descriptionLabel.font];
            descriptionLabel.height = newLblHeight;
            [descriptionLabel positionAtY:CGRectGetMaxY(catgView.frame)+5];
        }
        else if (indexPath.section == 1)
        {
            SpecialProductsModel *specialProduct = [[detailMainDict valueForKey:@"Specials"] objectAtIndex:indexPath.row];
            
            EGOImageView *iconImageView = (EGOImageView *)[cell.contentView viewWithTag:2000];
            iconImageView.imageURL = [NSURL URLWithString:specialProduct.Photo];
            
            UIButton * addCartBtn = (UIButton*)[cell.contentView viewWithTag:2004];
            UILabel * discountPriceLbl = (UILabel *) [cell.contentView viewWithTag:2003];
            discountPriceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.DiscountPrice.doubleValue]]];
            float discountLblWidth = [discountPriceLbl.text widthWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
            discountPriceLbl.frame = CGRectMake(baseViewWidth - discountLblWidth-CGRectGetWidth(addCartBtn.frame)-15, 0, discountLblWidth, 48);
            
            UILabel * priceLbl = (UILabel *) [cell.contentView viewWithTag:2002];
            priceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.Price.doubleValue]]];
            float priceLblWidth = [priceLbl.text widthWithFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
            priceLbl.frame = CGRectMake(discountPriceLbl.frame.origin.x-priceLblWidth-5, 0, priceLblWidth, 48);
            
            UILabel * itemNameLbl = (UILabel *)[cell.contentView viewWithTag:2001];
            itemNameLbl.text = specialProduct.ItemName;
            itemNameLbl.frame = CGRectMake(itemNameLbl.frame.origin.x, 0,baseViewWidth-(baseViewWidth-priceLbl.frame.origin.x)-itemNameLbl.frame.origin.x, 48);
            
            iconImageView.imageURL = [NSURL URLWithString:specialProduct.Photo];
            priceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.Price.doubleValue]]];
            discountPriceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.DiscountPrice.doubleValue]]];
            
            UIButton * addToCartBtn = (UIButton *) [cell.contentView viewWithTag:2004];
            if (!isAllowCartEnabled) {
                [addToCartBtn setImage:getImage(@"add_bag_grey",NO) forState:UIControlStateNormal];
            }
            else
            {
                [addToCartBtn setImage:getImage(@"add_bag",NO) forState:UIControlStateNormal];
            }
        }
        
        else if ( indexPath.section == 2)
        {
            UILabel * addressLabel = (UILabel *)[cell.contentView viewWithTag:3001];
            UILabel * phoneNumLabel = (UILabel *)[cell.contentView viewWithTag:3002];
            UILabel * webUrlLabel = (UILabel *)[cell.contentView viewWithTag:3003];
            MKMapView * mapView = (MKMapView*)[cell.contentView viewWithTag:3004];
            
            addressLabel.text = [NSString stringWithFormat:@"%@,\n%@" ,[merchantdetailmodel.CompanyName stringWithTitleCase],merchantdetailmodel.Address];
            float newLblHeight =[addressLabel.text heigthWithWidth:150 andFont:addressLabel.font];
            CGRect addressRect = addressLabel.frame;
            addressRect.size.height =newLblHeight;
            addressLabel.frame = addressRect;
            
            phoneNumLabel.text = [TuplitConstants filteredPhoneStringFromString:merchantdetailmodel.PhoneNumber withFilter:PHONE_NUM_FORMAT];
            //[TuplitConstants formatPhoneNumber:merchantdetailmodel.PhoneNumber];
            float phoneLblHeight =[phoneNumLabel.text heigthWithWidth:150 andFont:phoneNumLabel.font];
            phoneNumLabel.frame =CGRectMake(15,CGRectGetMaxY(addressLabel.frame) + 10, 150,phoneLblHeight);
            
            webUrlLabel.text = merchantdetailmodel.WebsiteUrl;
            float webUrlLblHeight =[webUrlLabel.text heigthWithWidth:150 andFont:webUrlLabel.font];
            webUrlLabel.frame =CGRectMake(15,CGRectGetMaxY(phoneNumLabel.frame), 150,webUrlLblHeight);
            
            CLLocationCoordinate2D coord = {.latitude = merchantdetailmodel.Latitude.doubleValue, .longitude =  merchantdetailmodel.Longitude.doubleValue};
            MKCoordinateSpan span = {.latitudeDelta =  0.1, .longitudeDelta =  0.1};
            MKCoordinateRegion region = {coord, span};
            [mapView setRegion:region];
        }
        
        else if ( indexPath.section == 3)
        {
            UILabel *openHeaderLbl = (UILabel *)[cell.contentView viewWithTag:4000];
            UILabel *priceHeaderLbl = (UILabel *)[cell.contentView viewWithTag:4004];
            openHeaderLbl.text = @"Opening hours";
            priceHeaderLbl.text = @"Price range";
            
            int i=0;
            if([merchantdetailmodel.OpeningHours count]>0)
            {
                OpeningHoursModel *openingHrsModel = [merchantdetailmodel.OpeningHours objectAtIndex:0];
                UILabel * daysLbl = (UILabel *)[cell.contentView viewWithTag:4006];
                daysLbl.numberOfLines = 0;
                NSMutableAttributedString *opendaysString = [[NSMutableAttributedString alloc]init];
                for(NSString *string in openingHrsModel.Open)
                {
                    if(i!=0)
                    {
                        NSAttributedString *atrStr = [[NSAttributedString alloc]initWithString:@"\n" attributes:nil];
                        [opendaysString appendAttributedString:atrStr];
                    }
                    [opendaysString  appendAttributedString:[TuplitConstants getOpeningHrs:string isTimeFormat:NO]];
                    i++;
                }
                [daysLbl setAttributedText:opendaysString];
                CGRect dayFrame = daysLbl.frame;
                dayFrame.size.height =(i * 15);
                [daysLbl setFrame:dayFrame];
                
                UILabel * openingHrsLbl = (UILabel *)[cell.contentView viewWithTag:4001];
                openingHrsLbl.numberOfLines = 0;
                NSMutableAttributedString *openHrsString = [[NSMutableAttributedString alloc]init];
                i=0;
                for(NSString *string in openingHrsModel.Open)
                {
                    if(i!=0)
                    {
                        NSAttributedString *atrStr = [[NSAttributedString alloc]initWithString:@"\n" attributes:nil];
                        [openHrsString appendAttributedString:atrStr];
                    }
                    [openHrsString  appendAttributedString:[TuplitConstants getOpeningHrs:string isTimeFormat:YES]];
                    i++;
                }
                [openingHrsLbl setAttributedText:openHrsString];
                CGRect openFrame = openingHrsLbl.frame;
                openFrame.size.height = (i * 15);
                [openingHrsLbl setFrame:openFrame];
                
                UIView *openHrsView = (UILabel *)[cell.contentView viewWithTag:4005];
                CGRect openViewFrame = openHrsView.frame;
                openViewFrame.size.height = CGRectGetMaxY(openingHrsLbl.frame);
                [openHrsView setFrame:openViewFrame];
            }
            
            UILabel * priceRangeLabel1 = (UILabel *)[cell.contentView viewWithTag:4003];
            priceRangeLabel1.attributedText = [TuplitConstants getPriceRange:merchantdetailmodel.PriceRange];
        }
        
        else if (indexPath.section == 4)
        {
            EGOImageView *iconImageView = (EGOImageView *)[cell.contentView viewWithTag:5001];
            UILabel * firstNameLabel = (UILabel *)[cell.contentView viewWithTag:5002];
            UILabel * commentsLabel = (UILabel *) [cell.contentView viewWithTag:5004];
            UILabel * daysLabel = (UILabel *) [cell.contentView viewWithTag:5005];
            
            CommentsModel *cmtDetails = [[detailMainDict valueForKey:@"Customer's Comments"] objectAtIndex:indexPath.row];
            iconImageView.imageURL = [NSURL URLWithString:cmtDetails.Photo];
            firstNameLabel.text =[NSString stringWithFormat:@"%@ %@",[cmtDetails.FirstName stringWithTitleCase],[cmtDetails.LastName stringWithTitleCase]];
            
            commentsLabel.text =cmtDetails.CommentsText;
            float cmtLblHeight = [commentsLabel.text heigthWithWidth:commentsLabel.frame.size.width andFont:commentsLabel.font];
            CGRect newRect = commentsLabel.frame;
            newRect.size.height = cmtLblHeight;
            commentsLabel.frame = newRect;
            
            daysLabel.text = [TuplitConstants calculateTimeDifference:cmtDetails.CommentDate];
        }
        return cell;
        
    }
    else{
        
        static NSString *CellIdentifier = @"DiscountAndMenu";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *cellBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, cell.contentView.frame.size.width, 48)];
            cellBaseView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            [cell.contentView addSubview:cellBaseView];
            
            EGOImageView *iconImageView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(0,0,cellBaseView.frame.size.height,cellBaseView.frame.size.height)];
            iconImageView.tag = 2000;
            iconImageView.backgroundColor = [UIColor clearColor];
            [cellBaseView addSubview:iconImageView];
            
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellBaseView.frame.size.height + 10, 0, 160, cellBaseView.frame.size.height)];
            nameLabel.tag = 2001;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.numberOfLines = 2;
            nameLabel.textColor = UIColorFromRGB(0x333333);
            nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
            [cellBaseView addSubview:nameLabel];
            
            UILabel * priceLabelSmall = [[UILabel alloc] initWithFrame:CGRectMake(225,0, 15,cellBaseView.frame.size.height)];
            priceLabelSmall.tag = 2002;
            priceLabelSmall.backgroundColor = [UIColor clearColor];
            priceLabelSmall.textColor = UIColorFromRGB(0x808080);
            priceLabelSmall.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
            [cellBaseView addSubview:priceLabelSmall];
            
            UILabel * priceLabelBig = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabelSmall.frame)+6,0, 20, cellBaseView.frame.size.height)];
            priceLabelBig.tag = 2003;
            priceLabelBig.backgroundColor = [UIColor clearColor];
            priceLabelBig.textColor = UIColorFromRGB(0x24b9ac);
            priceLabelBig.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
            [cellBaseView addSubview:priceLabelBig];
            
            UIImage *addcartImage = getImage(@"add_bag", NO);
            UIButton * addCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addCartBtn.frame = CGRectMake(CGRectGetMaxX(priceLabelBig.frame)+4,8,addcartImage.size.width, addcartImage.size.height);
            addCartBtn.tag = 2004;
            addCartBtn.backgroundColor = [UIColor clearColor];
            [addCartBtn setImage:addcartImage forState:UIControlStateNormal];
            [addCartBtn addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
            [cellBaseView addSubview:addCartBtn];
        }
        
        SpecialProductsModel *specialProduct = [[orderedMainDict valueForKey:[orderSectionNamesArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                
        EGOImageView *iconImageView = (EGOImageView *)[cell.contentView viewWithTag:2000];
        UILabel * itemNameLbl = (UILabel *)[cell.contentView viewWithTag:2001];

        NSString *priceValue;
        if(!specialProduct.DiscountPrice.intValue)
            priceValue =[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.Price.doubleValue]]];
        else
            priceValue =[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.DiscountPrice.doubleValue]]];
        
        UIButton * addCartBtn = (UIButton*)[cell.contentView viewWithTag:2004];
        addCartBtn.enabled = specialProduct.Status.intValue;
        
        UILabel * discountPriceLbl = (UILabel *) [cell.contentView viewWithTag:2003];
        float discountLblWidth = [priceValue widthWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        discountPriceLbl.frame = CGRectMake(baseViewWidth - discountLblWidth-CGRectGetWidth(addCartBtn.frame)-15, 0, discountLblWidth, 48);
        
        UILabel * priceLbl = (UILabel *) [cell.contentView viewWithTag:2002];
        priceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.Price.doubleValue]]];
        float priceLblWidth = [priceLbl.text widthWithFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
        priceLbl.frame = CGRectMake(discountPriceLbl.frame.origin.x-priceLblWidth-5, 0, priceLblWidth, 48);
        
        if(specialProduct.DiscountApplied.intValue)
        {
            priceLbl.hidden = NO;
            itemNameLbl.frame = CGRectMake(itemNameLbl.frame.origin.x, 0,baseViewWidth-(baseViewWidth-priceLbl.frame.origin.x)-itemNameLbl.frame.origin.x, 48);
        }
        else
        {
            priceLbl.hidden = YES;
            itemNameLbl.frame = CGRectMake(itemNameLbl.frame.origin.x, -1, baseViewWidth-(baseViewWidth-discountPriceLbl.frame.origin.x)-itemNameLbl.frame.origin.x, 48);
        }
        
        itemNameLbl.text = specialProduct.ItemName;
        iconImageView.imageURL = [NSURL URLWithString:specialProduct.Photo];
        itemNameLbl.text = specialProduct.ItemName;
        priceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.Price.doubleValue]]];
        discountPriceLbl.text = [NSString stringWithFormat:@"%@",priceValue];
        
        iconImageView.imageURL = [NSURL URLWithString:specialProduct.Photo];
        itemNameLbl.text = specialProduct.ItemName;
        priceLbl.text = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:specialProduct.Price.doubleValue]]];
        discountPriceLbl.text = [NSString stringWithFormat:@"%@",priceValue];
        
        UIButton * addToCartBtn = (UIButton *) [cell.contentView viewWithTag:2004];
        if (!isAllowCartEnabled) {
            [addToCartBtn setImage:getImage(@"add_bag_grey",NO) forState:UIControlStateNormal];
        }
        else
        {
            [addToCartBtn setImage:getImage(@"add_bag",NO) forState:UIControlStateNormal];
        }
        
        return cell;
    }
    
}

#pragma mark - Table View Delegate Source Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIAlertViewDelegate Source Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 9000) {
        
        if (buttonIndex == 1) {
            
            APP_DELEGATE.cartModel = [[CartModel alloc] init];
            [self addToCart:selectedCartButton];
        }
    }
    else if (alertView.tag == 9001) {
        
        if (buttonIndex == 1) {
            
            [TuplitConstants userLogout];
        }
    }
    else if(alertView.tag == 9010) {
        
        if (buttonIndex == 1) {
            
            UIDevice *device = [UIDevice currentDevice];
            
            NSString *unfilteredString = merchantdetailmodel.PhoneNumber;
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
            NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",resultString]];
            
            if ([[device model] isEqualToString:@"iPhone"] ) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }
    }
    else if (alertView.tag == 9002) {
        
        if (buttonIndex == 1) {
            
            [TuplitConstants userLogout];
        }
    }
}

#pragma  mark - MerchantDetailsManager Delegate Methods

- (void)merchantDetailsManagerSuccessful:(TLMerchantDetailsManager *)merchantDetailsManager withMerchantDetails:(MerchantsDetailsModel*) _merchantDetailModel
{
    merchantdetailmodel = _merchantDetailModel;
    isAllowCartEnabled = merchantDetailsManager.isAllowCartEnabled;
    
    NSArray *specialProductArray = [[NSArray alloc] init];
    NSArray *discountProductArray = [[NSArray alloc] init];
    NSArray *menuProductArray = [[NSArray alloc] init];
    
    if (_merchantDetailModel.ProductList.count > 0) {
        
        ProductListModel *productListDetials = [merchantdetailmodel.ProductList objectAtIndex:0];
        
        if (productListDetials.SpecialProducts.count > 0) {
            specialProductArray = productListDetials.SpecialProducts;
        }
        if (productListDetials.DiscountProducts.count > 0) {
            discountProductArray = productListDetials.DiscountProducts;
        }
        if (productListDetials.MenuProducts.count > 0) {
            menuProductArray = productListDetials.MenuProducts;
        }
    }
    
    // Details content
    
    detailMainDict = @{
      @"Description": @"",
      @"Specials": specialProductArray,
      @"Address": @"",
      @"Opening Hours": merchantdetailmodel.OpeningHours,
      @"Customer's Comments": merchantdetailmodel.Comments,
      };
    detailSectionNamesArray = [NSArray arrayWithObjects:@"Description",@"Specials",@"Address",@"Opening Hours",@"Customer's Comments", nil];
    
    //Order Content
    
    orderedMainDict = @{
                       @"Discounted": discountProductArray,
                       };
    orderSectionNamesArray = [NSMutableArray arrayWithObjects:@"Discounted", nil];
    
    if (menuProductArray.count > 0) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:orderedMainDict];
        
        for (MenuProductsModel *menuProductModel in menuProductArray) {
            
            [dict setObject:menuProductModel.Items forKey:menuProductModel.CategoryName];
            [orderSectionNamesArray addObject:menuProductModel.CategoryName];
        }
    
        orderedMainDict = [NSDictionary dictionaryWithDictionary:dict];
    }
    
    [self updateMerchantDetails];
    
    [[ProgressHud shared] hide];
}

- (void)merchantDetailsManager:(TLMerchantDetailsManager *)merchantDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)merchantDetailsManagerFailed:(TLMerchantDetailsManager *)merchantDetailsManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma  mark - TLAddFavouriteManager Delegate Methods

- (void)addFavouriteManagerSuccessfull:(TLAddFavouriteManager *) addFavouriteManager
{
    APP_DELEGATE.isFavoriteChanged = YES;
    if(favouriteType)
        favouriteType=0;
    else
        favouriteType=1;
    
    [merchantDetailTable reloadData];
     [[ProgressHud shared] hide];
}
- (void)addFavouriteManager:(TLAddFavouriteManager *) addFavouriteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
     [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)addFavouriteManagerFailed:(TLAddFavouriteManager *) addFavouritesManager
{
     [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self.navigationController  dismissViewControllerAnimated:YES completion:NULL];
}

@end
