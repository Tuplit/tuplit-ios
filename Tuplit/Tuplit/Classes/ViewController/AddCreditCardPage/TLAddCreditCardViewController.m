//
//  TLAddCreditCardViewController.m
//  Tuplit
//
//  Created by ev_mac2 on 22/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAddCreditCardViewController.h"

#define ACCEPTABLE_CHARECTERS @"0123456789"

@interface TLAddCreditCardViewController ()<UITextFieldDelegate>
{
    UIScrollView *scrollView;
    CGFloat baseViewWidth;
    CGFloat baseViewHeight;
    UIView *baseView;
    UILabel *scanningLbl, *addManuallyLbl, *accountTopUpLbl;
    UIButton *scanningBtn, *saveBtn ;
    UITextField *cardNumberTextField, *cvvTextField, *dateTextField, *dollarAmtTextField;
    UITextField *currentTextField;
    CGFloat scrollContentHeight;
    CustomSwitch *switchYesOrNo;
}
@end

@implementation TLAddCreditCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(void)loadView
{
    [super loadView];
   [self.navigationItem setTitle:LString(@"ADD_CREDIT_CARD")];
    self.view.backgroundColor = [UIColor whiteColor];
   
    if([self.viewController isKindOfClass:[TLSettingsViewController class]])
    {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        [back backButtonWithTarget:self action:@selector(backButtonAction)];
        [self.navigationItem setLeftBarButtonItem:back];

    }
    else
    {
        UIBarButtonItem *skipBtn=[[UIBarButtonItem alloc]initWithTitle:LString(@"SKIP") style:UIBarButtonItemStyleBordered target:self action:@selector(skipButtonClicked)];
        NSDictionary*fontSize=@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:14]} ;
        [skipBtn setTitleTextAttributes:fontSize forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem=skipBtn;
        
        self.navigationItem.hidesBackButton=YES;
    }
    
    baseViewWidth = self.view.frame.size.width;
    baseViewHeight=self.view.frame.size.height;
    
    baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    baseView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:baseView];
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, baseView.width, baseView.height)];
    scrollView.bounces=YES;
    scrollView.userInteractionEnabled=YES;
    scrollView.backgroundColor=[UIColor clearColor];
    [baseView addSubview:scrollView];
    
    scanningLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(baseView.frame)+14, CGRectGetMinY(baseView.frame)+15, 350, 35)];
    scanningLbl.textColor=UIColorFromRGB(0X999999);
    scanningLbl.backgroundColor = [UIColor clearColor];
    scanningLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    scanningLbl.text=LString(@"SCANNING_TEXT");
    scanningLbl.numberOfLines = 0;
    scanningLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:scanningLbl];
    
    scanningBtn=[[UIButton alloc]init];
    scanningBtn.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    scanningBtn.titleLabel.textColor=UIColorFromRGB(0XFFFFFF);
    [scanningBtn setTitle:LString(@"SCAN_IO") forState:UIControlStateNormal];
    [scanningBtn addTarget:self action:@selector(scanButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scanningBtn setUpButtonForTuplit];
    [scrollView addSubview:scanningBtn];
    
    if([self.viewController isKindOfClass:[TLSettingsViewController class]])
    {
        scanningBtn.frame=CGRectMake(CGRectGetMinX(baseView.frame)+14, CGRectGetMinY(baseView.frame)+20, 290, 45);
    }
    else
    {
        scanningLbl.hidden=NO;
        scanningBtn.frame=CGRectMake(scanningLbl.origin.x, CGRectGetMaxY(scanningLbl.frame)+15, 290 , 45);
    }
    
    
    addManuallyLbl=[[UILabel alloc]initWithFrame:CGRectMake(scanningBtn.frame.origin.x, CGRectGetMaxY(scanningBtn.frame)+7, 350, 35)];
    addManuallyLbl.textColor=UIColorFromRGB(0X999999);
    addManuallyLbl.backgroundColor = [UIColor clearColor];
    addManuallyLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    addManuallyLbl.text=LString(@"MANUALLY");
    [scrollView addSubview:addManuallyLbl];
    
    
    cardNumberTextField=[[UITextField alloc]initWithFrame:CGRectMake(addManuallyLbl.frame.origin.x, CGRectGetMaxY(addManuallyLbl.frame)+8, 290, 45)];
    cardNumberTextField.placeholder=LString(@"CARD_NUMBER");
    cardNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    cardNumberTextField.font=[UIFont  fontWithName:@"HelveticaNeue-Regular" size:16];
    cardNumberTextField.textColor=UIColorFromRGB(0XC0C0C0);
    cardNumberTextField.delegate=self;
    cardNumberTextField.tag=1000;
    [cardNumberTextField setupForTuplitStyle];
    [scrollView addSubview:cardNumberTextField];

    
    dateTextField=[[UITextField alloc]initWithFrame:CGRectMake(cardNumberTextField.frame.origin.x, CGRectGetMaxY(cardNumberTextField.frame)+5, 143, 45)];
    dateTextField.placeholder=LString(@"EXPIRATION");
    dateTextField.keyboardType=UIKeyboardTypeNumberPad;
    dateTextField.font=[UIFont  fontWithName:@"HelveticaNeue-Regular" size:16];
    dateTextField.textColor=UIColorFromRGB(0XC0C0C0);
    dateTextField.delegate=self;
    dateTextField.tag=1001;
    [dateTextField setupForTuplitStyle];
    [scrollView addSubview:dateTextField];
    
    
    cvvTextField=[[UITextField alloc]initWithFrame:CGRectMake(cardNumberTextField.frame.origin.x+148, CGRectGetMaxY(cardNumberTextField.frame)+5, 142, 45)];
    cvvTextField.placeholder=LString(@"CCV");
    cvvTextField.keyboardType=UIKeyboardTypeNumberPad;
    cvvTextField.font=[UIFont  fontWithName:@"HelveticaNeue-Regular" size:16];
    cvvTextField.textColor=UIColorFromRGB(0XC0C0C0);
    cvvTextField.delegate=self;
    cvvTextField.tag=1002;
    [cvvTextField setupForTuplitStyle];
    [scrollView addSubview:cvvTextField];
    
    
    accountTopUpLbl=[[UILabel alloc]init];
    accountTopUpLbl.backgroundColor = [UIColor clearColor];
    accountTopUpLbl.textColor=UIColorFromRGB(0X999999);
    accountTopUpLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    accountTopUpLbl.numberOfLines = 0;
    accountTopUpLbl.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:accountTopUpLbl];
    
    
    switchYesOrNo=[[CustomSwitch alloc]init];
    [switchYesOrNo addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    switchYesOrNo.isRounded=NO;
    switchYesOrNo.onText=LString(@"YES");
    switchYesOrNo.offText=LString(@"NO");
    [scrollView addSubview:switchYesOrNo];
    
    
    dollarAmtTextField=[[UITextField alloc]initWithFrame:CGRectMake(cardNumberTextField.origin.x+147, CGRectGetMaxY(cardNumberTextField.frame)+76, 143, 45)];
    dollarAmtTextField.keyboardType=UIKeyboardTypeDecimalPad;
    dollarAmtTextField.placeholder=@"$0.00";
    dollarAmtTextField.delegate=self;
    dollarAmtTextField.font=[UIFont  fontWithName:@"HelveticaNeue-Regular" size:16];
    dollarAmtTextField.textColor=UIColorFromRGB(0XC0C0C0);
    dollarAmtTextField.tag=1003;
    dollarAmtTextField.textAlignment=NSTextAlignmentRight;
    [dollarAmtTextField setupForTuplitStyle];
    [scrollView addSubview:dollarAmtTextField];
    
    
    saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(accountTopUpLbl.frame.origin.x, CGRectGetMaxY(dollarAmtTextField.frame)+24, 290 , 45)];
    [saveBtn addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setUpButtonForTuplit];
    [scrollView addSubview:saveBtn];
    
   
    if([self.viewController isKindOfClass:[TLSettingsViewController class]])
    {
        accountTopUpLbl.frame=CGRectMake(dateTextField.origin.x, CGRectGetMaxY(dateTextField.frame)+10, 350, 35);
        accountTopUpLbl.text=LString(@"TOP_UPACCOUNT");
        dollarAmtTextField.frame=CGRectMake(cvvTextField.origin.x, CGRectGetMaxY(accountTopUpLbl.frame)+7 , 143, 45);
        switchYesOrNo.frame=CGRectMake(CGRectGetMinX(accountTopUpLbl.frame)+19, CGRectGetMaxY(accountTopUpLbl.frame)+9, 102, 36);
        saveBtn.frame= CGRectMake(accountTopUpLbl.frame.origin.x, CGRectGetMaxY(dollarAmtTextField.frame)+14.5, 290 , 45);
        [saveBtn setTitle:LString(@"SAVE_TOP_UP") forState:UIControlStateNormal];
    }
    else
    {
        accountTopUpLbl.frame=CGRectMake(cardNumberTextField.origin.x, CGRectGetMaxY(cardNumberTextField.frame)+79 , 350, 35);
        accountTopUpLbl.text=LString(@"TOP_UP_ACCOUNT");
        dollarAmtTextField.frame=CGRectMake(cardNumberTextField.origin.x+147, CGRectGetMaxY(cardNumberTextField.frame)+76, 143, 45);
        switchYesOrNo.hidden=YES;
        saveBtn.frame= CGRectMake(accountTopUpLbl.frame.origin.x, CGRectGetMaxY(dollarAmtTextField.frame)+24, 290 , 45);
        [saveBtn setTitle:LString(@"SAVE") forState:UIControlStateNormal];
    }
    
    scrollView.contentSize=CGSizeMake(baseView.frame.size.width,CGRectGetMaxY(baseView.frame)+47);

}

