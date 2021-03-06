//
//  TLFavouriteListViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 14/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLFavouriteListViewController.h"
#import "TLWelcomeViewController.h"
#import "TLTutorialViewController.h"
#import "PinAnnotation.h"
#import "CustomCallOutView.h"
#import "NSArray+BlocksKit.h"

@interface TLFavouriteListViewController ()<CustomCallOutViewDelegate>

@end

@implementation TLFavouriteListViewController

#pragma mark - View life cycle methods.

- (void)dealloc
{
    favouriteListingManager.delegate = nil;
    favouriteListingManager = nil;
}

- (void)loadView {
    
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"FAVORITES")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
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
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
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
    //
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, searchbarView.frame.size.height - 1, searchbarView.frame.size.width, 1)];
    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    [contentView addSubview:lineView2];
    
    searchTxt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, searchbarView.frame.size.width - 40, searchbarView.frame.size.height)];
    searchTxt.delegate = self;
    searchTxt.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    searchTxt.textColor = UIColorFromRGB(0xb2b2b2);
    searchTxt.backgroundColor = [UIColor clearColor];
    searchTxt.placeholder = @"Search";
    [searchTxt setReturnKeyType:UIReturnKeySearch];
    searchTxt.textAlignment = NSTextAlignmentLeft;
    
    if ([searchTxt respondsToSelector:@selector(tintColor)]) // Check for property before calling because calling it crashes the app on iOS6
    {
        searchTxt.tintColor = UIColorFromRGB(0x01b3a5);
    }
    searchTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    searchTxt.clearButtonMode = UITextFieldViewModeUnlessEditing;
    searchTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTxt.userInteractionEnabled = YES;
    [searchbarView addSubview:searchTxt];
    
    UIImage *searchImg = [UIImage imageNamed:@"search"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, searchImg.size.width + 20, searchImg.size.height)];
    [searchImgView setContentMode:UIViewContentModeScaleAspectFit];
    searchImgView.image = searchImg;
    [searchTxt setLeftView:searchImgView];
    [searchTxt setLeftViewMode:UITextFieldViewModeAlways];
    
    UIImage *mapIconImg = [UIImage imageNamed:@"MapIcon"];
    mapIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchTxt.frame),0, mapIconImg.size.width + 20, 40)];
    [mapIconImgView setContentMode:UIViewContentModeCenter];
    [mapIconImgView setUserInteractionEnabled:YES];
    [mapIconImgView setBackgroundColor:[UIColor clearColor]];
    mapIconImgView.image = mapIconImg;
    [searchbarView addSubview:mapIconImgView];
    
    UITapGestureRecognizer *mapIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapIconImgViewAction:)];
    [mapIconImgView addGestureRecognizer:mapIconTap];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(searchbarView.frame),baseViewWidth,baseViewHeight-CGRectGetMaxY(searchbarView.frame) - adjustHeight)];
    mapView.mapType = MKMapTypeStandard;
    mapView.userInteractionEnabled=YES;
    mapView.delegate = self;
    mapView.hidden = YES;
    [contentView addSubview:mapView];
    
    merchantTable = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(searchbarView.frame),baseViewWidth,baseViewHeight-CGRectGetMaxY(searchbarView.frame) - adjustHeight)];
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
    
    merchantErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(searchbarView.frame), baseViewWidth, merchantTable.frame.size.height)];
    [merchantErrorLabel setBackgroundColor:[UIColor whiteColor]];
    [merchantErrorLabel setTextAlignment:NSTextAlignmentCenter];
    [merchantErrorLabel setTextColor:[UIColor lightGrayColor]];
    [merchantErrorLabel setText:LString(@"NO_FAVORITES_FOUND")];
    [merchantErrorLabel setHidden:YES];
    [baseView addSubview:merchantErrorLabel];
    
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
    
    favouritesArray = [[NSMutableArray alloc] init];
    merchantListingModel = [[TLMerchantListingModel alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:searchTxt];
    
    [self callMerchantWebserviceWithActionType:MCNearBy startCount:0 showProgressIndicator:YES];
    isSearch = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    contentView.hidden = NO;
    if(APP_DELEGATE.isFavoriteChanged)
    {
        APP_DELEGATE.isFavoriteChanged = NO;
        [self callMerchantWebserviceWithActionType:MCNearBy startCount:0 showProgressIndicator:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UserDefined methods

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    
    searchTable.height = contentView.frame.size.height - searchbarView.frame.size.height - keyboardHeight;
    searchErrorLabel.height =searchTable.frame.size.height;
}

-(void)reloadfavourites
{
    [favouritesArray removeAllObjects];
    [merchantTable reloadData];
    [merchantTable setTableFooterView:cellContainer];
    
    [merchantTable setUserInteractionEnabled:NO];
    searchTxt.text = @"";
    
    UIImage *img = [UIImage imageNamed:@"MapIcon"];
    mapIconImgView.image = img;
    merchantTable.hidden = NO;
    mapView.hidden = YES;
    isMapShown = NO;
    
    [self callMerchantWebserviceWithActionType:MCNearBy startCount:0 showProgressIndicator:NO];
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
            merchantListingModel.Start = @"";
            merchantListingModel.SearchKey = searchTxt.text;
            
            [favouriteListingManager cancelRequest];
            
            break;
        }
        case MCNearBy:
        {
            merchantListingModel.Start = [NSString stringWithFormat:@"%ld",start];
            merchantListingModel.SearchKey = NSNonNilString(searchTxt.text);
            break;
            
        }
        default:
        {
            break;
        }
    }
    
    if (favouriteListingManager==nil)
        favouriteListingManager = [[TLFavouriteListingManager alloc] init];
    
    favouriteListingManager.delegate = self;
    [favouriteListingManager callService:merchantListingModel];
}

