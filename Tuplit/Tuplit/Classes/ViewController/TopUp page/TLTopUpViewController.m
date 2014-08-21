//
//  TopUpViewController2.m
//  Tuplit
//
//  Created by ev_mac8 on 13/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLTopUpViewController.h"
#import "TLUserProfileViewController.h"
#import "TLCartViewController.h"

@interface TLTopUpViewController ()
{
    UIButton *addCreditCardBtn;
}

@end

#define SCROLL_ENABLE 6
@implementation TLTopUpViewController

@synthesize userdeatilmodel;

-(void) loadView
{
    [super loadView];
    [self.navigationItem setTitle:LString(@"TOP_UP_TITLE")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if([self.viewController isKindOfClass:[TLCartViewController class]]||[self.viewController isKindOfClass:[TLTransferViewController class]])
    {
        UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
        [navleftButton buttonWithIcon:getImage(@"List", NO) target:self action:@selector(presentLeftMenuViewController:) isLeft:NO];
        [self.navigationItem setLeftBarButtonItem:navleftButton];
        [self callService];
    }
    else
    {
        UIBarButtonItem *navleftButton = [[UIBarButtonItem alloc] init];
        [navleftButton backButtonWithTarget:self action:@selector(backToUserProfile)];
        [self.navigationItem setLeftBarButtonItem:navleftButton];
    }
    
    baseViewWidth=self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    UILabel *selectTopUpLbl=[[UILabel alloc] initWithFrame:CGRectMake(14, 0, baseViewWidth-28, 50)];
    selectTopUpLbl.text=LString(@"SELECT_TOP_UP_AMOUNT");
    selectTopUpLbl.textColor=UIColorFromRGB(0x999999);
    selectTopUpLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    selectTopUpLbl.textAlignment=NSTextAlignmentLeft;
    selectTopUpLbl.backgroundColor=[UIColor clearColor];
    [baseView addSubview:selectTopUpLbl];
    
    UIView *buttonView = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectTopUpLbl.frame), baseViewWidth, 45)];
    buttonView.backgroundColor = [UIColor clearColor];
    [baseView addSubview:buttonView];
    
    tenRupeeTopUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [tenRupeeTopUpBtn setFrame:CGRectMake(14, 0,94,CGRectGetHeight(buttonView.frame))];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitle:@"£10" forState:UIControlStateNormal];
    tenRupeeTopUpBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    tenRupeeTopUpBtn.tag=100;
    [tenRupeeTopUpBtn addTarget:self action:@selector(rechargeTenRupeeTopUp:) forControlEvents:UIControlEventTouchUpInside];
    [tenRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [buttonView addSubview:tenRupeeTopUpBtn];
    
    twentyRupeeTopUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [twentyRupeeTopUpBtn setFrame:CGRectMake(CGRectGetMaxX(tenRupeeTopUpBtn.frame) + 5 ,0,CGRectGetWidth(tenRupeeTopUpBtn.frame),CGRectGetHeight(buttonView.frame))];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitle:@"£20" forState:UIControlStateNormal];
    twentyRupeeTopUpBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    [twentyRupeeTopUpBtn addTarget:self action:@selector(rechargeTwentyRupeeTopUp:) forControlEvents:UIControlEventTouchUpInside];
    twentyRupeeTopUpBtn.tag=101;
    [twentyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [buttonView addSubview:twentyRupeeTopUpBtn];
    
    fiftyRupeeTopUpBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [fiftyRupeeTopUpBtn setFrame:CGRectMake(CGRectGetMaxX(twentyRupeeTopUpBtn.frame) + 5, 0,CGRectGetWidth(tenRupeeTopUpBtn.frame),CGRectGetHeight(buttonView.frame))];
    fiftyRupeeTopUpBtn.tag=102;
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitle:@"£50" forState:UIControlStateNormal];
    fiftyRupeeTopUpBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    fiftyRupeeTopUpBtn.backgroundColor=[UIColor clearColor];
    [fiftyRupeeTopUpBtn addTarget:self action:@selector(rechargeFiftyRupeeTopUp:) forControlEvents:UIControlEventTouchUpInside];
    [fiftyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [buttonView addSubview:fiftyRupeeTopUpBtn];
    
    UILabel *topUpAmountTitleLbl=[[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(buttonView.frame)+ 25, 193, 45)];
    topUpAmountTitleLbl.text=LString(@"YOUR_OWN_AMOUNT");
    topUpAmountTitleLbl.numberOfLines=0;
    topUpAmountTitleLbl.textAlignment=NSTextAlignmentLeft;
    topUpAmountTitleLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    topUpAmountTitleLbl.textColor=UIColorFromRGB(0x999999);
    topUpAmountTitleLbl.backgroundColor=[UIColor clearColor];
    [baseView addSubview:topUpAmountTitleLbl];
    
    topUpAmountTxt=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topUpAmountTitleLbl.frame)+5, CGRectGetMaxY(buttonView.frame)+25, 94, 45)];
    topUpAmountTxt.delegate=self;
    topUpAmountTxt.tag = 103;
    topUpAmountTxt.keyboardType=UIKeyboardTypeNumberPad;
    topUpAmountTxt.textAlignment=NSTextAlignmentRight;
    topUpAmountTxt.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
    topUpAmountTxt.backgroundColor=[UIColor clearColor];
    [topUpAmountTxt setBackground:getImage(@"textFieldBg.png", NO)];
    [topUpAmountTxt addTarget:self action:@selector(textFieldAmount:) forControlEvents:UIControlEventEditingDidBegin];
    topUpAmountTxt.placeholder = @"£0.00";
    [topUpAmountTxt setupForTuplitStyle];
    [baseView addSubview:topUpAmountTxt];
    
    CGFloat adjustHeight;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    topupTable=[[UITableView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(topUpAmountTxt.frame)+ 25,baseViewWidth,baseViewHeight-adjustHeight-CGRectGetMaxY(topUpAmountTxt.frame)-25) style:UITableViewStylePlain];
    topupTable.delegate=self;
    topupTable.dataSource=self;
    topupTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [baseView addSubview:topupTable];
    
    if ([self.userLinkedCards count] == 0)
    {
        addCreditCardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addCreditCardBtn setFrame:CGRectMake(14, CGRectGetMaxY(topUpAmountTitleLbl.frame)+25,baseViewWidth-28,45)];
        [addCreditCardBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [addCreditCardBtn setTitle:LString(@"CREDIT_TOP_UP") forState:UIControlStateNormal];
        addCreditCardBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        [addCreditCardBtn setBackgroundColor:[UIColor clearColor]];
        [addCreditCardBtn addTarget:self action:@selector(topUpUsingCreditCard) forControlEvents:UIControlEventTouchUpInside];
        addCreditCardBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [addCreditCardBtn setBackgroundImage:getImage(@"buttonBg", NO) forState:UIControlStateNormal];
        [baseView addSubview:addCreditCardBtn];
    }
    
    UINavigationBar *navigationBar =[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth,45)];
    UINavigationItem *navigtionItem=[[UINavigationItem alloc] init];
    navigationBar.backgroundColor=[UIColor whiteColor];
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:LString(@"DISMISS") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissButtonClicked:)];
    [dismiss setTintColor:UIColorFromRGB(0X009999)];
    navigtionItem.rightBarButtonItem=dismiss;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:navigtionItem, nil];
    [navigationBar setItems:array];
    topUpAmountTxt.inputAccessoryView=navigationBar;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
