//
//  TLAddCreditCardViewController.m
//  Tuplit
//
//  Created by ev_mac2 on 22/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddCreditCardViewController.h"
#import "CreditCard.h"
#import "TLSignUpViewController.h"
#import "TLSocialNWSignUpViewController.h"

#define ACCEPTABLE_CHARECTERS @"0123456789"

@interface TLAddCreditCardViewController ()<UITextFieldDelegate,CardIOPaymentViewControllerDelegate>
{
    UIScrollView *scrollView;
    CGFloat baseViewWidth;
    CGFloat baseViewHeight;
    UIView *baseView;
    UILabel *scanningLbl, *addManuallyLbl, *accountTopUpLbl;
    UIButton *scanningBtn, *saveBtn ;
    UITextField *cardNumberTextField, *cvvTextField, *dateExpirationTextField, *dollarAmtTextField;
    UITextField *currentTextField;
    CGFloat scrollContentHeight;
    UIBarButtonItem *previous,*next;
    CustomSwitch *switchYesOrNo;
    int  adjustHeight ;
    CreditCard *creditcard;
    
}
@end

@implementation TLAddCreditCardViewController

-(void)loadView
{
    [super loadView];
    [self.navigationItem setTitle:LString(@"ADD_CREDIT_CARD")];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if([self.viewController isKindOfClass:[TLUserProfileViewController class]] || [self.viewController isKindOfClass:[TLEditProfileViewController class]])
    {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        [back backButtonWithTarget:self action:@selector(backButtonAction)];
        [self.navigationItem setLeftBarButtonItem:back];
        
    }
    else
    {
        
        UIBarButtonItem *skipBtn=[[UIBarButtonItem alloc]init];
        [skipBtn buttonWithTitle:LString(@"SKIP") withTarget:self action:@selector(skipButtonClicked)];
        self.navigationItem.rightBarButtonItem=skipBtn;
        self.navigationItem.hidesBackButton=YES;
    }
    
    baseViewWidth = self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    adjustHeight = 64;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        adjustHeight = 64;
    }
    else
    {
        adjustHeight = 44;
    }
    
    baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight-adjustHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseView.width, baseView.height)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        scrollView.delaysContentTouches = NO;
    scrollView.backgroundColor=[UIColor clearColor];
    
    [baseView addSubview:scrollView];
    
    scanningBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    scanningBtn.frame=CGRectMake(20, 20, scrollView.width - 40, 45);
    [scanningBtn setTitle:LString(@"SCAN_IO") forState:UIControlStateNormal];
    scanningBtn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    [scanningBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [scanningBtn addTarget:self action:@selector(scanButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    scanningBtn.backgroundColor=[UIColor clearColor];
    [scanningBtn setUpButtonForTuplit];
    [scrollView addSubview:scanningBtn];
    
    addManuallyLbl=[[UILabel alloc]initWithFrame:CGRectMake(scanningBtn.frame.origin.x,CGRectGetMaxY(scanningBtn.frame), scrollView.width - 40, 50)];
    addManuallyLbl.text=LString(@"MANUALLY");
    addManuallyLbl.textAlignment=NSTextAlignmentCenter;
    addManuallyLbl.textColor=UIColorFromRGB(0X999999);
    addManuallyLbl.backgroundColor = [UIColor clearColor];
    addManuallyLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [scrollView addSubview:addManuallyLbl];
    
    cardNumberTextField=[[UITextField alloc]initWithFrame:CGRectMake(addManuallyLbl.frame.origin.x, CGRectGetMaxY(addManuallyLbl.frame), scrollView.width-40, 45)];
    cardNumberTextField.placeholder=LString(@"CARD_NUMBER");
    cardNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    cardNumberTextField.backgroundColor=[UIColor clearColor];
    cardNumberTextField.font=[UIFont  fontWithName:@"HelveticaNeue" size:16];
    cardNumberTextField.textColor=UIColorFromRGB(0xc0c0c0c);
    cardNumberTextField.delegate=self;
    cardNumberTextField.tag=1000;
    [cardNumberTextField setupForTuplitStyle];
    [scrollView addSubview:cardNumberTextField];
    
    dateExpirationTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(cardNumberTextField.frame), CGRectGetMaxY(cardNumberTextField.frame)+5, 144, 45)];
    dateExpirationTextField.placeholder=LString(@"EXPIRATION");
    dateExpirationTextField.keyboardType=UIKeyboardTypeNumberPad;
    dateExpirationTextField.font=[UIFont  fontWithName:@"HelveticaNeue" size:16];
    dateExpirationTextField.textColor=UIColorFromRGB(0xc0c0c0c);
    dateExpirationTextField.delegate=self;
    dateExpirationTextField.tag=1001;
    dateExpirationTextField.backgroundColor=[UIColor clearColor];
    [dateExpirationTextField setupForTuplitStyle];
    [scrollView addSubview:dateExpirationTextField];
    
    cvvTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dateExpirationTextField.frame)+ 5, CGRectGetMaxY(cardNumberTextField.frame)+5, scrollView.width - dateExpirationTextField.width - 5 - 40, 45)];
    cvvTextField.placeholder=LString(@"CCV");
    cvvTextField.keyboardType=UIKeyboardTypeNumberPad;
    cvvTextField.font=[UIFont  fontWithName:@"HelveticaNeue" size:16];
    cvvTextField.textColor=UIColorFromRGB(0xc0c0c0c);
    cvvTextField.delegate=self;
    cvvTextField.tag=1002;
    cvvTextField.backgroundColor=[UIColor clearColor];
    [cvvTextField setupForTuplitStyle];
    [scrollView addSubview:cvvTextField];
    
    accountTopUpLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(dateExpirationTextField.frame), CGRectGetMaxY(dateExpirationTextField.frame), scrollView.width-40, 50)];
    accountTopUpLbl.text=LString(@"TOP_UPACCOUNT");
    accountTopUpLbl.textAlignment=NSTextAlignmentCenter;
    accountTopUpLbl.backgroundColor = [UIColor clearColor];
    accountTopUpLbl.textColor=UIColorFromRGB(0X999999);
    accountTopUpLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    accountTopUpLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:accountTopUpLbl];
    
    switchYesOrNo=[[CustomSwitch alloc]initWithFrame:CGRectMake(CGRectGetMinX(accountTopUpLbl.frame)+19, CGRectGetMaxY(accountTopUpLbl.frame)+5,104, 34)];
    [switchYesOrNo addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    switchYesOrNo.isRounded=NO;
    switchYesOrNo.offText=LString(@"NO");
    switchYesOrNo.onText=LString(@"YES");
    [scrollView addSubview:switchYesOrNo];
    
    dollarAmtTextField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(switchYesOrNo.frame) + 25, CGRectGetMaxY(accountTopUpLbl.frame), scrollView.width-switchYesOrNo.width- 25-40-19, 45)];
    dollarAmtTextField.keyboardType=UIKeyboardTypeDecimalPad;
    dollarAmtTextField.placeholder=@"£0.00 ";
    dollarAmtTextField.delegate=self;
    dollarAmtTextField.backgroundColor=[UIColor clearColor];
    dollarAmtTextField.font=[UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0];
    dollarAmtTextField.tag=1003;
    dollarAmtTextField.textAlignment=NSTextAlignmentRight;
    dollarAmtTextField.enabled = NO;
    [dollarAmtTextField setupForTuplitStyle];
    [scrollView addSubview:dollarAmtTextField];
    
    saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(accountTopUpLbl.frame), CGRectGetMaxY(dollarAmtTextField.frame)+15, scrollView.width-40 , 45)];
    [saveBtn setTitle:LString(@"SAVE_TOP_UP") forState:UIControlStateNormal];
    saveBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    saveBtn.backgroundColor=[UIColor clearColor];
    saveBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    saveBtn.titleLabel.textColor=UIColorFromRGB(0xffffff);
    [saveBtn addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setUpButtonForTuplit];
    [scrollView addSubview:saveBtn];
    
    creditcard = [[CreditCard alloc]init];
    
    [scrollView setContentSize:CGSizeMake(baseView.frame.size.width, CGRectGetMaxY(saveBtn.frame) + 20)];
    
    if(self.topupAmout.length>0)
    {
        dollarAmtTextField.text = self.topupAmout;
//        switchYesOrNo.on = YES;
        [switchYesOrNo setOn:YES animated:YES];
//        switchYesOrNo
    }
    
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Defined Methods