-(void)mapviewLoadmore
{
    if (isMerchantWebserviceRunning) {
        return;
    }
    
    isMerchantWebserviceRunning = YES;
    
    merchantListingModel.actionType = MCNearBy;
    merchantListingModel.Latitude = [NSString stringWithFormat:@"%lf",mapView.centerCoordinate.latitude];
    merchantListingModel.Longitude = [NSString stringWithFormat:@"%lf",mapView.centerCoordinate.longitude];
    
    merchantListingModel.Category = @"";
    merchantListingModel.Type = @"1";
    merchantListingModel.Start = [NSString stringWithFormat:@"%d",0];
    merchantListingModel.DiscountTier = (discountTierValue==0)?@"":[NSString stringWithFormat:@"%d",discountTierValue];
    
    if (favouriteListingManager==nil) {
        favouriteListingManager = [[TLFavouriteListingManager alloc] init];
    }
    else
    {
        
    }
    
    favouriteListingManager.delegate = self;
    [favouriteListingManager callService:merchantListingModel];
}
-(void)loadMoreAnnotation:(NSArray*)moreAnnotations
{
    //    [mapView removeAnnotations:mapView.annotations];
    
    for(MerchantModel *merchantModel in moreAnnotations)
    {
        if (merchantModel.Latitude.doubleValue == 0.0 || merchantModel.Longitude.doubleValue == 0.0) {
            continue;
        }
        CLLocationCoordinate2D location;
        location.latitude = merchantModel.Latitude.doubleValue;
        location.longitude = merchantModel.Longitude.doubleValue;
        PinAnnotation *pinAnnotation = [[PinAnnotation alloc] init];
        pinAnnotation.coordinate = location;
        pinAnnotation.title = merchantModel.MerchantID;
        pinAnnotation.subtitle = merchantModel.TagType;
        [mapView addAnnotation:pinAnnotation];
    }
}

- (void) mapIconImgViewAction: (id) sender
{
    if(favouritesArray.count>0)
    {
        [self.view endEditing:YES];
        
        isMapShown=!isMapShown;
        
        if (!isMapShown)
        {
            UIImage *img = [UIImage imageNamed:@"MapIcon"];
            mapIconImgView.image = img;
            merchantTable.hidden = NO;
            mapView.hidden = YES;
            [merchantTable reloadData];
        }
        else
        {
            UIImage *img = [UIImage imageNamed:@"ListGreen"];
            mapIconImgView.image = img;
            merchantTable.hidden = YES;
            mapView.hidden = NO;
            
            [self addMapAnnotations];
        }
    }
}

-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) addMapAnnotations {
    PinAnnotation *pinAnnotation;
    
    [mapView removeAnnotations:mapView.annotations];

    for(MerchantModel *merchantModel in favouritesArray)
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
        pinAnnotation.subtitle = merchantModel.TagType;
        [mapView addAnnotation:pinAnnotation];
    }

    [TuplitConstants zoomToFitMapAnnotations:mapView];
}

