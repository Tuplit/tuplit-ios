//
//  TLTransferViewController.m
//  Tuplit
//
//  Created by ev_mac11 on 15/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTransferViewController.h"

@interface TLTransferViewController ()
{
    UILabel *errorLbl;
    UIView *errorView;
    
    NSMutableArray *friendsArray;
    
    UIRefreshControl *refreshControl;
    UIView *cellContainer;
    int totalUserListCount,lastFetchCount;
    
    TLFriendsListingManager *friendsManager;
    
    BOOL isLoadMorePressed,isPullRefreshPressed,isFriendsWebserviceRunning;
}

@end

@implementation TLTransferViewController

- (void)dealloc
{
    friendsManager.delegate = nil;
    friendsManager = nil;
}


#pragma mark - View Life Cycle Methods.

-(void) loadView
{
    [super loadView];
    
    [self.navigationItem setTitle:LString(@"TRANSFER")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
    [navleftButton backButtonWithTarget:self action:@selector(backToUserProfile)];
    [self.navigationItem setLeftBarButtonItem:navleftButton];
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    baseView=[[UIView alloc] initWithFrame:CGRectMake(0,0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    toTxt=[[UITextField alloc] initWithFrame:CGRectMake(15, 20, baseViewWidth-30, 45)];
    toTxt.placeholder=@"To";
    toTxt.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    toTxt.textColor=UIColorFromRGB(0x000000);
    [toTxt setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"graybg.png"]]];
    [toTxt addTarget:self action:@selector(searchSendTo:) forControlEvents:UIControlEventEditingChanged];
    toTxt.textAlignment=NSTextAlignmentLeft;
    toTxt.clearButtonMode=UITextFieldViewModeWhileEditing;
    toTxt.delegate=self;
    toTxt.tag=100;
    if(self.UserName.length!=0)
        toTxt.text = self.UserName;
    [toTxt setupForTuplitStyle];
    [baseView addSubview:toTxt];
    
    amountTxt=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(toTxt.frame), CGRectGetMaxY(toTxt.frame) + 5, CGRectGetWidth(toTxt.frame), 45)];
    amountTxt.placeholder=@"Amount";
    amountTxt.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    amountTxt.textColor=UIColorFromRGB(0x000000);
    amountTxt.textAlignment=NSTextAlignmentLeft;
    amountTxt.keyboardType=UIKeyboardTypeNumberPad;
    [amountTxt setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"graybg.png"]]];
    amountTxt.delegate=self;
    amountTxt.tag = 101;
    [amountTxt setupForTuplitStyle];
    [baseView addSubview:amountTxt];
    
    messageTxtView=[[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(toTxt.frame), CGRectGetMaxY(amountTxt.frame) + 5, CGRectGetWidth(toTxt.frame), 65)];
    messageTxtView.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    messageTxtView.textAlignment=NSTextAlignmentLeft;
    messageTxtView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentsBg.png"]];
    messageTxtView.delegate=self;
    [baseView addSubview:messageTxtView];
    
    placeholderLbl=[[UILabel alloc] initWithFrame:CGRectMake(14,2, 200, 30)];
    placeholderLbl.text=LString(@"MESSAGE_PLACE_TEXT");
    placeholderLbl.textAlignment=NSTextAlignmentLeft;
    placeholderLbl.textColor=UIColorFromRGB(0xc0c0c0);
    placeholderLbl.backgroundColor=[UIColor clearColor];
    [messageTxtView addSubview:placeholderLbl];
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(CGRectGetMinX(toTxt.frame), CGRectGetMaxY(messageTxtView.frame) + 15, CGRectGetWidth(toTxt.frame), 45)];
    [sendBtn setTitle:LString(@"SEND") forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor clearColor]];
    sendBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    [sendBtn addTarget:self action:@selector(sendDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:sendBtn];
    
    UILabel *neverDeductLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(sendBtn.frame) + 26, 290, 30)];
    neverDeductLbl.text=LString(@"NEVER_DEDUCT");
    neverDeductLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    neverDeductLbl.textColor=UIColorFromRGB(0x999999);
    neverDeductLbl.textAlignment=NSTextAlignmentCenter;
    neverDeductLbl.numberOfLines=2;
    neverDeductLbl.backgroundColor=[UIColor clearColor];
    [baseView addSubview:neverDeductLbl];
    
    int adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    toProfileNameTable=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(toTxt.frame)+5,baseViewWidth, baseViewHeight-adjustHeight-CGRectGetMaxY(toTxt.frame)-5-216)];
    toProfileNameTable.delegate=self;
    toProfileNameTable.dataSource=self;
    toProfileNameTable.hidden = YES;
    toProfileNameTable.backgroundColor=[UIColor whiteColor];
    [toProfileNameTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [baseView addSubview:toProfileNameTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    [toProfileNameTable addSubview:refreshControl];
    
    cellContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,toProfileNameTable.frame.size.width, 64)];
    [cellContainer setBackgroundColor:[UIColor clearColor]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cellContainer.frame.size.width - 30)/2, (cellContainer.frame.size.height - 30)/2, 30, 30)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [cellContainer addSubview:activity];
    
    UINavigationBar *navigationBar =[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth,40)];
    UINavigationItem *navigtionItem=[[UINavigationItem alloc] init];
    navigationBar.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:LString(@"DISMISS") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissButtonClicked:)];
    [dismiss setTintColor:UIColorFromRGB(0X009999)];
    navigtionItem.rightBarButtonItem=dismiss;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:navigtionItem, nil];
    [navigationBar setItems:array];
    amountTxt.inputAccessoryView=navigationBar;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Defined Methods.