-(void)callService
{
    NETWORK_TEST_PROCEDURE
    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    
    NSString* topupAmount;
    if(switchYesOrNo.on)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
        NSString *string = dollarAmtTextField.text;
        topupAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    }
    else
    {
        topupAmount = @"";
    }
    
    NSString *cardno = [TuplitConstants filteredPhoneStringFromString:cardNumberTextField.text withFilter:CARDNORMAL];
    NSString *date = [TuplitConstants filteredPhoneStringFromString:dateExpirationTextField.text withFilter:DATENORMAL];
    NSDictionary *queryParams = @{
                                  @"CardNumber"            : NSNonNilString(cardno),
                                  @"CardExpirationDate"    : NSNonNilString(date),
                                  @"CVV"                   : NSNonNilString(cvvTextField.text),
//                                  @"Currency"              : @"USD",
                                  @"Amount"                : NSNonNilString(topupAmount),
                                  };
    TLAddCreditCardManager *creditcardManager = [[TLAddCreditCardManager alloc]init];
    creditcardManager.delegate = self;
    [creditcardManager callService:queryParams];
    
}

-(void)skipButtonClicked
{
    if([self.viewController isKindOfClass:[TLSignUpViewController class]]||[self.viewController isKindOfClass:[TLSocialNWSignUpViewController class]])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kCreditCardAdded object:nil];
    }
    else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            //Do not forget to import AnOldViewController.h
            if ([controller isKindOfClass:[TLCartViewController class]]||[controller isKindOfClass:[TLTransferViewController class]]) {
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                return;
            }
        }

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)scanButtonClicked
{
    [self dismissButtonClicked:nil];
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
//    scanViewController.appToken = CardIOAppToken;
    [scanViewController.navigationBar setBackgroundImage:[UIImage imageWithColor:APP_DELEGATE.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [scanViewController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController presentViewController:scanViewController animated:YES completion:nil];
}

-(void)saveButtonClicked
{
    creditcard.number = [TuplitConstants filteredPhoneStringFromString:cardNumberTextField.text withFilter:CARDNORMAL];
    creditcard.expirationMonthYear = dateExpirationTextField.text;
    creditcard.ccv = cvvTextField.text;
    
    if (cardNumberTextField.text.length == 0) {
        
        [UIAlertView alertViewWithMessage:LString(@"ENTER_CARD_NUMBER")];
    }
    else if(dateExpirationTextField.text.length == 0) {
        
        [UIAlertView alertViewWithMessage:LString(@"ENTER_EXPIRATION")];
    }
    else if (cvvTextField.text.length == 0) {
        
        [UIAlertView alertViewWithMessage:LString(@"ENTER_CVV")];
    }
    else
    {
        NSArray *errors = [creditcard validate];
        if (errors.count > 0) {
            NSString *msg = [errors objectAtIndex:0];
            [UIAlertView alertViewWithMessage:msg];
        } else {
            
            if(switchYesOrNo.on)
            {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
                NSString *string = dollarAmtTextField.text;
                NSString *topUpAmount;
                if(string.length>0)
                    topUpAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
                else
                    topUpAmount = @"";
                
                if (topUpAmount.intValue<10)
                {
                    [UIAlertView alertViewWithMessage:LString(@"ENTER_MINIMUM_AMT")];
                }
                else
                {
                    [self callService];
                }
            }
            else
            {
                [self callService];
            }
        }
    }
}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchChanged:(CustomSwitch *)sender {
    
    if (sender.on) {
        dollarAmtTextField.enabled = YES;
    }
    else
    {
        dollarAmtTextField.text = @"";
        dollarAmtTextField.enabled = NO;
        [self dismissButtonClicked:nil];
    }
}

-(void)showInputAccessoryView:(UITextField*)textfield;
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    
    toolBar.tintColor=[UIColor clearColor];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        toolBar.barTintColor=[UIColor whiteColor];
    toolBar.tintColor=[UIColor whiteColor];
    toolBar.backgroundColor=[UIColor whiteColor];
    [toolBar sizeToFit];
    CGRect frame = toolBar.frame;
    frame.size.height = 44.0f;
    toolBar.frame = frame;
    
    previous = [[UIBarButtonItem alloc] initWithTitle:LString(@"PREVIOUS") style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonClicked:)];
    [previous setTintColor:UIColorFromRGB(0X009999)];
    
    next = [[UIBarButtonItem alloc] initWithTitle:LString(@"NEXT") style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonClicked:)];
    [next setTintColor:UIColorFromRGB(0X009999)];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:LString(@"DISMISS") style:UIBarButtonItemStyleBordered target:self action:@selector(dismissButtonClicked:)];
    [dismiss setTintColor:UIColorFromRGB(0X009999)];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:previous,next,flexibleSpaceLeft, dismiss, nil];
    [toolBar setItems:array];
    [textfield setInputAccessoryView:toolBar];
}

