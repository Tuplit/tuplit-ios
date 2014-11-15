//
//  EditProfileCellTableViewCell.m
//  Tuplit
//
//  Created by ev_mac8 on 20/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "EditProfileCell.h"

@implementation EditProfileCell

@synthesize delegate,indexPaths,sections;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {        
        if ([reuseIdentifier isEqualToString:@"User Details"])
        {
            self.backgroundColor=[UIColor whiteColor];
            
            CGFloat baseViewWidth = 320;
            
            UIView *userDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, 320)];
            userDetailView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:userDetailView];
            
            UIView *userNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, baseViewWidth, 150)];
            userNameView.backgroundColor = [UIColor clearColor];
            [userDetailView addSubview:userNameView];
            
            UITextField *firstNameTxt=[[UITextField alloc] initWithFrame:CGRectMake(15,0, 142, 45)];
            firstNameTxt.tag = 3000;
            firstNameTxt.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
            firstNameTxt.textColor=UIColorFromRGB(0x333333);
            firstNameTxt.textAlignment=NSTextAlignmentLeft;
            firstNameTxt.autocapitalizationType = UITextAutocapitalizationTypeWords;
            firstNameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
            firstNameTxt.background=[UIImage imageNamed:@"textFieldBg.png"];
            [firstNameTxt setupForTuplitStyle];
            [userNameView addSubview:firstNameTxt];
            
            UITextField *lastNameTxt=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstNameTxt.frame) + 5,0, 142, 45)];
            lastNameTxt.tag = 3001;
            lastNameTxt.font=[UIFont fontWithName:@"HelveticaNeue" size:16.0];
            lastNameTxt.textColor=UIColorFromRGB(0x333333);
            lastNameTxt.textAlignment=NSTextAlignmentLeft;
            lastNameTxt.autocapitalizationType = UITextAutocapitalizationTypeWords;
            lastNameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
            lastNameTxt.background=[UIImage imageNamed:@"textFieldBg.png"];
            [lastNameTxt setupForTuplitStyle];
            [userNameView addSubview:lastNameTxt];
            
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
            
            UISegmentedControl *myControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(firstNameTxt.xPosition, CGRectGetMaxY(firstNameTxt.frame)+5, baseViewWidth-30, 45)];
            myControl.tag = 3004;
            [myControl insertSegmentWithTitle: @"Male" atIndex: 0 animated: NO ];
            [myControl insertSegmentWithTitle: @"Female" atIndex: 1 animated: NO ];
            [myControl insertSegmentWithTitle: @"Rather not say" atIndex: 2 animated: NO];
            myControl.apportionsSegmentWidthsByContent = YES;
            [myControl setTintColor:[UIColor colorWithRed:0.695791 green:0.695791 blue:0.695791 alpha:1]];
            [myControl setBackgroundColor:[UIColor colorWithRed:0.950474 green:0.950474 blue:0.950474 alpha:1]];
            [myControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
            [userNameView addSubview:myControl];
            
            UILabel *dobLabel = [[UILabel alloc]initWithFrame:CGRectMake(myControl.xPosition, CGRectGetMaxY(myControl.frame)+5, myControl.width, myControl.height)];
            dobLabel.tag = 3005;
            dobLabel.font = font;
            dobLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textFieldBg"]];
            dobLabel.text = @" Birthday";
            [userNameView addSubview:dobLabel];
            
            EGOImageView *profileImgView=[[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake(CGRectGetMinX(firstNameTxt.frame),CGRectGetMaxY(userNameView.frame)+20, 60, 60)];
            profileImgView.tag = 3002;
            profileImgView.backgroundColor=[UIColor clearColor];
            profileImgView.contentMode = UIViewContentModeScaleAspectFill;
            profileImgView.layer.cornerRadius= profileImgView.frame.size.width/2;
            profileImgView.userInteractionEnabled=YES;
            profileImgView.clipsToBounds=YES;
            [userDetailView addSubview:profileImgView];
            
            UILabel *checkOutFasterLbl  = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(profileImgView.frame)+20,CGRectGetMaxY(userNameView.frame)+30,210,14)];
            checkOutFasterLbl.text =LString(@"CHECK_OUT");
            checkOutFasterLbl.backgroundColor = [UIColor clearColor];
            checkOutFasterLbl.textColor = UIColorFromRGB(0x333333);
            checkOutFasterLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0];
            checkOutFasterLbl.textAlignment = NSTextAlignmentLeft;
            [userDetailView addSubview:checkOutFasterLbl];
            
            UILabel * checkOutInfoLbl = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMinX(checkOutFasterLbl.frame),CGRectGetMaxY(checkOutFasterLbl.frame),CGRectGetWidth(checkOutFasterLbl.frame),28)];
            checkOutInfoLbl.text =LString(@"CHECK_OUT_INFO");
            checkOutInfoLbl.textColor = UIColorFromRGB(0x333333);
            checkOutInfoLbl.backgroundColor = [UIColor clearColor];
            checkOutInfoLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
            checkOutInfoLbl.numberOfLines =2;
            checkOutInfoLbl.textAlignment= NSTextAlignmentLeft;
            [userDetailView addSubview:checkOutInfoLbl];
            
            UIButton *newPincodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            newPincodeBtn.tag = 3003;
            newPincodeBtn.frame=CGRectMake(15,CGRectGetMaxY(checkOutInfoLbl.frame)+30,290,45);
            [newPincodeBtn setTitle:LString(@"PIN_CODE") forState:UIControlStateNormal];
            newPincodeBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
            newPincodeBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            [newPincodeBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [newPincodeBtn setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
            //            [newPincodeBtn addTarget:self action:@selector(pinCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            newPincodeBtn.backgroundColor = [UIColor clearColor];
            [userDetailView addSubview:newPincodeBtn];
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                for (id obj in self.subviews)
                {
                    if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
                    {
                        UIScrollView *scroll = (UIScrollView *) obj;
                        scroll.delaysContentTouches = NO;
                        break;
                    }
                }
            }
            
        }
        else if ([reuseIdentifier isEqualToString:@"Credit Cards"])
        {
            self.contentView.backgroundColor=UIColorFromRGB(0xF5F5F5);
            
            UIView *cellBaseview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
            cellBaseview.backgroundColor = UIColorFromRGB(0xF5F5F5);
            [self.contentView addSubview:cellBaseview];
            
            
            EGOImageView *cardImgView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(10,0, PROFILE_CELL_HEIGHT, PROFILE_CELL_HEIGHT)];
            cardImgView.backgroundColor = [UIColor clearColor];
            [cardImgView setContentMode:UIViewContentModeScaleAspectFit];
            cardImgView.tag=1000;
            [cellBaseview addSubview:cardImgView];
            
            UILabel *cardNumberLbl=[[UILabel alloc]initWithFrame:CGRectMake(PROFILE_CELL_HEIGHT +10 + 5,0, 175,   PROFILE_CELL_HEIGHT-2)];
            cardNumberLbl.textColor=UIColorFromRGB(0x333333);
            cardNumberLbl.numberOfLines=0;
            cardNumberLbl.tag=1001;
            cardNumberLbl.textAlignment=NSTextAlignmentLeft;
            cardNumberLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            cardNumberLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:cardNumberLbl];
            
            UILabel *expiryDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardNumberLbl.frame), 0, 70, PROFILE_CELL_HEIGHT-2)];
            expiryDateLbl.textColor=UIColorFromRGB(0x333333);
            expiryDateLbl.tag=1002;
            expiryDateLbl.textAlignment=NSTextAlignmentRight;
            expiryDateLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            expiryDateLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:expiryDateLbl];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, PROFILE_CELL_HEIGHT-2,cellBaseview.frame.size.width,2)];
            lineView.backgroundColor = [UIColor whiteColor];
            [cellBaseview addSubview:lineView];
            
            UILabel *noCardLbl=[[UILabel alloc]initWithFrame:cellBaseview.bounds];
            noCardLbl.textColor=UIColorFromRGB(0x333333);
            noCardLbl.numberOfLines=0;
            noCardLbl.tag=1003;
            noCardLbl.textAlignment=NSTextAlignmentCenter;
            noCardLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            noCardLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:noCardLbl];
            
        }
        else if ([reuseIdentifier isEqualToString:@"My Comments"])
        {
            //            swipeView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.contentView.frame.size.width,PROFILE_CELL_HEIGHT)];
            //            swipeView.backgroundColor=[UIColor whiteColor];
            
            UIView *cellBaseview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
            cellBaseview.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:cellBaseview];
            
            EGOImageView *merchantIconImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(15, 10,30,30)];
            merchantIconImgView.tag=2000;
            merchantIconImgView.layer.cornerRadius =15;
            merchantIconImgView.clipsToBounds = YES;
            merchantIconImgView.contentMode = UIViewContentModeScaleAspectFill;
            [cellBaseview addSubview:merchantIconImgView];
            
            UILabel *merchantNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(55,7,cellBaseview.frame.size.width-120, 20)];
            merchantNameLbl.textColor=UIColorFromRGB(0x333333);
            merchantNameLbl.tag=2001;
            merchantNameLbl.textAlignment=NSTextAlignmentLeft;
            merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            merchantNameLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:merchantNameLbl];
            
            UILabel *commentLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(merchantNameLbl.frame),CGRectGetMaxY(merchantNameLbl.frame), CGRectGetWidth(merchantNameLbl.frame), (cellBaseview.frame.size.height-2)/2-8)];
            commentLbl.tag=2002;
            commentLbl.textColor=UIColorFromRGB(0x333333);
            commentLbl.textAlignment=NSTextAlignmentLeft;
            commentLbl.numberOfLines = 0;
            commentLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
            commentLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:commentLbl];
            
            UILabel * totalDaysLbl=[[UILabel alloc] initWithFrame:CGRectMake(cellBaseview.frame.size.width-46,15, 30, 20)];
            totalDaysLbl.textColor=UIColorFromRGB(0x808080);
            totalDaysLbl.tag=2003;
            totalDaysLbl.textAlignment=NSTextAlignmentRight;
            totalDaysLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
            totalDaysLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:totalDaysLbl];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - UserDefined methods

