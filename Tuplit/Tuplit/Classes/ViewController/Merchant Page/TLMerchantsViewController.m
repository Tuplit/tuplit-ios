//
//  TLMerchantsViewController.m
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLMerchantsViewController.h"
#import "TLWelcomeViewController.h"
#import "TLTutorialViewController.h"
#import "PinAnnotation.h"

@implementation TLMerchantsViewController

#pragma mark - View life cycle methods.

- (void)dealloc
{
    merchantListingManager.delegate = nil;
    merchantListingManager = nil;
}

- (void)loadView {
    
    [super loadView];
    [self.navigationItem setTitle:LString(@"MERCHANTS")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    rightExpandButton = [[UIBarButtonItem alloc] init];
    [rightExpandButton buttonWithIcon:getImage(@"DiscountEnable", NO) target:self action:@selector(onDiscountPressed) isLeft:NO];
    [self.navigationItem setRightBarButtonItem:rightExpandButton];
    
    baseViewWidth  = self.view.frame.size.width;
    baseViewHeight  = self.view.frame.size.height;
    
     adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    UIView *baseView  = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,baseViewHeight-adjustHeight)];
    baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:baseView];
    
    NSMutableArray *menuItems = [NSMutableArray arrayWithObjects:@"All",@"10%",@"20%",@"30%",@"40%",@"50%",nil];
    choiceButton = [[ChoiceButton alloc] initWithFrame:CGRectMake(0,0, baseView.frame.size.width,35) withTitles:menuItems];
    [choiceButton setBackgroundColor:[UIColor whiteColor]];
    [choiceButton setDelegate:self];
    [baseView addSubview:choiceButton];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0,0, baseView.frame.size.width, baseView.frame.size.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:contentView];
    
    //SearchBar View
    searchbarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,contentView.frame.size.width,40)];
    searchbarView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:searchbarView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, searchbarView.frame.size.width, 0.5)];
    [lineView1 setBackgroundColor:[UIColor grayColor]];
    [contentView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, searchbarView.frame.size.height - 1, searchbarView.frame.size.width, 1)];
    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    [contentView addSubview:lineView2];
    
    searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, searchbarView.frame.size.width - 40, searchbarView.frame.size.height)];
    searchTxt.delegate = self;
    searchTxt.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    searchTxt.textColor = UIColorFromRGB(0xb2b2b2);
    searchTxt.backgroundColor = [UIColor clearColor];
    searchTxt.placeholder = @"Search";
    searchTxt.textAlignment = NSTextAlignmentLeft;
    
    if ([searchTxt respondsToSelector:@selector(tintColor)]) // Check for property before calling because calling it crashes the app on iOS6
    {
       searchTxt.tintColor = UIColorFromRGB(0x01b3a5);
    }
    searchTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    searchTxt.clearButtonMode = UITextFieldViewModeUnlessEditing;
    searchTxt.userInteractionEnabled = YES;
    [searchbarView addSubview:searchTxt];
        
    UIImage *searchImg = [UIImage imageNamed:@"search.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, searchImg.size.width + 20, searchImg.size.height)];
    [searchImgView setContentMode:UIViewContentModeScaleAspectFit];
    searchImgView.image = searchImg;
    [searchTxt setLeftView:searchImgView];
    [searchTxt setLeftViewMode:UITextFieldViewModeAlways];
    
    UIImage *mapIconImg = [UIImage imageNamed:@"MapIcon.png"];
    mapIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchTxt.frame),0, mapIconImg.size.width + 20, 40)];
    [mapIconImgView setContentMode:UIViewContentModeCenter];
    [mapIconImgView setUserInteractionEnabled:YES];
    [mapIconImgView setBackgroundColor:[UIColor clearColor]];
    mapIconImgView.image = mapIconImg;
    [searchbarView addSubview:mapIconImgView];
    
    UITapGestureRecognizer *mapIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapIconImgViewAction:)];
    [mapIconImgView addGestureRecognizer:mapIconTap];
    
    //Menu Bar
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchbarView.frame), contentView.frame.size.width, 34)];
    [menuView setBackgroundColor:[UIColor clearColor]];
    [menuView setUserInteractionEnabled:YES];
    [contentView addSubview:menuView];
    
    buttonNearby = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNearby.tag = 1001;
    [buttonNearby addTarget:self action:@selector(buttonNearbyPopularAction:) forControlEvents:UIControlEventTouchDown];
    [buttonNearby setTitle:@"Nearby" forState:UIControlStateNormal];
    buttonNearby.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    buttonNearby.frame=CGRectMake(0, 0, menuView.frame.size.width/2, 34);
    buttonNearby.backgroundColor = UIColorFromRGB(0X01b3a5);
    [buttonNearby setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [menuView addSubview:buttonNearby];
    
    UIButton *buttonPopular = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPopular.tag = 1002;
    [buttonPopular addTarget:self action:@selector(buttonNearbyPopularAction:) forControlEvents:UIControlEventTouchDown];
    [buttonPopular setTitle:@"Popular" forState:UIControlStateNormal];
    buttonPopular.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    buttonPopular.frame = CGRectMake(CGRectGetMaxX(buttonNearby.frame), 0, menuView.frame.size.width/2, 34);
    buttonPopular.backgroundColor = UIColorFromRGB(0X01b3a5);
    [buttonPopular setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [menuView addSubview:buttonPopular];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(menuView.frame),baseViewWidth,baseViewHeight-CGRectGetMaxY(menuView.frame) - adjustHeight)];
    mapView.mapType = MKMapTypeStandard;
    mapView.userInteractionEnabled=YES;
    mapView.delegate = self;
    mapView.hidden = YES;
    [contentView addSubview:mapView];
    
    merchantTable = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(menuView.frame),baseViewWidth,baseViewHeight-CGRectGetMaxY(menuView.frame) - adjustHeight)];
    merchantTable.dataSource = self;
    merchantTable.delegate = self;
    merchantTable.tag = 1004;
    merchantTable.hidden = NO;
    [merchantTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [contentView addSubview:merchantTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [merchantTable addSubview:refreshControl];
    
    cellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,merchantTable.frame.size.width, 64)];
    [cellContainer setBackgroundColor:[UIColor clearColor]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cellContainer.frame.size.width - 30)/2, (cellContainer.frame.size.height - 30)/2, 30, 30)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [cellContainer addSubview:activity];
    
    merchantErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame), merchantTable.frame.size.width, merchantTable.frame.size.height)];
    [merchantErrorLabel setBackgroundColor:[UIColor whiteColor]];
    [merchantErrorLabel setTextAlignment:NSTextAlignmentCenter];
    [merchantErrorLabel setTextColor:[UIColor lightGrayColor]];
    [merchantErrorLabel setText:@"No merchants found."];
    [merchantErrorLabel setHidden:YES];
    [contentView addSubview:merchantErrorLabel];
    
    searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(searchbarView.frame),contentView.frame.size.width,contentView.frame.size.height - CGRectGetMaxY(searchbarView.frame))];
    searchTable.dataSource = self;
    searchTable.delegate   = self;
    searchTable.separatorColor = [UIColor clearColor];
    searchTable.tag  = 1003;
    searchTable.hidden = YES;
    [contentView addSubview:searchTable];
    
    searchErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchbarView.frame), searchTable.frame.size.width, searchTable.frame.size.height)];
    [searchErrorLabel setBackgroundColor:[UIColor whiteColor]];
    [searchErrorLabel setTextAlignment:NSTextAlignmentCenter];
    [searchErrorLabel setTextColor:[UIColor lightGrayColor]];
    [searchErrorLabel setHidden:YES];
    [contentView addSubview:searchErrorLabel];
    