-(void) backToUserProfile
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callTransferService
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
    NSString *string = amountTxt.text;
    NSString *transferAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    NSDictionary *queryParams = @{
                                  @"ToUserId"  : NSNonNilString(self.userID),
                                  @"Amount"    : NSNonNilString(transferAmount),
                                  @"Notes"     : NSNonNilString(messageTxtView.text),
                                  };
    
    NETWORK_TEST_PROCEDURE
    
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    TLTransferManager *transferManager = [[TLTransferManager alloc]init];
    transferManager.delegate = self;
    [transferManager callService:queryParams];
}
-(void) callFriendslistWebserviceWithstartCount:(long) start withSearchSring:(NSString*)str showProgress:(BOOL)showProgressIndicator
{
    NETWORK_TEST_PROCEDURE
    
    if (isFriendsWebserviceRunning) {
        return;
    }
    
    isFriendsWebserviceRunning = YES;
    
    if (showProgressIndicator) {
        [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    }
    if (friendsManager==nil) {
        friendsManager = [[TLFriendsListingManager alloc]init];
    }
    
    NSString *searchText;
    if(toTxt.hidden)
        searchText = @"";
    else
        searchText = str;
    
    NSDictionary *queryParams = @{
                                  @"Search"            :  NSNonNilString(searchText),
                                  @"Start"             :  NSNonNilString([NSString stringWithFormat:@"%ld",start]),
                                  };
    
    friendsManager.delegate = self;
    [friendsManager callService:queryParams];
}

-(void) refreshTableView:(id) sender {
    
    isPullRefreshPressed = YES;
    [self callFriendslistWebserviceWithstartCount:0 withSearchSring:toTxt.text showProgress:NO];
}

-(void) loadMoreFriends {
    
    if (lastFetchCount < totalUserListCount) {
        isLoadMorePressed = YES;
        [self callFriendslistWebserviceWithstartCount:lastFetchCount withSearchSring:toTxt.text showProgress:NO];
    }
}

-(void) sendDetailAction
{
    DISMISS_KEYBOARD;
    
    //    if ([messageTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    //    {
    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"TextField is Empty,\nEnter Your message" delegate:self cancelButtonTitle:LString(@"OK") otherButtonTitles:nil, nil];
    //        [alert show];
    //        return;
    //    }
    //    else
    //    {
    //
    //    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
    NSString *string = amountTxt.text;
    NSString *transferAmount;
    if(string.length>0)
        transferAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    else
        transferAmount = @"";
    
    if([toTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0 || [self.userID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
        [UIAlertView alertViewWithMessage:LString(@"SELECT_USER")];
    }
    else if(transferAmount.length==0)
    {
        [UIAlertView alertViewWithMessage:LString(@"ENTER_AMOUNT")];
    }
    else
    {
        if([TLUserDefaults getCurrentUser].Passcode)
        {
            TLPinCodeViewController *verifyPINVC = [[TLPinCodeViewController alloc]init];
            verifyPINVC.isverifyPin = YES;
            verifyPINVC.delegate = self;
            verifyPINVC.navigationTitle = LString(@"ENTER_PIN_CODE");
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:verifyPINVC];
            [nav.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            [self callTransferService];
        }
    }
    
}

-(void)checkTableData
{
    if(friendsArray.count>0)
        toProfileNameTable.hidden = NO;
    else
        toProfileNameTable.hidden = YES;
}

-(void)dismissButtonClicked:(id)sender
{
    DISMISS_KEYBOARD;
}

-(void) searchSendTo : (id) sender
{
    //    if ([toTxt.text isEqualToString:@""])
    //    {
    //        [self callFriendslistWebserviceWithstartCount:0 withSearchSring:@"" showProgress:NO];
    //        isFriendsWebserviceRunning = NO;
    //    }
}

#pragma mark - Text Field Delegates

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==100) {
        
        [self callFriendslistWebserviceWithstartCount:0 withSearchSring:textField.text showProgress:NO];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==100) {
        toProfileNameTable.hidden = YES;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.tag==100)
    {
        NSString* searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.userID = @"";
        if(searchString.length==0)
            isFriendsWebserviceRunning=NO;
        [self callFriendslistWebserviceWithstartCount:0 withSearchSring:searchString showProgress:NO];
        [self checkTableData];
        
    }
    else if(textField.tag==101)
    {
        NSInteger MAX_DIGITS = 9; // $999,999,999.99
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setMinimumFractionDigits:0];
        [numberFormatter setMaximumFractionDigits:0];
        
        NSLocale *english = [[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"];
        [numberFormatter setLocale:english];
        
        NSString *stringMaybeChanged = [NSString stringWithString:string];
        if (stringMaybeChanged.length > 1)
        {
            NSMutableString *stringPasted = [NSMutableString stringWithString:stringMaybeChanged];
            
            [stringPasted replaceOccurrencesOfString:numberFormatter.currencySymbol
                                          withString:@""
                                             options:NSLiteralSearch
                                               range:NSMakeRange(0, [stringPasted length])];
            
            [stringPasted replaceOccurrencesOfString:numberFormatter.groupingSeparator
                                          withString:@""
                                             options:NSLiteralSearch
                                               range:NSMakeRange(0, [stringPasted length])];
            
            NSDecimalNumber *numberPasted = [NSDecimalNumber decimalNumberWithString:stringPasted];
            stringMaybeChanged = [numberFormatter stringFromNumber:numberPasted];
        }
        
        UITextRange *selectedRange = [textField selectedTextRange];
        UITextPosition *start = textField.beginningOfDocument;
        NSInteger cursorOffset = [textField offsetFromPosition:start toPosition:selectedRange.start];
        NSMutableString *textFieldTextStr = [NSMutableString stringWithString:textField.text];
        NSUInteger textFieldTextStrLength = textFieldTextStr.length;
        
        [textFieldTextStr replaceCharactersInRange:range withString:stringMaybeChanged];
        
        [textFieldTextStr replaceOccurrencesOfString:numberFormatter.currencySymbol
                                          withString:@""
                                             options:NSLiteralSearch
                                               range:NSMakeRange(0, [textFieldTextStr length])];
        
        [textFieldTextStr replaceOccurrencesOfString:numberFormatter.groupingSeparator
                                          withString:@""
                                             options:NSLiteralSearch
                                               range:NSMakeRange(0, [textFieldTextStr length])];
        
        [textFieldTextStr replaceOccurrencesOfString:numberFormatter.decimalSeparator
                                          withString:@""
                                             options:NSLiteralSearch
                                               range:NSMakeRange(0, [textFieldTextStr length])];
        
        if (textFieldTextStr.length <= MAX_DIGITS)
        {
            NSDecimalNumber *textFieldTextNum = [NSDecimalNumber decimalNumberWithString:textFieldTextStr];
            NSDecimalNumber *divideByNum = [[[NSDecimalNumber alloc] initWithInt:10] decimalNumberByRaisingToPower:numberFormatter.maximumFractionDigits];
            
            if([[NSString stringWithFormat:@"%@",textFieldTextNum] isEqualToString:@"NaN"])
            {
                textField.text = [NSString stringWithFormat:@""];
                return NO;
            }
            
            NSDecimalNumber *textFieldTextNewNum = [textFieldTextNum decimalNumberByDividingBy:divideByNum];
            NSString *textFieldTextNewStr = [numberFormatter stringFromNumber:textFieldTextNewNum];
            
            textField.text = textFieldTextNewStr;
            
            if (cursorOffset != textFieldTextStrLength)
            {
                NSInteger lengthDelta = textFieldTextNewStr.length - textFieldTextStrLength;
                NSInteger newCursorOffset = MAX(0, MIN(textFieldTextNewStr.length, cursorOffset + lengthDelta));
                UITextPosition* newPosition = [textField positionFromPosition:textField.beginningOfDocument offset:newCursorOffset];
                UITextRange* newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
                [textField setSelectedTextRange:newRange];
            }
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - Text View Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeholderLbl.hidden=YES;
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        placeholderLbl.hidden=NO;
    }
    [textView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@""])
    {
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            placeholderLbl.hidden=NO;
            return NO;
        }
    }
    else
    {
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            placeholderLbl.hidden=YES;
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Scroll View Delegate Method

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    
    if (offset >= 0.0 && offset <= 50.0) {
        
        [self loadMoreFriends];
    }
}

#pragma mark - Table View Delegate Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendsArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PROFILE_CELL_HEIGHT;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    [cell.s]
    
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        EGOImageView *profileImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(16, 2, 50, PROFILE_CELL_HEIGHT -5 )];
        profileImgView.backgroundColor = [UIColor whiteColor];
        profileImgView.layer.cornerRadius=50/2;
        profileImgView.userInteractionEnabled=YES;
        profileImgView.clipsToBounds=YES;
        profileImgView.tag=1000;
        [cell.contentView addSubview:profileImgView];
        
        UILabel *profileNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame) +80 ,0, 175,PROFILE_CELL_HEIGHT)];
        profileNameLbl.textColor=UIColorFromRGB(0x333333);
        profileNameLbl.numberOfLines=0;
        profileNameLbl.tag=1001;
        profileNameLbl.textAlignment=NSTextAlignmentLeft;
        profileNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        profileNameLbl.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:profileNameLbl];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(profileNameLbl.frame) + 5, baseViewWidth - 75, 1)];
        lineView.backgroundColor=UIColorFromRGB(0xCCCCCC);
        [cell.contentView addSubview:lineView];
    }
    
    FriendsListModel *friendsList = [friendsArray objectAtIndex:indexPath.row];
    
    EGOImageView *profileImgView=(EGOImageView *)[cell.contentView viewWithTag:1000];
    UILabel *profileNameLbl=(UILabel *)[cell.contentView viewWithTag:1001];
    
    profileImgView.imageURL = [NSURL URLWithString:friendsList.Photo];
    profileNameLbl.text=[[NSString stringWithFormat:@"%@ %@",friendsList.FirstName,friendsList.LastName]stringWithTitleCase];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListModel *friendsList = [friendsArray objectAtIndex:indexPath.row];
    toTxt.text=[[NSString stringWithFormat:@"%@ %@",friendsList.FirstName,friendsList.LastName]stringWithTitleCase];
    self.userID = friendsList.Id;
    [toTxt resignFirstResponder];
    toProfileNameTable.hidden=YES;
}