-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    [self callMerchantWebserviceWithActionType:MCNearBy startCount:0 showProgressIndicator:NO];
}

-(void) loadMoreUsers {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self callMerchantWebserviceWithActionType:MCNearBy startCount:lastFetchCount showProgressIndicator:NO];
    }
}

-(void)hideSearch
{
//    searchTxt.text = @"";
    searchTable.hidden = YES;
    searchErrorLabel.hidden = YES;
    
    if(isMapShown)
    {
        mapView.hidden = NO;
        mapIconImgView.hidden = NO;
    }
    else
    {
        merchantTable.hidden = NO;
    }
    
    
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
        
        if([annotation subtitle].intValue == 3)
            annotationView.image = getImage(@"MapPinBlackWithStar", NO);
        else
            annotationView.image = getImage(@"MapPinBlack", NO);
            
    }
    
    //   Callout annotation.
    else if ([annotation isKindOfClass:[CalloutAnnotation class]])
    {
        identifier = @"Callout";
        annotationView = (CustomCallOutView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[CustomCallOutView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            [((CustomCallOutView *)annotationView) loadView];
            ((CustomCallOutView *)annotationView).frame             = CGRectMake(0.0,0.0,250,70);
            annotationView.centerOffset      = CALL_OUT_POS;
            annotationView.canShowCallout    = NO;
            ((CustomCallOutView *)annotationView).delegate = self;
        }
        
        CalloutAnnotation *calloutAnnotation = (CalloutAnnotation *)annotation;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"MerchantID Matches[cd] %@",[calloutAnnotation title]];
        NSArray *result = [favouritesArray filteredArrayUsingPredicate:pred];
        if(result.count > 0){
            MerchantModel *merchant = (MerchantModel*)[result objectAtIndex:0];
            ((CustomCallOutView *)annotationView).merchant = merchant;
        }
        // Move the display position of MapView.
        if(isMapShown)
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
    else
    {
        CalloutAnnotation *annotation = (CalloutAnnotation*)view.annotation;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"MerchantID Matches[cd] %@",annotation.title];
        NSArray *result = [favouritesArray filteredArrayUsingPredicate:pred];
        if(result.count > 0){
            MerchantModel *merchant = (MerchantModel*)[result objectAtIndex:0];
            TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
            detailsVC.merchantModel = merchant;
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
    }
}

-(void)mapView:(MKMapView *)_mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
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
            
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(isMapShown && (favouritesArray.count<totalUserListCount))
        [NSThread detachNewThreadSelector:@selector(mapviewLoadmore) toTarget:self withObject:nil];
}