//    creditCard=[[CreditCardModel alloc] init];
    
    value=@"";
    appendString=@"";
    valueStr=@"";
    cardTypeStr=@"";
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
    
//    [self callService];
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
    
    TLCreditCardListingManager *creditCardListManager = [[TLCreditCardListingManager alloc]init];
    creditCardListManager.delegate = self;
    [creditCardListManager callService:0];
}

-(void) topUpUsingCreditCard
{
    TLAddCreditCardViewController *addCreditCard=[[TLAddCreditCardViewController alloc] init];
    addCreditCard.topupAmout = topUpAmountTxt.text;
    [self.navigationController pushViewController:addCreditCard animated:YES];
}

-(void)backToUserProfile
{
//    NSLog(@"%@",APP_DELEGATE.navigationController.viewControllers);
//    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    for (UIViewController *aViewController in allViewControllers) {
//        if ([aViewController isKindOfClass:[TLUserProfileViewController class]]) {
//            [self.navigationController popToViewController:aViewController animated:YES];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rechargeTenRupeeTopUp: (id) sender
{
    topUpAmountTxt.text=@"£10";
    [tenRupeeTopUpBtn setBackgroundImage:getImage(@"rotateButtonBg", NO) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    DISMISS_KEYBOARD;
}
-(void) rechargeTwentyRupeeTopUp: (id) sender
{
    topUpAmountTxt.text=@"£20";
    [twentyRupeeTopUpBtn setBackgroundImage:getImage(@"rotateButtonBg", NO) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    DISMISS_KEYBOARD;
    
}
-(void) rechargeFiftyRupeeTopUp : (id) sender
{
    topUpAmountTxt.text=@"£50";
    [fiftyRupeeTopUpBtn setBackgroundImage:getImage(@"rotateButtonBg", NO) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    DISMISS_KEYBOARD;
}

-(void) textFieldAmount:(id) sender
{
    [tenRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [tenRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [twentyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setBackgroundImage:getImage(@"ButtonLightBg", NO) forState:UIControlStateNormal];
    [fiftyRupeeTopUpBtn setTitleColor:UIColorFromRGB(0x00b3a4) forState:UIControlStateNormal];
    
}

-(void) topUpButtonAction: (id) sender
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
    NSString *string = topUpAmountTxt.text;
    NSString *topUpAmount;
    if(string.length>0)
        topUpAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    else
        topUpAmount = @"";
   
    if (topUpAmount.intValue<10)
    {
        [UIAlertView alertViewWithMessage:@"Enter minimum £10 or above to Top up"];
    }
    else
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:topupTable];
        NSIndexPath *indexPath = [topupTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil)
        {
            CreditCardModel *creditCard = [self.userLinkedCards objectAtIndex:indexPath.row];
            NETWORK_TEST_PROCEDURE
            [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
           
            NSDictionary *queryParams = @{
                                          @"CardId": NSNonNilString(creditCard.Id),
                                          @"Amount": NSNonNilString(topUpAmount),
                                          @"Currency": @"USD",
                                          };
            
            TLTopupManager *topUpManager = [[TLTopupManager alloc]init];
            topUpManager.delegate=self;
            [topUpManager callService:queryParams];
        }
    }
}

-(void)dismissButtonClicked:(id)sender
{
    DISMISS_KEYBOARD;
}


#pragma mark - TableView Delegate Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userLinkedCards count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"TopUp";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIButton *topUpCardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        topUpCardBtn.tag=1001;
        [topUpCardBtn setFrame:CGRectMake(0,0,cell.frame.size.width - 28,45)];
        [topUpCardBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        topUpCardBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        topUpCardBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        [topUpCardBtn setBackgroundColor:[UIColor clearColor]];
        [topUpCardBtn addTarget:self action:@selector(topUpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [topUpCardBtn setBackgroundImage:getImage(@"buttonBg", NO) forState:UIControlStateNormal];
        [cell.contentView addSubview:topUpCardBtn];
        
    }
    
    UIButton *topUpCardBtn=(UIButton*)[cell viewWithTag:1001];
   CreditCardModel *creditCard = [self.userLinkedCards objectAtIndex:indexPath.row];
    
    NSString *trimmedCardNum=[creditCard.CardNumber substringFromIndex:[creditCard.CardNumber length]-8];
    NSString *cardType;
    
    if([creditCard.CardType isEqualToString:@"CB_VISA_MASTERCARD"])
        cardType = @"MasterCard";
    else
        cardType = creditCard.CardType;
        
    
    [topUpCardBtn setTitle:[NSString stringWithFormat:@"Top up using %@ %@",cardType,[TuplitConstants filteredPhoneStringFromString:trimmedCardNum withFilter:@"#### ####"]] forState:UIControlStateNormal];
    
    appendString=@"";
    cardTypeStr=@"";
    
    if ([self.userLinkedCards count] < SCROLL_ENABLE)
    {
        topupTable.scrollEnabled=NO;
    }
    
    return cell;
}

#pragma mark - UITextField Delegate



- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if(textField.tag==103)
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


#pragma mark - TLTopUpManager Delegate

- (void)topupManagerSuccessfull:(TLTopupManager *)topupManager withStatus:(NSString*)topupStatus
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [[ProgressHud shared] hide];
    
    if([self.viewController isKindOfClass:[TLCartViewController class]]||[self.viewController isKindOfClass:[TLTransferViewController class]])
    {
        TLUserProfileViewController *myProfileVC = [[TLUserProfileViewController alloc] init];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:myProfileVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
    }
    else
        [self backToUserProfile];
}

- (void)topupManager:(TLTopupManager *)topupManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)topupManagerFailed:(TLTopupManager *)topupManager
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma mark - TLCreditCardListingManager Delegate

- (void)creditCardListManagerSuccessfull:(TLCreditCardListingManager *)creditCardListManager withCreditCardList:(NSArray*)creditCardList
{
    if(creditCardList.count>0)
        addCreditCardBtn.hidden = YES;
    else
         addCreditCardBtn.hidden = NO;
    
    self.userLinkedCards = creditCardList;
    [topupTable reloadData];
    [[ProgressHud shared] hide];
}
- (void)creditCardListManager:(TLCreditCardListingManager *)creditCardListManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    if(![errorCode isEqualToString:@"2000"])
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)creditCardListanagerFailed:(TLCreditCardListingManager *)creditCardListManager
{
    [[ProgressHud shared] hide];
     [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}
@end
