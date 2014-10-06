//
//  TLEditProfileViewController.m
//  Tuplit
//
//  Created by ev_mac8 on 19/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLEditProfileViewController.h"

@interface TLEditProfileViewController ()
{
    BOOL isUserInfoEdited,isPictureUpdated;
    UIImagePickerController *imagePicker;
}

@end

@implementation TLEditProfileViewController
@synthesize userDetail,pincode,user;

#pragma mark - View Life Cycle Methods.

-(void)dealloc
{
    editProfileTable.editing = NO;
}

-(void) loadView
{
    [super loadView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.navigationItem setTitle:LString(@"EDIT_MY_PROFILE")];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton buttonWithIcon:getImage(@"close", NO) target:self action:@selector(backUserProfilePage:) isLeft:NO];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] init];
    [navRightButton buttonWithIcon:getImage(@"done", NO) target:self action:@selector(updateProfile:) isLeft:NO];
    [self.navigationItem setRightBarButtonItem:navRightButton];
    
    baseViewWidth=self.view.frame.size.width;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        baseViewHeight= self.view.frame.size.height-64;
    else
        baseViewHeight= self.view.frame.size.height-44;
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:baseView];
    
    editProfileTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0, baseViewWidth,baseViewHeight)];
    editProfileTable.backgroundColor=[UIColor clearColor];
    editProfileTable.delegate=self;
    editProfileTable.dataSource=self;
    editProfileTable.separatorColor=[UIColor whiteColor];
    editProfileTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        editProfileTable.delaysContentTouches = NO;
    editProfileTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, editProfileTable.frame.size.width, 20)];
    [baseView addSubview:editProfileTable];
    
    user = [[UserModel alloc]init];
    nameDict = [[NSMutableDictionary alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateTabledata];
    
    isPictureUpdated = NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    isUserInfoEdited = NO;
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    
    if (APP_DELEGATE.isUserProfileEdited) {
        APP_DELEGATE.isUserProfileEdited = NO;
        [self callService];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods

-(void)callService
{
    NETWORK_TEST_PROCEDURE
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLUserDetailsManager *usermanager = [[TLUserDetailsManager alloc]init];
    usermanager.delegate = self;
    [usermanager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
}

//   Credit card delete service
-(void)callCardDeleteService
{
    NETWORK_TEST_PROCEDURE
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLCreditCardDeleteManager *cardDeletemanager = [[TLCreditCardDeleteManager alloc]init];
    cardDeletemanager.delegate = self;
    [cardDeletemanager deleteCreditCard:@""];
}

-(void)updateTabledata
{
    self.user.PinCode = [TLUserDefaults getCurrentUser].PinCode;
    NSArray *recentActivityArray = [[NSArray alloc] init];
    NSArray *commentsArray = [[NSArray alloc] init];
    NSArray *UserLinkedCardsArray = [[NSArray alloc]init];
    
    if(self.userDetail.UserLinkedCards.count>0)
    {
        UserLinkedCardsArray = self.userDetail.UserLinkedCards;
    }
    if(self.userDetail.Orders.count>0)
    {
        recentActivityArray = self.userDetail.Orders;
    }
    
    if(self.userDetail.comments.count>0)
    {
        commentsArray = self.userDetail.comments;
    }
    
    mainDict = @{
                 @"My Comments":commentsArray,
                 @"Credit Cards":UserLinkedCardsArray,
                 };
    
    UserModel *usermodel = [TLUserDefaults getCurrentUser];
    [nameDict setValue:usermodel.FirstName forKey:kFirstName];
    [nameDict setValue:usermodel.LastName forKey:kLastName];
    [nameDict setValue:usermodel.Photo forKey:kPhoto];
    
    sectionHeader = [NSArray arrayWithObjects:@"User Details",@"Credit Cards",@"My Comments", nil];
    [editProfileTable reloadData];
}

-(void) addCreditCardAction
{
    TLAddCreditCardViewController *addCrCardViewController=[[TLAddCreditCardViewController alloc]init];
    addCrCardViewController.viewController = self;
    [self.navigationController pushViewController:addCrCardViewController animated:YES];
}

-(void) backUserProfilePage: (id) sender
{
    if(isUserInfoEdited)
    {
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:userDetail forKey:@"UserEditedInfo"];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"UPDATE_EDITED_DETAILS" object:self userInfo:userInfo];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath
{
    if ([swipeIndexPath compare:indexPath] != NSOrderedSame)
    {
        EditProfileCell *currentSwipeCell = (EditProfileCell *)[editProfileTable cellForRowAtIndexPath:swipeIndexPath];
        [currentSwipeCell didSwipeLeftInCell:self];
    }
    swipeIndexPath = indexPath;
}

-(void) updateProfile : (id) sender
{
    UITableViewCell *cell = [editProfileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *firstNameTxt=(UITextField *) [cell.contentView viewWithTag:3000];
    UITextField *lastNameTxt=(UITextField *) [cell.contentView viewWithTag:3001];
    EGOImageView *profileImgView=(EGOImageView *) [cell.contentView viewWithTag:3002];
    
    if([[[nameDict valueForKey:kFirstName]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        [self showAlertWithMessage:LString(@"ENTER_FITST_NAME")];
    if([[[nameDict valueForKey:kLastName]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]== 0)
        [self showAlertWithMessage:LString(@"ENTER_LAST_NAME")];
    else
    {
        self.user.FirstName = firstNameTxt.text;
        self.user.LastName =  lastNameTxt.text;
        self.user.Email = [TLUserDefaults getCurrentUser].Email;
        
        if(isPictureUpdated)
            self.user.userImage = profileImgView.image;
        
        NETWORK_TEST_PROCEDURE
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
        
        TLEditUpdateManager *editManager = [[TLEditUpdateManager alloc]init];
        editManager.delegate = self;
        editManager.user = self.user;
        [editManager updateUser];
    }
}

-(void) pinCodeAction : (id) sender
{
    TLPinCodeViewController *pincodeVC = [[TLPinCodeViewController alloc]init];
    pincodeVC.navigationTitle = LString(@"ENTER_PIN_CODE");
    pincodeVC.isverifyPin = NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pincodeVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)takePhoto {
    
    UIActionSheet *actionSheet;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LString(@"CANCEL") destructiveButtonTitle:nil otherButtonTitles:
                       LString(@"TAKE_PHOTO"),
                       LString(@"EXISTING_PHOTO"),
                       nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LString(@"CANCEL") destructiveButtonTitle:nil otherButtonTitles:
                       LString(@"EXISTING_PHOTO"),
                       nil];
    }
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:APP_DELEGATE.defaultColor forState:UIControlStateNormal];
        }
    }
    
    [actionSheet showInView:self.view];
}

- (void)takePictureAction
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate=self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self presentViewController:imagePicker animated:YES completion:^{
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }];
        
    } else {
        
        [UIAlertView alertViewWithMessage:LString(@"NO_VALID_CAMERA")];
    }
}