-(void)previousButtonClicked:(id)sender
{
    for(UITextField *textField in scrollView.subviews)
    {
        if(textField.tag == currentTextField.tag-1 && textField.tag != 0)
        {
            [textField becomeFirstResponder];
            if (currentTextField.tag == 1000)
            {
                previous.enabled=NO;
            }
            break;
        }
    }
}

-(void)nextButtonClicked:(id)sender
{
    for(UITextField *textField in scrollView.subviews)
    {
        if(textField.tag > currentTextField.tag)
        {
            [textField becomeFirstResponder];
            if (currentTextField.tag == 1003)
            {
                next.enabled=NO;
            }
            
            break;
        }
    }
}

-(void)dismissButtonClicked:(id)sender
{
    DISMISS_KEYBOARD;
    [scrollView setFrame:CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height)];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setFrame:CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height - 216 - 44)];
    [self showInputAccessoryView:textField];
    
    currentTextField = textField;
    
    if (currentTextField.tag == 1000)
        previous.enabled=NO;
    else if (currentTextField.tag == 1003)
        next.enabled=NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Acceptable Characters-Numbers
    if (textField.tag==1000 || textField.tag==1001 || textField.tag==1002)
    {
        NSString *cc_num_string = textField.text;
        NSString *filter;
        
        if (textField.tag==1000)
        {
            if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '3' && ([cc_num_string characterAtIndex:1] == '4' || [cc_num_string characterAtIndex:1] == '7'))
            {
                filter = CARDAMEX;
            }
            else
            {
                filter = CARDDEFAULT;
            }
        }
        else if(textField.tag==1001)
        {
            filter = DATEFORMAT;
        }
        else if(textField.tag==1002)
        {
            filter = CVVFORMAT;
        }
        
        if(!filter) return YES; // No filter provided, allow anything
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        
        textField.text = [TuplitConstants filteredPhoneStringFromString:changedString withFilter:filter];
        NSArray* dayComponent = [dateExpirationTextField.text componentsSeparatedByString: @"/"];
        int expirationMonth;
        expirationMonth = [NSString stringWithFormat:@"%@",[dayComponent objectAtIndex:0]].intValue;
        
        if (textField.tag == 1001)
        {
            if (expirationMonth <=12)
            {
                textField.text=[creditcard validateDate:textField.text Length:[textField.text length]];
                
            }
            else
            {
                textField.text=[NSString stringWithFormat:@"%@",[dayComponent objectAtIndex:0]];
                textField.text= [creditcard validateDate:textField.text Length:[textField.text length]];
            }
        }
        
        return NO;
    }
    //Dollar Amount Conversion
    else if (textField.tag==1003) {
        
        NSInteger MAX_DIGITS = 9; // €999,999,999.99
        
        NSNumberFormatter *numberFormatter = [TuplitConstants getCurrencyFormat];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setMinimumFractionDigits:0];
        [numberFormatter setMaximumFractionDigits:0];
        
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self nextButtonClicked:nil];
    return YES;
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController :(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *year = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear];
    cardNumberTextField.text=[TuplitConstants filteredPhoneStringFromString:info.cardNumber withFilter:CARDDEFAULT];
    cvvTextField.text=[NSString stringWithFormat:@"%@",info.cvv];
    dateExpirationTextField.text=[NSString stringWithFormat:@"%02lu/%@",(unsigned long)info.expiryMonth,[year substringFromIndex:[year length] - 2]];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TLAddCreditCardManagerDelegate