#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1004) {
        return [favouritesArray count];
    }
    else if(tableView.tag == 1003)
    {
        return [searchArray count];
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1004) {
        return MERCHANT_CELL_HEIGHT;
    }
    else if(tableView.tag == 1003)
    {
        return SEARCH_CELL_HEIGHT;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier[] = {@"Merchants",@"Search"};
    
    int cellId = 2;
    if(tableView.tag == 1004) {
        
        cellId = 0;
        
        MerchantsCell *merchantsCell = (MerchantsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier[cellId]];
        
        if(merchantsCell == nil) {
            
            merchantsCell = [[MerchantsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            merchantsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            merchantsCell.backgroundColor = [UIColor clearColor];
            
        }
        
        MerchantModel *merchantModel = [favouritesArray objectAtIndex:indexPath.row];
        [merchantsCell setMerchant:merchantModel];
        
        return merchantsCell;
    }
    else if(tableView.tag == 1003)
    {
        cellId = 1;
        
        MerchantSearchCell *merchantsCell = (MerchantSearchCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier[cellId]];
        
        if(merchantsCell == nil) {
            
            merchantsCell = [[MerchantSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier[cellId]];
            merchantsCell.selectionStyle = UITableViewCellSelectionStyleGray;
            merchantsCell.backgroundColor = [UIColor clearColor];
            
        }
        if (searchArray.count > 0)
            if([[searchArray objectAtIndex:indexPath.row] isKindOfClass:[MerchantModel class]])
            {
                MerchantModel *merchantModel = [searchArray objectAtIndex:indexPath.row];
                [merchantsCell setMerchant:merchantModel];
            }
        
        return merchantsCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1004) {
        MerchantModel *merchantModel = [favouritesArray objectAtIndex:indexPath.row];
        
        TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
        detailsVC.merchantModel = merchantModel;
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
    else  if (tableView.tag == 1003)
    {
        [self.view endEditing:YES];
                
        MerchantModel *merchantModel = [searchArray objectAtIndex:indexPath.row];
        
        TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
        detailsVC.merchantModel = merchantModel;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    [self hideSearch];
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
    searchErrorLabel.hidden = NO;
    mapView.hidden = YES;
    merchantTable.hidden = YES;
    isSearch = YES;
    
    //    isMapShown = NO;
    //    UIImage *img = [UIImage imageNamed:@"MapIcon.png"];
    //    mapIconImgView.image = img;
    
    CGRect searchTableFrame = searchTable.frame;
    searchTableFrame.size.height = contentView.frame.size.height - searchbarView.frame.size.height - 216;
    [searchTable setFrame:searchTableFrame];
    
    searchErrorLabel.height =searchTable.frame.size.height;
    
    [searchArray removeAllObjects];
    [searchTable reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    isKeyBoardOpen = NO;
    isSearch = NO;
    searchTable.height = contentView.frame.size.height - CGRectGetMaxY(searchbarView.frame);
    searchErrorLabel.height = searchTable.frame.size.height;
//    isMerchantWebserviceRunning = NO;
    [self hideSearch];
//   [self callMerchantWebserviceWithActionType:MCSearch startCount:0 showProgressIndicator:YES];
}

- (void) textFieldDidChange:(NSNotification*) notification {
    
    if (!isTextFieldClearPressed) {
        
        if (searchTxt.text.length >= 3) {
            [self callMerchantWebserviceWithActionType:MCSearch startCount:0 showProgressIndicator:YES];
        }
        else if(searchTxt.text.length == 0) {
            
            [merchantErrorLabel setHidden:YES];
            
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
    [self callMerchantWebserviceWithActionType:MCSearch startCount:0 showProgressIndicator:YES];
    
    return YES;
}

#pragma mark - TLFavouriteListingManagerDelegate

- (void)favouriteManagerSuccessfull:(TLFavouriteListingManager *) favouriteListManager withFavouriteList:(NSArray*)_favouriteArray
{
    [merchantTable setUserInteractionEnabled:YES];
    
    for(MerchantModel *merchantModel in _favouriteArray)
    {
        EGOImageView *imageview = [[EGOImageView alloc]initWithPlaceholderImage:nil imageViewFrame:CGRectMake(0, 0, 10, 10)];
        imageview.imageURL = [NSURL URLWithString:merchantModel.Image];
    }
    
    switch (favouriteListManager.merchantListModel.actionType) {
        case MCSearch:
        case MCNearBy:
        {
            if([searchTxt isFirstResponder])
            {
                [searchArray removeAllObjects];
                searchArray = [NSMutableArray arrayWithArray:_favouriteArray];
                [searchTable reloadData];
                [searchErrorLabel setHidden:YES];
                
                isMerchantWebserviceRunning =NO;
                [[ProgressHud shared] hide];
                [refreshControl endRefreshing];
                
            }
            else
            {
                if(isMapShown)
                {
                    if(favouriteListManager.merchantListModel.actionType == MCSearch)
                    {
                        [favouritesArray removeAllObjects];
                        [favouritesArray addObjectsFromArray:_favouriteArray];
                        
                        totalUserListCount = (int)favouriteListManager.totalCount;
                        
                        if (favouritesArray.count < totalUserListCount)
                            [merchantTable setTableFooterView:cellContainer];
                        else
                            [merchantTable setTableFooterView:nil];
                        
                        [self addMapAnnotations];
                        
                        isMerchantWebserviceRunning = NO;
                        [[ProgressHud shared] hide];
                        return;
                        
                    }
                    else
                    {
                    NSMutableArray *newannotations = [NSMutableArray new];
                    
                    newannotations = [[_favouriteArray bk_reject:^BOOL(id obj) {
                        
                        MerchantModel *merchantModel1 = obj;
                        
                        return [favouritesArray bk_any:^BOOL(id obj1) {
                            
                            MerchantModel *merchantModel2 = obj1;
                            if([merchantModel1.MerchantID isEqualToString:merchantModel2.MerchantID])
                                return YES;
                            else
                                return NO;
                        }];
                        
                    }]mutableCopy];
                    if(newannotations.count>0)
                    {
                        [favouritesArray addObjectsFromArray:newannotations];
                        [self loadMoreAnnotation:newannotations];
                    }
                    if (favouritesArray.count < totalUserListCount)
                        [merchantTable setTableFooterView:cellContainer];
                    else
                        [merchantTable setTableFooterView:nil];
                    
                    isMerchantWebserviceRunning = NO;
                    [[ProgressHud shared] hide];
                    return;
                    }
                }
                
                
                if (isLoadMorePressed) {
                    
                    NSMutableArray *newannotations = [NSMutableArray new];
                    
                    newannotations = [[_favouriteArray bk_reject:^BOOL(id obj) {
                        
                        MerchantModel *merchantModel1 = obj;
                        
                        return [favouritesArray bk_any:^BOOL(id obj1) {
                            
                            MerchantModel *merchantModel2 = obj1;
                            if([merchantModel1.MerchantID isEqualToString:merchantModel2.MerchantID])
                                return YES;
                            else
                                return NO;
                        }];
                        
                    }]mutableCopy];
                    if(newannotations.count>0)
                    {
                        [favouritesArray addObjectsFromArray:newannotations];
                    }
                }
                else
                {
                    favouritesArray = [NSMutableArray arrayWithArray:_favouriteArray];
                    lastFetchCount = 0;
                }
                
                totalUserListCount = (int)favouriteListManager.totalCount;
                
                if ((favouriteListManager.listedCount % 10) == 0) {
                    lastFetchCount = lastFetchCount + (int)favouriteListManager.listedCount;
                }
                else
                {
                    lastFetchCount = (int)favouritesArray.count;
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
                
                if ([favouriteListManager.merchantListModel.Start integerValue] == 0 && !isPullRefreshPressed) {
                    [merchantTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
            }
            break;
        }
            
        default:
        {
            break;
        }
    }
    [merchantErrorLabel setHidden:YES];
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
    
}
- (void)favouriteManager:(TLFavouriteListingManager *) favouriteListManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    switch (favouriteListManager.merchantListModel.actionType) {
        case MCSearch:
        {
            if(isKeyBoardOpen)
            {
                [searchArray removeAllObjects];
                [favouritesArray removeAllObjects];
                [searchTable reloadData];
                [merchantTable reloadData];
                
                [searchErrorLabel setText:LString(@"NO_FAVORITES_FOUND")];
                [searchErrorLabel setHidden:NO];
                
                CGRect frame = searchErrorLabel.frame;
                frame.origin.y = CGRectGetMaxY(searchbarView.frame);
                [searchErrorLabel setFrame:frame];
                
            }
            isMerchantWebserviceRunning =NO;
            [[ProgressHud shared] hide];
            [refreshControl endRefreshing];
            [merchantTable setTableFooterView:nil];
            
            break;
        }
        case MCNearBy:
        {
            CGRect frame = merchantErrorLabel.frame;
            frame.origin.y = CGRectGetMaxY(searchbarView.frame);
            [merchantErrorLabel setFrame:frame];
            
            [favouritesArray removeAllObjects];
            [merchantTable reloadData];
            isMerchantWebserviceRunning =NO;
            [[ProgressHud shared] hide];
            [refreshControl endRefreshing];
            [merchantErrorLabel setText:LString(@"NO_FAVORITES_FOUND")];
            [merchantErrorLabel setHidden:NO];
            
            
            break;
        }
        default:
        {
            break;
        }
    }
    [merchantTable setTableFooterView:nil];
    [[ProgressHud shared] hide];
}
- (void)favouriteManagerFailed:(TLFavouriteListingManager *) favouriteListManager
{
    isMerchantWebserviceRunning = NO;
    //    searchTxt.enabled = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
    
    CGRect frame = merchantErrorLabel.frame;
    frame.origin.y = CGRectGetMaxY(searchbarView.frame);
    [merchantErrorLabel setFrame:frame];
    [merchantErrorLabel setText:LString(@"SERVER_CONNECTION_ERROR")];
    [merchantErrorLabel setHidden:NO];
    [merchantTable setTableFooterView:nil];
    
}

#pragma mark - CalloutAnnotationViewDelegate

- (void)calloutButtonClicked:(NSString *)title
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"MerchantID Matches[cd] %@",title];
    NSArray *result = [favouritesArray filteredArrayUsingPredicate:pred];
    if(result.count > 0){
        MerchantModel *merchant = (MerchantModel*)[result objectAtIndex:0];
        TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
        detailsVC.merchantModel = merchant;
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
}
@end