#pragma  mark - TLPinCodeVerifiedDelegate
-(void)pincodeVerified
{
    [self callTransferService];
}

#pragma mark - TLFriendsListingManager
- (void)friendsListingManagerSuccess:(TLFriendsListingManager *)friendsListingManager withFriendsListingManager:(NSArray*) _friendsList
{
    errorView.hidden = YES;
    if (isLoadMorePressed) {
        
        [friendsArray addObjectsFromArray:_friendsList];
    }
    else
    {
        friendsArray = [NSMutableArray arrayWithArray:_friendsList];
        lastFetchCount = 0;
    }
    [self checkTableData];
    totalUserListCount = friendsListingManager.totalCount;
    
    if ((friendsListingManager.listedCount % 20) == 0) {
        lastFetchCount = lastFetchCount + friendsListingManager.listedCount;
    }
    else
    {
        lastFetchCount = friendsArray.count;
    }
    
    [toProfileNameTable reloadData];
    
    if (lastFetchCount < totalUserListCount)
        [toProfileNameTable setTableFooterView:cellContainer];
    else
        [toProfileNameTable setTableFooterView:nil];
    
    isPullRefreshPressed = NO;
    isLoadMorePressed = NO;
    isFriendsWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)friendsListingManager:(TLFriendsListingManager *)friendsListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    errorView.hidden = NO;
    errorLbl.text = errorMsg;
    
    [friendsArray removeAllObjects];
    [toProfileNameTable reloadData];
    isFriendsWebserviceRunning =NO;
    [toProfileNameTable setTableFooterView:nil];
    
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}
- (void)friendsListingManagerFailed:(TLFriendsListingManager *)friendsListingManager
{
    errorView.hidden = NO;
    errorLbl.text = LString(@"SERVER_CONNECTION_ERROR");
    
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    
    [toProfileNameTable setTableFooterView:nil];
    
    isFriendsWebserviceRunning = NO;
    [[ProgressHud shared] hide];
    [refreshControl endRefreshing];
}

#pragma  mark - TLTransferManager Delegate Methods

- (void)transferManagerSuccessfull:(TLTransferManager *)transferManager withStatus:(NSString*)transferStatus
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [UIAlertView alertViewWithMessage:transferStatus];
    [[ProgressHud shared] hide];
    [self backToUserProfile];
}
- (void)transferManager:(TLTransferManager *)transferManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [UIAlertView alertViewWithMessage:errorMsg];
    [[ProgressHud shared] hide];
}
- (void)transferManagerFailed:(TLTransferManager *)transferManager
{
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    [[ProgressHud shared] hide];
}
@end

