//
//  TLActionSheet.m
//  Tuplit
//
//  Created by ev_mac11 on 31/10/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLActionSheet.h"

@implementation TLActionSheet
@synthesize datepicker;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupdatePicker];
    }
    return self;
}
-(void)setupdatePicker
{
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    
    UIBarButtonItem *barDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClicked)];
    barDone.enabled=YES;
    
    if([barDone respondsToSelector:@selector(setTintColor:)])
    {
        [barDone setTintColor:[UIColor colorWithRed:34.0/255.0 green:97.0/255.0 blue:221.0/255.0 alpha:1]];
    }
    
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    flexSpace.enabled=YES;
    
    UIBarButtonItem *barCancel=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnClicked)];
    barCancel.enabled=YES;
    if([barCancel respondsToSelector:@selector(setTintColor:)])
    {
        [barCancel setTintColor:[UIColor whiteColor]];
    }
    
    NSMutableArray *toolbarArray=[[NSMutableArray alloc]initWithObjects:barCancel,flexSpace,barDone, nil];
    
    UIToolbar *loanToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44.0)];
    [loanToolbar setBarStyle:UIBarStyleBlack];
    if([loanToolbar respondsToSelector:@selector(setTintColor:)])
    {
        loanToolbar.barTintColor = APP_DELEGATE.defaultColor;
    }
    loanToolbar.items = toolbarArray;
    
    UILabel *loanTitleLbl=[[UILabel alloc]init];
    loanTitleLbl.frame=CGRectMake(50.0, 0.0, self.frame.size.width-100.0, 44.0);
    loanTitleLbl.backgroundColor=[UIColor clearColor];
    loanTitleLbl.textColor = [UIColor whiteColor];
    loanTitleLbl.text = @"Select Birthday";
    loanTitleLbl.textAlignment = NSTextAlignmentCenter;
    loanTitleLbl.font=[UIFont fontWithName:@"Helvetica" size:18.0];
    
    datepicker = [[UIDatePicker alloc] init];
    [datepicker setMaximumDate :[NSDate date]];
    datepicker.frame = CGRectMake(0, 40, datepicker.frame.size.width, datepicker.frame.size.height);
    datepicker.datePickerMode = UIDatePickerModeDate;
    
    [self addSubview:loanToolbar];
    [self addSubview:loanTitleLbl];
    [self addSubview:datepicker];
    
}

//-(void)openPicker
//{
//    [self setupdatePicker];
//    [self addSubview:datePickerBase];
//    [UIView animateWithDuration:0.1
//                          delay:0
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         CGRect frm = datePickerBase.frame;
//                         frm.origin.y = frm.origin.y - 200.0;
//                         datePickerBase.frame = frm;
//                     }
//                     completion:nil];
//}

-(void)doneBtnClicked
{
    [_delegate doneAction];
}

-(void)cancelBtnClicked
{
    [_delegate cancelAction];
}
@end