#pragma mark - User Defined Methods

-(void)skipButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)scanButtonClicked
{
    NSLog(@"Scan Button Clicked");
}

-(void)saveButtonClicked
{
    NSLog(@"Save Button Clicked");
}

-(void)backButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)switchChanged:(CustomSwitch *)sender {
    NSLog(@"Changed value to: %@", sender.on ? @"ON" : @"OFF");
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //Acceptable Characters-Numbers
    if (textField.tag==1000 || textField.tag==1001 || textField.tag==1002)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if([string isEqualToString:filtered]== YES)
            return YES;
    }
    
    //Dollar Amount Conversion
    if (textField.tag==1003) {
       
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSLocale *english = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [numberFormatter setLocale:english];
        
        NSString *stringMaybeChanged = [NSString stringWithString:string];
        
        NSMutableString *textFieldTextStr = [NSMutableString stringWithString:textField.text];
        
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
        
        NSDecimalNumber *textFieldTextNum = [NSDecimalNumber decimalNumberWithString:textFieldTextStr];
        NSDecimalNumber *divideByNum = [[[NSDecimalNumber alloc] initWithInt:10] decimalNumberByRaisingToPower:numberFormatter.maximumFractionDigits];
        NSDecimalNumber *textFieldTextNewNum = [textFieldTextNum decimalNumberByDividingBy:divideByNum];
        
        NSString *textFieldTextNewStr = [numberFormatter stringFromNumber:textFieldTextNewNum];
        textField.text = textFieldTextNewStr;
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint pt;
	CGRect rc = [textField bounds];
	rc = [textField convertRect:rc toView:scrollView];
	pt = rc.origin;
	pt.x = 0;
	pt.y -= 100;
    [scrollView setContentSize:CGSizeMake(320, scrollContentHeight+250)];
	[scrollView setContentOffset:pt animated:YES];
    [self showInputAccessoryView:textField];
    currentTextField = textField;
}

-(void)showInputAccessoryView:(UITextField*)textfield;
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    
    toolBar.tintColor=[UIColor clearColor];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    toolBar.barTintColor=[UIColor whiteColor];
    toolBar.tintColor=[UIColor whiteColor];
    toolBar.backgroundColor=[UIColor whiteColor];
    [toolBar sizeToFit];
    CGRect frame = toolBar.frame;
    frame.size.height = 44.0f;
    toolBar.frame = frame;
    
    UIBarButtonItem *previous = [[UIBarButtonItem alloc] initWithTitle:LString(@"PREVIOUS") style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonClicked:)];
    [previous setTintColor:UIColorFromRGB(0X009999)];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:LString(@"NEXT") style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonClicked:)];
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
            break;
        }
    }
}

-(void)dismissButtonClicked:(id)sender
{
    DISMISS_KEYBOARD;
   [scrollView setContentSize:CGSizeMake(320, scrollContentHeight)];
    [scrollView setContentOffset:CGPointZero animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self nextButtonClicked:nil];
    return YES;
}

@end