//    Comment Prompt View
    if([TLUserDefaults isCommentPromptOpen])
    {
        cmtPromptView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(merchantTable.frame)-88, baseViewWidth, 88)];
        cmtPromptView.backgroundColor = UIColorFromRGB(0x00b3a4);
        cmtPromptView.userInteractionEnabled = YES;
        cmtPromptView.hidden = YES;
        [baseView addSubview:cmtPromptView];
        
        merchantNameLabel = [[UILabel alloc]init];
        merchantNameLabel.backgroundColor = [UIColor clearColor];
        merchantNameLabel.numberOfLines = 0;
        if([TLUserDefaults getCommentDetails].CompanyName)
        merchantNameLabel.text =[NSString stringWithFormat:@"How Was %@?",[[TLUserDefaults getCommentDetails].CompanyName stringWithTitleCase]];
        
        merchantNameLabel.textColor = UIColorFromRGB(0xffffff);
        merchantNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        int merchantNameHeight = [merchantNameLabel.text heigthWithWidth: baseViewWidth-20 andFont:merchantNameLabel.font];
        merchantNameLabel.frame = CGRectMake(10, 15, baseViewWidth-20, merchantNameHeight+1);
        cmtPromptView.frame = CGRectMake(0, CGRectGetMaxY(merchantTable.frame)-88-merchantNameHeight, baseViewWidth, 88+merchantNameHeight);
        [cmtPromptView addSubview:merchantNameLabel];
        
        UILabel *defaultTxt = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(merchantNameLabel.frame), baseViewWidth-20, 20)];
        defaultTxt.backgroundColor = [UIColor clearColor];
        defaultTxt.text = LString(@"PROMPT_INFO_TXT");
        defaultTxt.textColor = UIColorFromRGB(0xffffff);
        defaultTxt.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        [cmtPromptView addSubview:defaultTxt];
        
        UIView *btnsView = [[ UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(defaultTxt.frame)+15, baseViewWidth-20, 25)];
        btnsView.backgroundColor = [UIColor clearColor];
        [cmtPromptView addSubview:btnsView];
        
        UIButton *nothankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nothankBtn.frame = CGRectMake(0, 0, 90, 25);
        [nothankBtn setBackgroundColor:[UIColor clearColor]];
        [nothankBtn addTarget:self action:@selector(nothankBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [nothankBtn setTitle:@"No, thanks" forState:UIControlStateNormal];
        nothankBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        [nothankBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        nothankBtn.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
        nothankBtn.layer.borderWidth = 1.0;
        [btnsView addSubview:nothankBtn];
        
        UIButton *cmtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cmtBtn.frame = CGRectMake(CGRectGetMaxX(nothankBtn.frame)+12, 0, 150, 25);
        [cmtBtn setBackgroundColor:UIColorFromRGB(0xC2FEF9)];
        [cmtBtn addTarget:self action:@selector(leaveCommentBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [cmtBtn setTitle:@"Leave a comment" forState:UIControlStateNormal];
        cmtBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        [cmtBtn setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        [btnsView addSubview:cmtBtn];
    }
    
    merchantsArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    merchantListingModel = [[TLMerchantListingModel alloc] init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:searchTxt];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buttonNearbyPopularAction:buttonNearby];
    [self callCategoryWebservice];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    if([TLUserDefaults isCommentPromptOpen])
        cmtPromptView.hidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self presentTutorial];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UserDefined methods

- (void)presentTutorial {
    
    if(![TLUserDefaults isTutorialSkipped])
    {
        TLTutorialViewController *tutorVC = [[TLTutorialViewController alloc] initWithNibName:@"TLTutorialViewController" bundle:nil];
        [self.navigationController presentViewController:tutorVC animated:YES completion:nil];
    }
}

-(void) callCategoryWebservice {
    
    NETWORK_TEST_PROCEDURE
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLCategoryListingManager *categoryListingManager = [[TLCategoryListingManager alloc] init];
    categoryListingManager.delegate = self;
    [categoryListingManager callService];
}

-(void) callMerchantWebserviceWithActionType:(int) actionType startCount:(long) start showProgressIndicator:(BOOL) showProgressIndicator {
    
    NETWORK_TEST_PROCEDURE
    
    if (isMerchantWebserviceRunning) {
        return;
    }
    
    isMerchantWebserviceRunning = YES;
    
    if (showProgressIndicator) {
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    }
    
    merchantListingModel.actionType = actionType;
    merchantListingModel.Latitude = [NSString stringWithFormat:@"%lf",[CurrentLocation latitude]];
    merchantListingModel.Longitude = [NSString stringWithFormat:@"%lf",[CurrentLocation longitude]];
    
    switch (actionType) {
        case MCSearch:
        {
            merchantListingModel.Category = @"";
            merchantListingModel.Type = @"";
            merchantListingModel.Start = @"";
            merchantListingModel.SearchKey = searchTxt.text;
            
            [merchantListingManager cancelRequest];
            
            break;
        }
        case MCCategory:
        {
            merchantListingModel.Category = categoryId;
            merchantListingModel.Type = [NSString stringWithFormat:@"%d",menuSelected];
            merchantListingModel.Start = [NSString stringWithFormat:@"%ld",start];
            merchantListingModel.SearchKey = @"";
            break;
        }
        case MCNearBy:
        {
            merchantListingModel.Category = @"";
            merchantListingModel.Type = @"1";
            merchantListingModel.Start = [NSString stringWithFormat:@"%ld",start];
            merchantListingModel.SearchKey = @"";
            merchantListingModel.DiscountTier = (discountTierValue==0)?@"":[NSString stringWithFormat:@"%d",discountTierValue];
            break;
        }
        case MCPopular:
        {
            merchantListingModel.Category = @"";
            merchantListingModel.Type = @"2";
            merchantListingModel.Start = [NSString stringWithFormat:@"%ld",start];
            merchantListingModel.SearchKey = @"";
            merchantListingModel.DiscountTier = (discountTierValue==0)?@"":[NSString stringWithFormat:@"%d",discountTierValue];
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (merchantListingManager==nil) {
        merchantListingManager = [[TLMerchantListingManager alloc] init];
    }
    else
    {
        
    }
    
    merchantListingManager.delegate = self;
    [merchantListingManager callService:merchantListingModel];
}

- (void) onDiscountPressed
{
    isDiscountShown = !isDiscountShown;
    searchTxt.text = @"";
    [searchTxt resignFirstResponder];
    
    if(!isDiscountShown)
        [rightExpandButton buttonWithIcon:getImage(@"DiscountEnable.png", NO) target:self action:@selector(onDiscountPressed) isLeft:NO];
    else
        [rightExpandButton buttonWithIcon:getImage(@"DiscountDisable.png", NO) target:self action:@selector(onDiscountPressed) isLeft:NO];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        if (!isDiscountShown)
        {
            [contentView positionAtY:0];
            merchantTable.height = baseViewHeight - CGRectGetMaxY(menuView.frame) - adjustHeight;
            mapView.height = baseViewHeight - CGRectGetMaxY(menuView.frame) - adjustHeight;
            
            if (isKeyBoardOpen) {
                searchTable.height = contentView.frame.size.height - searchbarView.frame.size.height - 216;
            }
            else
            {
                searchTable.height = contentView.frame.size.height - searchbarView.frame.size.height;
            }
            
        }
        else
        {
            [contentView positionAtY:CGRectGetMaxY(choiceButton.frame)];
            merchantTable.height = baseViewHeight - choiceButton.frame.size.height - CGRectGetMaxY(menuView.frame) - adjustHeight;
            mapView.height = baseViewHeight - choiceButton.frame.size.height - CGRectGetMaxY(menuView.frame) - adjustHeight;
            
            if (isKeyBoardOpen) {
                searchTable.height = contentView.frame.size.height  - choiceButton.frame.size.height - searchbarView.frame.size.height  - 216;
            }
            else
            {
                searchTable.height = contentView.frame.size.height  - choiceButton.frame.size.height - searchbarView.frame.size.height;
            }
        }
    }];
}

- (void) mapIconImgViewAction: (id) sender
{
    [searchTxt setText:@""];
    [searchErrorLabel setHidden:YES];
    [self.view endEditing:YES];
    
    isMapShown=!isMapShown;
    
    if (!isMapShown)
    {
        UIImage *img = [UIImage imageNamed:@"MapIcon.png"];
        mapIconImgView.image = img;
        merchantTable.hidden = NO;
        mapView.hidden = YES;
    }
    else
    {
        UIImage *img = [UIImage imageNamed:@"ListGreen.png"];
        mapIconImgView.image = img;
        merchantTable.hidden = YES;
        mapView.hidden = NO;
        
        [self addMapAnnotations];
    }
    
    if (searchTable.hidden == NO) {
        searchTable.hidden = YES;
    }
}

-(void) addMapAnnotations {
    PinAnnotation *pinAnnotation;
    for(MerchantModel *merchantModel in merchantsArray)
    {
        if (merchantModel.Latitude.doubleValue == 0.0 || merchantModel.Longitude.doubleValue == 0.0) {
            continue;
        }
        CLLocationCoordinate2D location;
        location.latitude = merchantModel.Latitude.doubleValue;
        location.longitude = merchantModel.Longitude.doubleValue;
        pinAnnotation = [[PinAnnotation alloc] init];
        pinAnnotation.coordinate = location;
        pinAnnotation.title = merchantModel.MerchantID;
        pinAnnotation.subtitle = merchantModel.IsSpecial;
        [mapView addAnnotation:pinAnnotation];
    }
}

- (void) buttonNearbyPopularAction:(UIButton*) button
{
    UIButton *buttonnearby = (UIButton*)[contentView viewWithTag:1001];
    UIButton *buttonPopular = (UIButton*)[contentView viewWithTag:1002];
    
    if (button.tag == 1001)
    {
        [buttonPopular setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg.png"] forState:UIControlStateNormal];
        [buttonPopular setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        buttonPopular.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        
        [buttonnearby setBackgroundImage:Nil forState:UIControlStateNormal];
        [buttonnearby setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonnearby.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        
        menuSelected = 1;
//        [merchantListingManager cancelRequest];
        isMerchantWebserviceRunning = NO;
        [self callMerchantWebserviceWithActionType:MCNearBy startCount:0 showProgressIndicator:YES];
        
        //[buttonnearby setUserInteractionEnabled:NO];
        //[buttonPopular setUserInteractionEnabled:YES];
    }
    else
    {
        [buttonPopular setBackgroundImage:Nil forState:UIControlStateNormal];
        [buttonPopular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonPopular.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        
        [buttonnearby setBackgroundImage:[UIImage imageNamed:@"ButtonLightBg.png"] forState:UIControlStateNormal];
        [buttonnearby setTitleColor:UIColorFromRGB(0x00998c) forState:UIControlStateNormal];
        buttonnearby.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        
        menuSelected = 2;
//        [merchantListingManager cancelRequest];
        isMerchantWebserviceRunning = NO;
        [self callMerchantWebserviceWithActionType:MCPopular startCount:0 showProgressIndicator:YES];
        
        //[buttonnearby setUserInteractionEnabled:YES];
        //[buttonPopular setUserInteractionEnabled:NO];
    }
}

-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    
    if (menuSelected == 1) {
        [self callMerchantWebserviceWithActionType:MCNearBy startCount:0 showProgressIndicator:NO];
    }
    else if (menuSelected == 2) {
        [self callMerchantWebserviceWithActionType:MCPopular startCount:0 showProgressIndicator:NO];
    }
}

-(void) loadMoreUsers {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self callMerchantWebserviceWithActionType:(menuSelected==1)?MCNearBy:MCPopular startCount:lastFetchCount showProgressIndicator:NO];
    }
}

-(void)nothankBtnAction
{
    [TLUserDefaults setIsCommentPromptOpen:NO];
    cmtPromptView.hidden = YES;
}

-(void)leaveCommentBtnAction
{
    TLAddCommentViewController *addcommentVC = [[TLAddCommentViewController alloc]init];
    [self.navigationController pushViewController:addcommentVC animated:YES];
    cmtPromptView.hidden = YES;
}

-(void)performSearchCategory
{
    NSString *search = [searchTxt.text lowercaseString];
    
    NSMutableArray *categoryName = [[NSMutableArray alloc]init];
    for(CategoryModel *category in categoryArray)
    {
        [categoryName addObject:category.CategoryName];
    }
    NSIndexSet *indexes = [categoryName indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        NSString *s = (NSString*)obj;
        NSRange range = [[s lowercaseString] rangeOfString: search];
        return range.location != NSNotFound;
    }];
   
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [searchArray addObject:[categoryArray objectAtIndex:idx]];
    }];
    
}
-(void)hideSearch
{
    searchTxt.text = @"";
    searchTable.hidden = YES;
    mapView.hidden = NO;
    mapIconImgView.hidden = NO;
    merchantTable.hidden = NO;

}
# pragma mark - MKMapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView;
    NSString *identifier;
    
//  Pin annotation.
    if ([annotation isKindOfClass:[PinAnnotation class]]) {
        
        identifier = @"Pin";
        annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        annotationView.canShowCallout = NO;
        
        if([annotation subtitle].intValue == 0)
            annotationView.image = getImage(@"MapPinBlack", NO);
        else
            annotationView.image = getImage(@"MapPinBlackWithStar", NO);
    }
    
//   Callout annotation.    
    else if ([annotation isKindOfClass:[CalloutAnnotation class]])
    {
        identifier = @"Callout";
        annotationView = (CustomCallOutView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[CustomCallOutView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            [((CustomCallOutView *)annotationView) loadView];
            ((CustomCallOutView *)annotationView).frame             = CGRectMake(0.0, 0.0,250,55);
            annotationView.centerOffset      = CGPointMake(-2,-44);
            annotationView.canShowCallout    = NO;
            ((CustomCallOutView *)annotationView).delegate = self;
        }
       
        CalloutAnnotation *calloutAnnotation = (CalloutAnnotation *)annotation;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"MerchantID Matches[cd] %@",[calloutAnnotation title]];
        NSArray *result = [merchantsArray filteredArrayUsingPredicate:pred];
        if(result.count > 0){
            MerchantModel *merchant = (MerchantModel*)[result objectAtIndex:0];
            ((CustomCallOutView *)annotationView).merchant = merchant;
        }
        // Move the display position of MapView.
        [UIView animateWithDuration:0.5f
                         animations:^(void) {
                             mapView.centerCoordinate = calloutAnnotation.coordinate;
                         }];
    }
    
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)_mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if([view.annotation isKindOfClass:[MKUserLocation class]])
        return;
    
    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
        