- (void)addCreditCardManagerSuccessfull:(TLAddCreditCardManager *)addCreditCardManager withStatus:(NSString*)creditCardStatus
{
    APP_DELEGATE.isUserProfileEdited = YES;
    [[ProgressHud shared] hide];
    [self.view endEditing:YES];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
    NSString *string = dollarAmtTextField.text;
    NSString *topUpAmount;
    if(string.length>0)
    {
        topUpAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    }
    
    UserModel *userModel = [TLUserDefaults getCurrentUser];
    double balance = userModel.AvailableBalance.doubleValue;
    userModel.AvailableBalance = [NSString stringWithFormat:@"%lf",(balance + topUpAmount.doubleValue)];
    [TLUserDefaults setCurrentUser:userModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserData object:nil];
    
    //    [UIAlertView alertViewWithMessage:creditCardStatus];
    if(dollarAmtTextField.text.length>0||[self.viewController isKindOfClass:[TLSignUpViewController class]]||[self.viewController isKindOfClass:[TLSocialNWSignUpViewController class]])
        [self skipButtonClicked];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)addCreditCardManager:(TLAddCreditCardManager *)addCreditCardManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg
{
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}
- (void)addCreditCardManagerFailed:(TLAddCreditCardManager *)addCreditCardManager
{
    [[ProgressHud shared] hide];
    [self skipButtonClicked];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
    
}
@end
