//
//  UserProfileCell.m
//  Tuplit
//
//  Created by ev_mac8 on 20/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UserProfileCell.h"

@implementation UserProfileCell

@synthesize delegate,indexPaths;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([reuseIdentifier isEqualToString:@"UserDetails"])
        {
            self.backgroundColor=[UIColor clearColor];
            
            UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,173)];
            baseView.backgroundColor=UIColorFromRGB(0xEBEBEB);
            [self.contentView addSubview:baseView];
            
            CGFloat baseViewWidth = 320;
            //  Content part
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,173)];
            topView.backgroundColor = [UIColor whiteColor];
            [baseView addSubview:topView];
            
            UIView *topColoredView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,50)];
            topColoredView.backgroundColor = UIColorFromRGB(0xebebeb);
            [topView addSubview:topColoredView];
            
            EGOImageView * profileImageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake((baseViewWidth-100)/2, CGRectGetMinY(topColoredView.frame)+10, 100, 100)];
            profileImageView.tag = 4000;
            profileImageView.backgroundColor = [UIColor whiteColor];
            profileImageView.layer.cornerRadius = 100/2;
            profileImageView.clipsToBounds = YES;
            profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            [topView addSubview:profileImageView];
            
            UILabel * balanceLabel = [[UILabel alloc ]initWithFrame:CGRectMake(14,CGRectGetMaxY(topColoredView.frame)+25,100,15)];
            balanceLabel.text = LString(@"BALANCE");
            balanceLabel.textColor = UIColorFromRGB(0X808080);
            balanceLabel.backgroundColor = [UIColor clearColor];
            balanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
            balanceLabel.userInteractionEnabled = YES;
            balanceLabel.textAlignment = NSTextAlignmentLeft;
            [topView addSubview:balanceLabel];
            
            UILabel * priceLabel = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMinX(balanceLabel.frame),CGRectGetMaxY(balanceLabel.frame)+7,100,16)];
            priceLabel.tag =4001;
            priceLabel.textColor = UIColorFromRGB(0x00b3a4);
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            priceLabel.userInteractionEnabled = YES;
            priceLabel.textAlignment   = NSTextAlignmentLeft;
            [topView addSubview:priceLabel];
            
            UILabel * userIdLabel  = [[UILabel alloc ]initWithFrame:CGRectMake(baseViewWidth-63,CGRectGetMinY(balanceLabel.frame),50,CGRectGetHeight(balanceLabel.frame))];
            userIdLabel.text = LString(@"USER_ID");
            userIdLabel.textColor = UIColorFromRGB(0X808080);
            userIdLabel.backgroundColor = [UIColor clearColor];
            userIdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
            userIdLabel.userInteractionEnabled = YES;
            userIdLabel.textAlignment = NSTextAlignmentRight;
            [topView addSubview:userIdLabel];
            
            UILabel * userIdNumberLabel = [[UILabel alloc ]initWithFrame:CGRectMake(baseViewWidth-113,CGRectGetMinY(priceLabel.frame),100,CGRectGetHeight(balanceLabel.frame))];
            userIdNumberLabel.tag = 4002;
            userIdNumberLabel.textColor = UIColorFromRGB(0x00b3a4);
            userIdNumberLabel.backgroundColor = [UIColor clearColor];
            userIdNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            userIdNumberLabel.userInteractionEnabled = YES;
            userIdNumberLabel.textAlignment = NSTextAlignmentRight;
            [topView addSubview:userIdNumberLabel];
            
            // menu view
            UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(priceLabel.frame)+25, baseViewWidth, 35)];
            menuView.backgroundColor = [UIColor clearColor];
            [topView addSubview:menuView];
            
            UIButton *topUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
            topUpButton.tag = 4003;
            [topUpButton setTitle:LString(@"TOP_UP") forState:UIControlStateNormal];
            UIImage * topUpImage = getImage(@"buttonBg", NO);
            UIImage * stretchableTopUpImage = [topUpImage stretchableImageWithLeftCapWidth:9 topCapHeight:0];
            [topUpButton setBackgroundImage:stretchableTopUpImage forState:UIControlStateNormal];
            topUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            topUpButton.frame=CGRectMake(16,0,142, 35);
            [topUpButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [menuView addSubview:topUpButton];
            
            UIButton *transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
            transferButton.tag = 4004;
            UIImage * transferImage = getImage(@"buttonBg", NO);
            [transferButton setBackgroundImage:transferImage forState:UIControlStateNormal];    [transferButton setTitle:LString(@"TRANSFER") forState:UIControlStateNormal];
            transferButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            transferButton.frame = CGRectMake(CGRectGetMaxX(topUpButton.frame)+5,0,142, 35);
            [transferButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [menuView addSubview:transferButton];
            
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
        else if ([reuseIdentifier isEqualToString:@"OtherUserDetails"])
        {
            self.backgroundColor=[UIColor clearColor];
            
            UIView *baseView=[[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,173)];
            baseView.backgroundColor=UIColorFromRGB(0xEBEBEB);
            [self.contentView addSubview:baseView];
            
            CGFloat baseViewWidth = 320;
            //  Content part
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,173)];
            topView.backgroundColor = [UIColor whiteColor];
            [baseView addSubview:topView];
            
            UIView *topColoredView = [[UIView alloc] initWithFrame:CGRectMake(0,0,baseViewWidth,50)];
            topColoredView.backgroundColor = UIColorFromRGB(0xebebeb);
            [topView addSubview:topColoredView];
            
            EGOImageView * profileImageView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake((baseViewWidth-100)/2, CGRectGetMinY(topColoredView.frame)+10, 100, 100)];
            profileImageView.tag = 5000;
            profileImageView.backgroundColor = [UIColor whiteColor];
            profileImageView.layer.cornerRadius = 100/2;
            profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            //            profileImageView.userInteractionEnabled = YES;
            profileImageView.clipsToBounds = YES;
            [topView addSubview:profileImageView];
            
            UILabel * userIdLabel  = [[UILabel alloc ]initWithFrame:CGRectMake(baseViewWidth-63,CGRectGetMaxY(topColoredView.frame)+25,50,15)];
            userIdLabel.text = LString(@"USER_ID");
            userIdLabel.textColor = UIColorFromRGB(0X808080);
            userIdLabel.backgroundColor = [UIColor clearColor];
            userIdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
            userIdLabel.userInteractionEnabled = YES;
            userIdLabel.textAlignment = NSTextAlignmentRight;
            [topView addSubview:userIdLabel];
            
            UILabel * userIdNumberLabel = [[UILabel alloc ]initWithFrame:CGRectMake(baseViewWidth-113,CGRectGetMaxY(userIdLabel.frame)+7,100,16)];
            userIdNumberLabel.tag = 5001;
            userIdNumberLabel.textColor = UIColorFromRGB(0x00b3a4);
            userIdNumberLabel.backgroundColor = [UIColor clearColor];
            userIdNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            userIdNumberLabel.userInteractionEnabled = YES;
            userIdNumberLabel.textAlignment = NSTextAlignmentRight;
            [topView addSubview:userIdNumberLabel];
            
            UIButton *sendCreditBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [sendCreditBtn setFrame:CGRectMake(15, CGRectGetMaxY(userIdNumberLabel.frame)+ 15, baseView.frame.size.width-30,35)];
            sendCreditBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
            sendCreditBtn.tag=5002;
            [sendCreditBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            sendCreditBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            [sendCreditBtn setBackgroundImage:[UIImage imageNamed:@"buttonBg.png"] forState:UIControlStateNormal];
            [topView addSubview:sendCreditBtn];
            
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
            cellBaseview.backgroundColor =  UIColorFromRGB(0xF5F5F5);
            [self.contentView addSubview:cellBaseview];
            
            EGOImageView *cardImgView = [[EGOImageView alloc] initWithPlaceholderImage:nil imageViewFrame:CGRectMake(10, 0, PROFILE_CELL_HEIGHT, PROFILE_CELL_HEIGHT)];
            cardImgView.backgroundColor = [UIColor clearColor];
            [cardImgView setContentMode:UIViewContentModeScaleAspectFit];
            cardImgView.tag=1000;
            [cellBaseview addSubview:cardImgView];
            
            UILabel *cardNumberLbl=[[UILabel alloc]initWithFrame:CGRectMake(PROFILE_CELL_HEIGHT + 10 + 5 ,0, 175,   PROFILE_CELL_HEIGHT)];
            cardNumberLbl.textColor=UIColorFromRGB(0x333333);
            cardNumberLbl.numberOfLines=0;
            cardNumberLbl.tag=1001;
            cardNumberLbl.textAlignment=NSTextAlignmentLeft;
            cardNumberLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            cardNumberLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:cardNumberLbl];
            
            UILabel *expiryDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardNumberLbl.frame), 0, 70, PROFILE_CELL_HEIGHT)];
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
        else if ([reuseIdentifier isEqualToString:@"RecentActivity"])
        {
            self.contentView.backgroundColor=UIColorFromRGB(0xF5F5F5);
            
            EGOImageView *merchantIconImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(0, 0, 50, PROFILE_CELL_HEIGHT-2)];
            merchantIconImgView.tag=2000;
            merchantIconImgView.contentMode = UIViewContentModeScaleAspectFill;
            merchantIconImgView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:merchantIconImgView];
            
            UILabel *merchantNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(50 + 10,10, 186, (PROFILE_CELL_HEIGHT-2)/2 - 8)];
            merchantNameLbl.textColor=UIColorFromRGB(0x333333);
            merchantNameLbl.tag=2001;
            merchantNameLbl.textAlignment=NSTextAlignmentLeft;
            merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            merchantNameLbl.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:merchantNameLbl];
            
            UILabel *numberofItemLbl=[[UILabel alloc] initWithFrame:CGRectMake(50 +10,CGRectGetMaxY(merchantNameLbl.frame), 150, (PROFILE_CELL_HEIGHT-2)/2-8)];
            numberofItemLbl.tag=2002;
            numberofItemLbl.textColor=UIColorFromRGB(0x333333);
            numberofItemLbl.textAlignment=NSTextAlignmentLeft;
            numberofItemLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            numberofItemLbl.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:numberofItemLbl];
            
            UILabel *transactionDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-46, 10, 59, (PROFILE_CELL_HEIGHT-2)/2 - 8)];
            transactionDateLbl.textColor=UIColorFromRGB(0x808080);
            transactionDateLbl.tag=2003;
            transactionDateLbl.textAlignment=NSTextAlignmentRight;
            transactionDateLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
            transactionDateLbl.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:transactionDateLbl];
            
            UILabel *totalAmountLbl=[[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-46, CGRectGetMaxY(transactionDateLbl.frame), 98, (PROFILE_CELL_HEIGHT-2)/2 -8 )];
            totalAmountLbl.textColor=UIColorFromRGB(0x00b3a4);
            totalAmountLbl.textAlignment=NSTextAlignmentRight;
            totalAmountLbl.tag=2004;
            totalAmountLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
            totalAmountLbl.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:totalAmountLbl];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, PROFILE_CELL_HEIGHT-2,self.frame.size.width,2)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:lineView];
        }
        else if ([reuseIdentifier isEqualToString:@"RecentShopped"])
        {
            self.contentView.backgroundColor=UIColorFromRGB(0xF5F5F5);
            
            EGOImageView *merchantIconImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(0, 0, 50, PROFILE_CELL_HEIGHT-2)];
            merchantIconImgView.tag=2000;
            merchantIconImgView.contentMode = UIViewContentModeScaleAspectFill;
            merchantIconImgView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:merchantIconImgView];
            
            UILabel *merchantNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(50 + 10,0, 186, PROFILE_CELL_HEIGHT-2)];
            merchantNameLbl.textColor=UIColorFromRGB(0x333333);
            merchantNameLbl.tag=2001;
            merchantNameLbl.textAlignment=NSTextAlignmentLeft;
            merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            merchantNameLbl.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:merchantNameLbl];
            
            UILabel *transactionDateLbl=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-46, 0, 59,PROFILE_CELL_HEIGHT-2)];
            transactionDateLbl.textColor=UIColorFromRGB(0x808080);
            transactionDateLbl.tag=2003;
            transactionDateLbl.textAlignment=NSTextAlignmentRight;
            transactionDateLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
            transactionDateLbl.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:transactionDateLbl];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, PROFILE_CELL_HEIGHT-2,self.frame.size.width,2)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:lineView];
        }
        else if ([reuseIdentifier isEqualToString:@"MyComments"])
        {
            self.backgroundColor=[UIColor whiteColor];
            
            UIView *cellBaseview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
            cellBaseview.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:cellBaseview];
            
            EGOImageView *merchantIconImgView = [[EGOImageView alloc] initWithPlaceholderImage:getImage(@"DefaultUser", NO) imageViewFrame:CGRectMake(15, 10,30,30)];
            merchantIconImgView.tag=3000;
            merchantIconImgView.layer.cornerRadius =15;
            [merchantIconImgView setContentMode:UIViewContentModeScaleAspectFill];
            merchantIconImgView.clipsToBounds = YES;
            merchantIconImgView.userInteractionEnabled = YES;
            [cellBaseview addSubview:merchantIconImgView];
            
            UILabel *merchantNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(55, 8,200, 17)];
            merchantNameLbl.textColor=UIColorFromRGB(0x333333);
            merchantNameLbl.tag=3001;
            merchantNameLbl.textAlignment=NSTextAlignmentLeft;
            merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
            merchantNameLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:merchantNameLbl];
            
            UILabel *commentLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(merchantNameLbl.frame),CGRectGetMaxY(merchantNameLbl.frame), CGRectGetWidth(merchantNameLbl.frame), (cellBaseview.frame.size.height-2)/2-8)];
            commentLbl.tag=3002;
            commentLbl.textColor=UIColorFromRGB(0x333333);
            commentLbl.textAlignment=NSTextAlignmentLeft;
            commentLbl.numberOfLines = 0;
            commentLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:12.0];
            commentLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:commentLbl];
            
            UILabel * totalDaysLbl=[[UILabel alloc] initWithFrame:CGRectMake(cellBaseview.frame.size.width-46,15, 30, 20)];
            totalDaysLbl.textColor=UIColorFromRGB(0x808080);
            totalDaysLbl.tag=3003;
            totalDaysLbl.textAlignment=NSTextAlignmentRight;
            totalDaysLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
            totalDaysLbl.backgroundColor=[UIColor clearColor];
            [cellBaseview addSubview:totalDaysLbl];
            
        }
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
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