-(void) swipeEditViewAction
{
    editView=[[UIView alloc] initWithFrame:CGRectMake(220, 0, swipeView.frame.size.width, CART_CELL_HEIGHT-2)];
    editView.backgroundColor=[UIColor clearColor];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setFrame:CGRectMake(220, 0, 50, 50)];
    deleteBtn.backgroundColor=[UIColor clearColor];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:deleteBtn];
    
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addBtn setFrame:CGRectMake(CGRectGetMaxX(deleteBtn.frame),0, 50,50)];
    addBtn.backgroundColor=[UIColor clearColor];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addItem:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:addBtn];
    
    [self.contentView addSubview:editView];
    [self.contentView addSubview:swipeView];
    
    UISwipeGestureRecognizer *swipeGestureRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRightInCell:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeftInCell:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeGestureLeft];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(void) removeItem : (id) sender
{
    
}

-(void) addItem : (id) sender
{
    
}
-(void)didSwipeRightInCell:(id)sender
{
    [delegate didSwipeRightInCellWithIndexPath:indexPaths];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        [swipeView setFrame:CGRectMake(-100, 0, self.contentView.frame.size.width, PROFILE_CELL_HEIGHT)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            [editView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, PROFILE_CELL_HEIGHT)];
            
        } ];
    }];
}

-(void)didSwipeLeftInCell:(id)sender
{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.15 animations:^{
        [swipeView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, PROFILE_CELL_HEIGHT)];
    }];
}

@end
