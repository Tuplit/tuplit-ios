//
//  TLCategoryViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 22/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCategoryViewController.h"
#import "PinAnnotation.h"

@implementation TLCategoryViewController
@synthesize categoryId,navTitle;

- (void)dealloc
{
    merchantListingManager.delegate = nil;
    merchantListingManager = nil;
}

- (void)loadView {
    
    [super loadView];
    [self.navigationItem setTitle:navTitle];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn buttonWithIcon:getImage(@"back_arrow", NO) target:self action:@selector(backButtonAction) isLeft:YES];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    rightExpandButton = [[UIBarButtonItem alloc] init];
    [rightExpandButton buttonWithIcon:getImage(@"CtgmapIcon", NO) target:self action:@selector(mapIconImgViewAction:) isLeft:NO];
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
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0,0, baseView.frame.size.width, baseView.frame.size.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:contentView];
    
    merchantTable = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(menuView.frame),baseViewWidth,baseViewHeight-CGRectGetMaxY(menuView.frame) - adjustHeight)];
    merchantTable.dataSource = self;
    merchantTable.delegate = self;
    merchantTable.tag = 1004;
    merchantTable.hidden = NO;
    [merchantTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [contentView addSubview:merchantTable];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,CGRectGetHeight(merchantTable.frame))];
    mapView.mapType = MKMapTypeStandard;
    mapView.userInteractionEnabled = YES;
    mapView.delegate = self;
    mapView.hidden = YES;
    [contentView addSubview:mapView];
    
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
    
    merchantErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, merchantTable.frame.size.width, merchantTable.frame.size.height)];
    [merchantErrorLabel setBackgroundColor:[UIColor whiteColor]];
    [merchantErrorLabel setTextAlignment:NSTextAlignmentCenter];
    [merchantErrorLabel setTextColor:[UIColor lightGrayColor]];
    [merchantErrorLabel setText:@"No merchants found."];
    [merchantErrorLabel setHidden:YES];
    [contentView addSubview:merchantErrorLabel];
    
    merchantsArray = [[NSMutableArray alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    merchantListingModel = [[TLMerchantListingModel alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callMerchantWebserviceWithActionType:0 showProgressIndicator:YES];

}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UserDefined methods

-(void) callMerchantWebserviceWithActionType:(long) start showProgressIndicator:(BOOL) showProgressIndicator
{
    
    NETWORK_TEST_PROCEDURE
    
    if (isMerchantWebserviceRunning) {
        return;
    }
    
    isMerchantWebserviceRunning = YES;
    
    if(showProgressIndicator)
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    merchantListingManager = [[TLMerchantListingManager alloc] init];
    
    merchantListingModel.Latitude = [NSString stringWithFormat:@"%lf",[CurrentLocation latitude]];
    merchantListingModel.Longitude = [NSString stringWithFormat:@"%lf",[CurrentLocation longitude]];
    
    merchantListingModel.Category = categoryId;
    merchantListingModel.Type = [NSString stringWithFormat:@"%d",0];
    merchantListingModel.Start = [NSString stringWithFormat:@"%ld",start];
    merchantListingModel.SearchKey = @"";
    
    merchantListingManager.delegate = self;
    [merchantListingManager callService:merchantListingModel];
}

- (void) mapIconImgViewAction: (id) sender
{
    if(merchantsArray.count>0)
    {
        [searchErrorLabel setHidden:YES];
        [self.view endEditing:YES];
        
        isMapShown=!isMapShown;
        
        if (!isMapShown)
        {
            [rightExpandButton buttonWithIcon:getImage(@"CtgmapIcon", NO) target:self action:@selector(mapIconImgViewAction:) isLeft:NO];
            merchantTable.hidden = NO;
            mapView.hidden = YES;
        }
        else
        {
            [rightExpandButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(mapIconImgViewAction:) isLeft:NO];
            merchantTable.hidden = YES;
            mapView.hidden = NO;
            
            [self addMapAnnotations];
        }
        if (searchTable.hidden == NO) {
            searchTable.hidden = YES;
        }
    }
}
-(void) addMapAnnotations {
    
    if(isMapShown)
    {
        [mapView removeAnnotations:mapView.annotations];
        
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
            pinAnnotation.subtitle = merchantModel.TagType;
            [mapView addAnnotation:pinAnnotation];
        }
        
        if(isnearBy)
        {
            if([CurrentLocation latitude]!=999&&[CurrentLocation longitude]!=999)
            {
                MKCoordinateRegion region = { {0.0, 0.0 }, {0.0, 0.0 } };
                CLLocationCoordinate2D coord = {.latitude = [CurrentLocation latitude], .longitude =  [CurrentLocation longitude]};
                MKCoordinateSpan span = {.latitudeDelta =  0.1, .longitudeDelta =  0.1};
                region.center = coord;
                region.span = span;
                //                 region = {coord, span};
                [mapView setRegion:region];
            }
        }
        else
        {
            MKMapRect zoomRect = MKMapRectNull;
            for (id <MKAnnotation> annotation in mapView.annotations)
            {
                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.5, 0.5);
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
            [mapView setVisibleMapRect:zoomRect animated:YES];
        }
    }
}


-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    searchTxt.text = @"";
    
        [self callMerchantWebserviceWithActionType:0 showProgressIndicator:NO];
}