//       Selected the pin annotation.
        CalloutAnnotation *calloutAnnotation = [[CalloutAnnotation alloc] init];
        
        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        calloutAnnotation.title      = pinAnnotation.title;
        calloutAnnotation.coordinate    = pinAnnotation.coordinate;
        pinAnnotation.calloutAnnotation = calloutAnnotation;
        [_mapView addAnnotation:calloutAnnotation]; //removing the annotation a bit later
       
    }
}

-(void)mapView:(MKMapView *)_mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    for (UIView *subview in view.subviews ){
//        [subview removeFromSuperview];
//    }
    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
//         Deselected the pin annotation.
        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        
        if (pinAnnotation.calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            pinAnnotation.calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            CalloutAnnotation *oldAnnotation = pinAnnotation.calloutAnnotation; //saving it to be removed from the map later
            pinAnnotation.calloutAnnotation = nil; //setting to nil to know that we aren't showing a callout anymore
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView removeAnnotation:oldAnnotation]; //removing the annotation a bit later
            });
//             [_mapView removeAnnotation:pinAnnotation.calloutAnnotation];
//             pinAnnotation.calloutAnnotation = nil;
//        });
        }
       
        
       
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1003) {
        
        if (searchArray.count > 0) {
            return [searchArray count];
        }
        else if(searchTxt.text.length==0)
        {
            return [categoryArray count];
        }
        else
            return 0;
    }
    else if(tableView.tag == 1004) {
        return [merchantsArray count];
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1003) {
        return SEARCH_CELL_HEIGHT;
    }
    else if(tableView.tag == 1004) {
        return MERCHANT_CELL_HEIGHT;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier[] = {@"Merchants",@"Search",@"Empty"};
    
    int cellId = 2;
    if (tableView.tag == 1003) {
        
        cellId = 1;
        
        MerchantSearchCell *merchantsCell = (MerchantSearchCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier[cellId]];
        
        if(merchantsCell == nil) {
            
            merchantsCell = [[MerchantSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            merchantsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            merchantsCell.backgroundColor = [UIColor clearColor];
            
        }
        
        if (searchArray.count > 0) {
            if([[searchArray objectAtIndex:indexPath.row] isKindOfClass:[MerchantModel class]])
            {
                MerchantModel *merchantModel = [searchArray objectAtIndex:indexPath.row];
                [merchantsCell setMerchant:merchantModel];
            }
            else
            {
                CategoryModel *merchantModel = [searchArray objectAtIndex:indexPath.row];
                [merchantsCell setCategory:merchantModel];
            }
        }
        else
        {
            CategoryModel *categoryModel = [categoryArray objectAtIndex:indexPath.row];
            [merchantsCell setCategory:categoryModel];
        }
        
        
        return merchantsCell;
    }
    else if(tableView.tag == 1004) {
        
        cellId = 0;
        
        MerchantsCell *merchantsCell = (MerchantsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier[cellId]];
        
        if(merchantsCell == nil) {
            
            merchantsCell = [[MerchantsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            merchantsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            merchantsCell.backgroundColor = [UIColor clearColor];
            
        }
        
        MerchantModel *merchantModel = [merchantsArray objectAtIndex:indexPath.row];
        [merchantsCell setMerchant:merchantModel];
        
        return merchantsCell;
    }
    else
    {
        cellId = 2;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier[cellId]];
        
        if(cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1003) {

        if (searchArray.count > 0) {
            
            if([[searchArray objectAtIndex:indexPath.row] isKindOfClass:[MerchantModel class]])
            {
                [self.view endEditing:YES];
                MerchantModel *merchantModel = [searchArray objectAtIndex:indexPath.row];
                
                TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
                detailsVC.merchantModel = merchantModel;
                [self.navigationController pushViewController:detailsVC animated:YES];
            }
            else
            {
                CategoryModel *categoryModel = [searchArray objectAtIndex:indexPath.row];
                categoryId = categoryModel.CategoryId;
                [self.view endEditing:YES];
                [self callMerchantWebserviceWithActionType:MCCategory startCount:0 showProgressIndicator:YES];
            }
           
        }
        else
        {
            CategoryModel *categoryModel = [categoryArray objectAtIndex:indexPath.row];
            categoryId = categoryModel.CategoryId;
            [self.view endEditing:YES];
            [self callMerchantWebserviceWithActionType:MCCategory startCount:0 showProgressIndicator:YES];
        }
    }
    else if (tableView.tag == 1004) {
        
        MerchantModel *merchantModel = [merchantsArray objectAtIndex:indexPath.row];
        
        TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
        detailsVC.merchantModel = merchantModel;
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    
    if (offset >= 0.0 && offset <= 50.0) {
        
        [self loadMoreUsers];
    }
}

#pragma mark - TextFieldButtonDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    isKeyBoardOpen = YES;
    searchTable.hidden = NO;
    mapView.hidden = YES;
    merchantTable.hidden = YES;
    
    isMapShown = NO;
    UIImage *img = [UIImage imageNamed:@"MapIcon.png"];
    mapIconImgView.image = img;

    CGRect searchTableFrame = searchTable.frame;
    if(isDiscountShown) {
        searchTableFrame.size.height = contentView.frame.size.height - searchbarView.frame.size.height - choiceButton.frame.size.height - 216;
    }
    else
    {
        searchTableFrame.size.height = contentView.frame.size.height - searchbarView.frame.size.height - 216;
    }
    [searchTable setFrame:searchTableFrame];
    searchErrorLabel.height =searchTable.frame.size.height;
    
    [searchArray removeAllObjects];
    [searchTable reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
//    isKeyBoardOpen = NO;
//    
//    if(searchArray.count > 0) {
//        
//        searchTable.hidden = NO;
//    }
//    else
//    {
//        searchTxt.text = @"";
//        searchTable.hidden = YES;
//        mapView.hidden = NO;
//        merchantTable.hidden = NO;
//    }
    
    searchTable.height = contentView.frame.size.height - CGRectGetMaxY(searchbarView.frame);
    searchErrorLabel.height = searchTable.frame.size.height;
    [self hideSearch];

}

- (void) textFieldDidChange:(NSNotification*) notification {
    
    if (!isTextFieldClearPressed) {
        
        if (searchTxt.text.length >= 3) {
            [self callMerchantWebserviceWithActionType:MCSearch startCount:0 showProgressIndicator:NO];
        }
        else if(searchTxt.text.length == 0) {
            
            [searchErrorLabel setHidden:YES];
            
            [searchArray removeAllObjects];
            [searchTable reloadData];
        }
    }
    else
    {
        isTextFieldClearPressed = NO;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    isTextFieldClearPressed = YES;
    [searchArray removeAllObjects];
    [searchTable reloadData];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - ChoiceButtonDelegate

- (void) choiceButton:(ChoiceButton*) choiceButton selectedButtonIndex:(int)index;
{
    searchTxt.text = @"";
    [searchTxt resignFirstResponder];
    
    discountTierValue = index;
    [self callMerchantWebserviceWithActionType:(menuSelected==1)?MCNearBy:MCPopular startCount:0 showProgressIndicator:YES];
}

#pragma mark - TLMerchantListingManagerDelegate

- (void)merchantListingManager:(TLMerchantListingManager *)_merchantListingManager withMerchantList:(NSArray*) _merchantsArray {
    
    switch (_merchantListingManager.merchantListModel.actionType) {
        case MCSearch:
        {
            [searchArray removeAllObjects];
            [self performSearchCategory];
//            searchArray = [NSMutableArray arrayWithArray:_merchantsArray];
            [searchArray addObjectsFromArray:_merchantsArray];
            [searchTable reloadData];
            
            break;
        }
        case MCCategory:
        case MCNearBy:
        case MCPopular:
        {
            if (isLoadMorePressed) {
                
                [merchantsArray addObjectsFromArray:_merchantsArray];
            }
            else
            {
                merchantsArray = [NSMutableArray arrayWithArray:_merchantsArray];
                lastFetchCount = 0;
            }
            
            totalUserListCount = _merchantListingManager.totalCount;
            
            if ((_merchantListingManager.listedCount % 10) == 0) {
                lastFetchCount = lastFetchCount + _merchantListingManager.listedCount;
            }
            else
            {
                lastFetchCount = merchantsArray.count;
            }
            
            if (lastFetchCount < totalUserListCount)
                [merchantTable setTableFooterView:cellContainer];
            else
                [merchantTable setTableFooterView:nil];
            
 //   Leave comment option
            if([TLUserDefaults isCommentPromptOpen])
                cmtPromptView.hidden = NO;
            
            [merchantTable reloadData];
            
            if (mapView.annotations.count > 0) {
                [mapView removeAnnotations:mapView.annotations];
            }
            
            [self addMapAnnotations];
            
            if ([_merchantListingManager.merchantListModel.Start integerValue] == 0 && !isPullRefreshPressed) {
                [merchantTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    [searchErrorLabel setHidden:YES];
    [merchantErrorLabel setHidden:YES];
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}

- (void)merchantListingManager:(TLMerchantListingManager *)_merchantListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    switch (_merchantListingManager.merchantListModel.actionType) {
        case MCSearch:
        {
            [searchArray removeAllObjects];
            [self performSearchCategory];

            [searchTable reloadData];
            
            
            if (searchTxt.text.length > 0 && searchArray.count == 0) {
                
                [searchErrorLabel setText:errorMsg];
                [searchErrorLabel setHidden:NO];
                
                CGRect frame = searchErrorLabel.frame;
                frame.origin.y = CGRectGetMaxY(searchbarView.frame);
                [searchErrorLabel setFrame:frame];
            }
            else
            {
                [searchErrorLabel setHidden:YES];
                [merchantErrorLabel setHidden:YES];
            }
            
            break;
        }
        case MCCategory:
        case MCNearBy:
        case MCPopular:
        {
            [merchantErrorLabel setText:errorMsg];
            [merchantErrorLabel setHidden:NO];
            
            CGRect frame = merchantErrorLabel.frame;
            frame.origin.y = CGRectGetMaxY(menuView.frame);
            [merchantErrorLabel setFrame:frame];
            
            [merchantsArray removeAllObjects];
            [merchantTable reloadData];
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    isMerchantWebserviceRunning =NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}

- (void)merchantListingManager:(TLMerchantListingManager *)_merchantListingManager {
    
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    
    [merchantErrorLabel setHidden:YES];
    [searchErrorLabel setHidden:YES];
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
#pragma mark - TLMerchantListingManagerDelegate

- (void)categoryListingManager:(TLCategoryListingManager *)categoryListingManager withCategoryList:(NSArray*) _categoryArray {
    
    categoryArray = [NSMutableArray arrayWithArray:_categoryArray];
    [searchTable reloadData];
    [self buttonNearbyPopularAction:buttonNearby];
}

- (void)categoryListingManager:(TLCategoryListingManager *)categoryListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
}

- (void)categoryListingManager:(TLCategoryListingManager *)categoryListingManager {
    
    [[ProgressHud shared] hide];
}

#pragma mark - CalloutAnnotationViewDelegate

- (void)calloutButtonClicked:(NSString *)title
{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"MerchantID Matches[cd] %@",title];
    NSArray *result = [merchantsArray filteredArrayUsingPredicate:pred];
    if(result.count > 0){
        MerchantModel *merchant = (MerchantModel*)[result objectAtIndex:0];
        TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
        detailsVC.merchantModel = merchant;
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
}

@end