- (void)takePhotoLibraryAction
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        [[imagePicker navigationBar] setTintColor:[UIColor whiteColor]];
    else
        [[imagePicker navigationBar] setTintColor:APP_DELEGATE.defaultColor];
    [[imagePicker navigationBar] setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    
    imagePicker.allowsEditing = NO;
    imagePicker.wantsFullScreenLayout = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)showAlertWithMessage :(NSString*)message {
    
    [UIAlertView alertViewWithMessage:message];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionHeader count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1) {
        
        NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:section]];
        
        if (creditCardArray.count > 0) {
            
            return creditCardArray.count;
        }
        else
        {
            return 1;
        }
    }
    else {
        
        return [[mainDict valueForKey:[sectionHeader objectAtIndex:section]]count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
        return 212;
    }
    else if(indexPath.section==2)
    {
        UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        float cmtLblHeight = [comments.CommentsText heigthWithWidth:self.view.frame.size.width-120 andFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        return cmtLblHeight + 25;
    }
    else
    {
        return PROFILE_CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if(section == 1) {
        
        return HEADER_HEIGHT;
    }
    else
    {
        if([[mainDict valueForKey:[sectionHeader objectAtIndex:section]]count] > 0)
            return HEADER_HEIGHT;
        else
            return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *leftHeaderNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15,0,150,HEADER_HEIGHT)];
    leftHeaderNameLbl.textColor = UIColorFromRGB(0x00b3a4);
    leftHeaderNameLbl.textAlignment=NSTextAlignmentLeft;
    leftHeaderNameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    leftHeaderNameLbl.backgroundColor=[UIColor clearColor];
    leftHeaderNameLbl.text = [sectionHeader objectAtIndex:section];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headerBtn.frame = CGRectMake(CGRectGetMaxX(leftHeaderNameLbl.frame),0,140,HEADER_HEIGHT);
    headerBtn.backgroundColor = [UIColor clearColor];
    headerBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    headerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    headerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIImage * topUpImage = getImage(@"btn_img", NO);
    UIImage * stretchableTopUpImage = [topUpImage stretchableImageWithLeftCapWidth:9 topCapHeight:0];
    
    [headerBtn setBackgroundImage:stretchableTopUpImage forState:UIControlStateNormal];
    [headerBtn setBackgroundImage:stretchableTopUpImage forState:UIControlStateHighlighted];
    [headerBtn setBackgroundImage:stretchableTopUpImage forState:UIControlStateSelected];
    
    [headerBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    if(section == 1)
    {
        [headerBtn setTitle: LString(@"ADD_CREDIT_CARD") forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(addCreditCardAction) forControlEvents:UIControlEventTouchUpInside];
        float btnWidth = [LString(@"ADD_CREDIT_CARD") widthWithFont:headerBtn.titleLabel.font]+2;
        headerBtn.width = btnWidth;
        [headerBtn positionAtX:baseViewWidth-btnWidth-15];
    }
    
    else if(section == 2)
    {
        [headerBtn setTitle: LString(@"SWIPE_TO_DELETE") forState:UIControlStateNormal];
        //        [headerBtn addTarget:self action:@selector(addCreditCardAction) forControlEvents:UIControlEventTouchUpInside];
        float btnWidth = [LString(@"SWIPE_TO_DELETE") widthWithFont:headerBtn.titleLabel.font]+2;
        headerBtn.width = btnWidth;
        headerBtn.enabled = NO;
        [headerBtn positionAtX:baseViewWidth-btnWidth-15];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:leftHeaderNameLbl];
    [headerView addSubview:headerBtn];
    [tableView addSubview:headerView];
    return  headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifire[]={@"User Details",@"Credit Cards",@"My Comments",nil};
    
    EditProfileCell *cell = (EditProfileCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire[indexPath.section]];
    
    if (cell == nil)
    {
        cell = [[EditProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire[indexPath.section]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.indexPaths=indexPath;
    cell.delegate=self;
    
    if (indexPath.section == 0)
    {
        UITextField *firstNameTxt=(UITextField *) [cell.contentView viewWithTag:3000];
        UITextField *lastNameTxt=(UITextField *) [cell.contentView viewWithTag:3001];
        EGOImageView *profileImgView=(EGOImageView *) [cell.contentView viewWithTag:3002];
        UIButton *newPincodeBtn=(UIButton *) [cell.contentView viewWithTag:3003];
        
        UITapGestureRecognizer *takePhotoGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
        [profileImgView addGestureRecognizer:takePhotoGesture];
        
        
        firstNameTxt.text = [nameDict valueForKeyPath:kFirstName];
        firstNameTxt.delegate = self;
        
        lastNameTxt.text = [nameDict valueForKey:kLastName];
        lastNameTxt.delegate = self;
        
        if([[nameDict valueForKey:kTPhoto] isKindOfClass:[UIImage class]])
            profileImgView.image = (UIImage*)[nameDict valueForKey:kTPhoto];
        else
            profileImgView.imageURL = [NSURL URLWithString:[nameDict valueForKey:kPhoto]];
        
        [newPincodeBtn addTarget:self action:@selector(pinCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (indexPath.section == 1)
    {
        NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
        
        if (creditCardArray.count > 0) {
            
            CreditCardModel *creditCard = [creditCardArray objectAtIndex:indexPath.row];
            
            EGOImageView *cardImgView=(EGOImageView *) [cell.contentView viewWithTag:1000];
            UILabel *cardNumberLbl=(UILabel *) [cell.contentView viewWithTag:1001];
            UILabel *expiryDateLbl=(UILabel *) [cell.contentView viewWithTag:1002];
            UILabel *noCardLbl = (UILabel *) [cell.contentView viewWithTag:1003];
            
            noCardLbl.hidden  = YES;
            
            cardImgView.image=[UIImage imageNamed:@""];
            
            NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CARDAMEX];
            NSString *cardNum;
            if ([predicate evaluateWithObject:creditCard.CardNumber])
            {
                cardNum = [TuplitConstants filteredPhoneStringFromString:creditCard.CardNumber withFilter:CARDAMEX];
            }
            else
            {
                cardNum = [TuplitConstants filteredPhoneStringFromString:creditCard.CardNumber withFilter:CARDDEFAULT];
            }
            
            cardImgView.imageURL = [NSURL URLWithString:creditCard.Image];
            cardNumberLbl.text= cardNum;
            expiryDateLbl.text=[TuplitConstants filteredPhoneStringFromString:creditCard.ExpirationDate withFilter:DATEFORMAT];
        }
        else
        {
            EGOImageView *cardImgView=(EGOImageView *) [cell.contentView viewWithTag:1000];
            UILabel *cardNumberLbl=(UILabel *) [cell.contentView viewWithTag:1001];
            UILabel *expiryDateLbl=(UILabel *) [cell.contentView viewWithTag:1002];
            UILabel *noCardLbl = (UILabel *) [cell.contentView viewWithTag:1003];
            
            cardImgView.image = nil;
            cardNumberLbl.text= @"";
            expiryDateLbl.text=@"";
            
            
            noCardLbl.hidden  = NO;
            noCardLbl.text = @"No Credit Cards Added";
        }
    }
    else if (indexPath.section == 2)
    {
        EGOImageView *merchantIconImgView=(EGOImageView *) [cell.contentView viewWithTag:2000];
        UILabel *merchantNameLbl=(UILabel *) [cell.contentView viewWithTag:2001];
        UILabel *commentLbl=(UILabel *) [cell.contentView viewWithTag:2002];
        UILabel *totalDaysLbl=(UILabel *) [cell.contentView viewWithTag:2003];
        
        UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
        merchantIconImgView.imageURL = [NSURL URLWithString:comments.MerchantIcon];
        merchantNameLbl.text=comments.MerchantName;
        
        commentLbl.text = comments.CommentsText;
        float cmtLblHeight = [commentLbl.text heigthWithWidth:commentLbl.frame.size.width andFont:commentLbl.font];
        CGRect newRect = commentLbl.frame;
        newRect.size.height = cmtLblHeight;
        commentLbl.frame = newRect;
        
        totalDaysLbl.text=[TuplitConstants calculateTimeDifference:comments.CommentDate];
        int timeLblWidth = [totalDaysLbl.text widthWithFont:totalDaysLbl.font]+1;
        totalDaysLbl.frame =  CGRectMake(cell.frame.size.width-timeLblWidth-16,15, timeLblWidth, 20);
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2||indexPath.section == 1)
    {
        if (indexPath.section == 1)
        {
            NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
            if (creditCardArray.count > 0)
                return YES;
            else
                return NO;
        }
        return YES;
    }
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //            NETWORK_TEST_PROCEDURE
            //            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            //            sage:@"Deleting a Credit Card is under construction. Will be available in future demos."];
            NETWORK_TEST_PROCEDURE
            
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            
            NSArray *creditCardArray = [mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]];
            
            if (creditCardArray.count > 0) {
                
                CreditCardModel *creditCard = [creditCardArray objectAtIndex:indexPath.row];
                TLCreditCardDeleteManager *cardDeletemanager = [[TLCreditCardDeleteManager alloc]init];
                cardDeletemanager.delegate = self;
                [cardDeletemanager deleteCreditCard:creditCard.Id];
            }
            
        }
    }
    else if (indexPath.section == 2)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NETWORK_TEST_PROCEDURE
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
            
            UserCommentsModel *comments = [[mainDict valueForKey:[sectionHeader objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
            TLCommentDeleteManager *commentManager = [[TLCommentDeleteManager alloc]init];
            [commentManager setDelegate:self];
            [commentManager deleteComment:comments.CommentId];
            [self.view endEditing:YES];
        }
    }
}

#pragma mark - Text Field Delegate Methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==3000)
        [nameDict setValue:textField.text forKey:kFirstName];
    else if(textField.tag==3001)
        [nameDict setValue:textField.text forKey:kLastName];
}
#pragma mark - Scroll View delegate methods
// Change Default Scrolling Behavior of TableView Section
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    CGFloat sectionHeaderHeight = HEADER_HEIGHT;
    if (_scrollView.contentOffset.y<=sectionHeaderHeight&&_scrollView.contentOffset.y>=0) {
        _scrollView.contentInset = UIEdgeInsetsMake(-_scrollView.contentOffset.y, 0, 0, 0);
    } else if (_scrollView.contentOffset.y>=sectionHeaderHeight) {
        _scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UIImagePickerViewController Delegate

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    PhotoMoveAndScaleController *photoMove=[[PhotoMoveAndScaleController alloc]initWithImage:image imageCropperType:kImageCropperTypeProfileImage];
	[photoMove setDelegate:self];
    [Picker pushViewController:photoMove animated:YES];
}

- (void)onEditCancelledCropperType:(ImageCropperType)imageCropperType
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)onEditCompletedWithOriginalImage:(UIImage *)_originalImage thumbnailImage:(UIImage *)_thumbnailImage imageCropperType:(ImageCropperType)imageCropperType
{
    UITableViewCell *cell = [editProfileTable cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:0 inSection:0]];
    EGOImageView *profileImgView = (EGOImageView *)[cell.contentView viewWithTag:3002];
    [nameDict setValue:_thumbnailImage forKey:kTPhoto];
    profileImgView.image=_thumbnailImage;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    isPictureUpdated = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}


#pragma mark - Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if(buttonIndex == 0)
            [self takePictureAction];
        else if(buttonIndex == 1)
            [self takePhotoLibraryAction];
    }
    else
    {
        if(buttonIndex == 0)
            [self takePhotoLibraryAction];
    }
}

#pragma  mark - TLUserDetailManager Delegate Methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_
{
    isUserInfoEdited = YES;
    self.userDetail = userDetail_;
    [self updateTabledata];
    [[ProgressHud shared] hide];
}
- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma mark - TLEditUpdateManagerDelegate methods

- (void)editUpManager:(TLEditUpdateManager *)signUpManager updateSuccessfullWithUser:(UserModel *)user
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [self backUserProfilePage:nil];
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"PROFILE_UPDATED")];
}
- (void)editUpManager:(TLEditUpdateManager *)signUpManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)editUpManagerFailed:(TLEditUpdateManager *)signUpManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma  mark - TLCommentDeleteManager Delegate Methods

- (void)commentDeleteManagerSuccess:(TLCommentDeleteManager *)loginManager
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [self callService];
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

#pragma  mark - TLCreditCardDeleteManager Delegate Methods


- (void)creditCardDeleteManagerSuccess:(TLCreditCardDeleteManager *)creditCardDeleteManager
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [self callService];
}
- (void)creditCardDeleteManager:(TLCreditCardDeleteManager *)creditCardDeleteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)creditCardDeleteManagerFailed:(TLCreditCardDeleteManager *)creditCardDeleteManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

@end