-(void) loadMoreUsers {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self callMerchantWebserviceWithActionType:lastFetchCount showProgressIndicator:NO];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
        
        //        NSPredicate *pred = [NSPredicate predicateWithFormat:@"MerchantID Matches[cd] %@",annotation.title];
        //        NSArray *result = [merchantsArray filteredArrayUsingPredicate:pred];
        //        if(result.count > 0){
        //            MerchantModel *merchant = (MerchantModel*)[result objectAtIndex:0];
        //
        //            UIImage *annImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:merchant.Icon]]];
        //            annImg = [self  imageWithImage:annImg scaledToSize:CGSizeMake(40, 40)];
        //            annotationView.image = annImg;
        //        }
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
        NSArray *result = [merchantsArray filteredArrayUsingPredicate:pred];
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
        NSArray *result = [merchantsArray filteredArrayUsingPredicate:pred];
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

#pragma mark - UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [merchantsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MERCHANT_CELL_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Merchants";
    
        MerchantsCell *merchantsCell = (MerchantsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(merchantsCell == nil) {
            
            merchantsCell = [[MerchantsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            merchantsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            merchantsCell.backgroundColor = [UIColor clearColor];
            
        }
        
        MerchantModel *merchantModel = [merchantsArray objectAtIndex:indexPath.row];
        [merchantsCell setMerchant:merchantModel];
        
        return merchantsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantModel *merchantModel = [merchantsArray objectAtIndex:indexPath.row];
    
    TLMerchantsDetailViewController *detailsVC = [[TLMerchantsDetailViewController alloc] init];
    detailsVC.merchantModel = merchantModel;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    
    if (offset >= 0.0 && offset <= 50.0) {
        
        [self loadMoreUsers];
    }
}


#pragma mark - TLMerchantListingManagerDelegate

- (void)merchantListingManager:(TLMerchantListingManager *)_merchantListingManager withMerchantList:(NSArray*) _merchantsArray {
    
    if (isLoadMorePressed) {
        
        [merchantsArray addObjectsFromArray:_merchantsArray];
    }
    else
    {
        merchantsArray = [NSMutableArray arrayWithArray:_merchantsArray];
        lastFetchCount = 0;
    }
    
        totalUserListCount = (int)_merchantListingManager.totalCount;
        
        if ((_merchantListingManager.listedCount % 10) == 0) {
            lastFetchCount = lastFetchCount + (int)_merchantListingManager.listedCount;
        }
        else
        {
            lastFetchCount = (int)merchantsArray.count;
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
    
    [searchErrorLabel setHidden:YES];
    [merchantErrorLabel setHidden:YES];
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isMerchantWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}

- (void)merchantListingManager:(TLMerchantListingManager *)_merchantListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    
        [merchantErrorLabel setText:errorMsg];
        [merchantErrorLabel setHidden:NO];
        
        CGRect frame = merchantErrorLabel.frame;
        frame.origin.y = CGRectGetMaxY(menuView.frame);
        [merchantErrorLabel setFrame:frame];
        
        [merchantsArray removeAllObjects];
        [merchantTable reloadData];
        

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
