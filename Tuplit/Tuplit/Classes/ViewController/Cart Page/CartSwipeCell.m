//
//  CartSwipeCell.m
//  Tuplit
//
//  Created by ev_mac8 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CartSwipeCell.h"
#import "NSString+StringFunctions.h"

@implementation CartSwipeCell

@synthesize indexPath,delegate;
@synthesize itemImgView;
@synthesize itemNameLbl,fixedAmountLbl,discountAmountLbl,itemQuantityLbl;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        swipeView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.contentView.frame.size.width,CART_CELL_HEIGHT)];
        swipeView.backgroundColor= UIColorFromRGB(0xF4F4F4);
        
        itemImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:CGRectMake(0, 0, 50, CART_CELL_HEIGHT-2)];
        itemImgView.backgroundColor = [UIColor clearColor];
        [swipeView addSubview:itemImgView];
        
        itemQuantityLbl=[[UILabel alloc]initWithFrame:CGRectMake(50 + 5,0, 35, CART_CELL_HEIGHT-2)];
        itemQuantityLbl.textColor= UIColorFromRGB(0x666666);
        itemQuantityLbl.numberOfLines=0;
        itemQuantityLbl.textAlignment=NSTextAlignmentCenter;
        itemQuantityLbl.adjustsFontSizeToFitWidth=YES;
        itemQuantityLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:14.0];
        itemQuantityLbl.backgroundColor=[UIColor clearColor];
        [swipeView addSubview:itemQuantityLbl];
        
        itemNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(itemQuantityLbl.frame),0, 160, CART_CELL_HEIGHT-2)];
        itemNameLbl.textColor= UIColorFromRGB(0x333333);
        itemNameLbl.numberOfLines=0;
        itemNameLbl.textAlignment=NSTextAlignmentLeft;
        itemNameLbl.adjustsFontSizeToFitWidth=YES;
        itemNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
        itemNameLbl.backgroundColor=[UIColor clearColor];
        [swipeView addSubview:itemNameLbl];
        
        fixedAmountLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(itemNameLbl.frame), 0, 30, CART_CELL_HEIGHT-2)];
        fixedAmountLbl.textColor= UIColorFromRGB(0x808080);
        fixedAmountLbl.textAlignment=NSTextAlignmentRight;
        fixedAmountLbl.font=[UIFont fontWithName:@"HelveticaNeue" size:10.0];
        fixedAmountLbl.backgroundColor=[UIColor clearColor];
        [swipeView addSubview:fixedAmountLbl];
        
        discountAmountLbl=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fixedAmountLbl.frame), 0, 40, CART_CELL_HEIGHT-2)];
        discountAmountLbl.textColor= UIColorFromRGB(0x00b3a4);
        discountAmountLbl.textAlignment=NSTextAlignmentRight;
        discountAmountLbl.backgroundColor=[UIColor clearColor];
        discountAmountLbl.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
        [swipeView addSubview:discountAmountLbl];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CART_CELL_HEIGHT-2,swipeView.frame.size.width,2)];
        lineView.backgroundColor = [UIColor whiteColor];
        [swipeView addSubview:lineView];
        
        editView=[[UIView alloc] initWithFrame:CGRectMake(220, 0, swipeView.frame.size.width, CART_CELL_HEIGHT-2)];
        editView.backgroundColor=[UIColor clearColor];
        
        UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteBtn setFrame:CGRectMake(220, 0, 50, 50)];
        deleteBtn.backgroundColor=[UIColor clearColor];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(removeCartItem:) forControlEvents:UIControlEventTouchUpInside];
        [editView addSubview:deleteBtn];
        
        UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addBtn setFrame:CGRectMake(CGRectGetMaxX(deleteBtn.frame),0, 50,50)];
        addBtn.backgroundColor=[UIColor clearColor];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addCartItem:) forControlEvents:UIControlEventTouchUpInside];
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
        
        numberFormatter = [TuplitConstants getCurrencyFormat];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - UserDefined methods

-(void) updateRow:(SpecialProductsModel*) _specialProductsModel {
    
    specialProductsModel = _specialProductsModel;
    
    [itemImgView setImageURL:[NSURL URLWithString:specialProductsModel.Photo]];
    
    if ([specialProductsModel.quantity intValue] > 1) {
        
        itemQuantityLbl.hidden = NO;
        itemQuantityLbl.text = [NSString stringWithFormat:@"%@x",specialProductsModel.quantity];
        itemQuantityLbl.frame = CGRectMake(50 + 5,0, [itemQuantityLbl.text widthWithFont:itemQuantityLbl.font], CART_CELL_HEIGHT-2);
    }
    else
    {
        itemQuantityLbl.hidden = YES;
        itemQuantityLbl.text = @"";
        itemQuantityLbl.frame = CGRectMake(50,0, 0, CART_CELL_HEIGHT-2);
    }
    
    
    double discountPrice = [specialProductsModel.DiscountPrice doubleValue];
    if ([specialProductsModel.DiscountPrice doubleValue] == 0.0) {
        discountPrice = [specialProductsModel.Price doubleValue];
        fixedAmountLbl.hidden = YES;
    }
    else
    {
        discountPrice = [specialProductsModel.DiscountPrice doubleValue];
        fixedAmountLbl.hidden = NO;
    }
    
    double quantity = [specialProductsModel.quantity intValue];
    double price = [specialProductsModel.Price doubleValue];
    
    discountAmountLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(discountPrice * quantity)]];
    float discountWidth = [discountAmountLbl.text widthWithFont:discountAmountLbl.font];
    discountAmountLbl.frame = CGRectMake((self.contentView.frame.size.width - discountWidth) - 5, 0, discountWidth, CART_CELL_HEIGHT-2);
    
    fixedAmountLbl.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(price * quantity)]];
    float fixedAmountWidth = [fixedAmountLbl.text widthWithFont:fixedAmountLbl.font];
    fixedAmountLbl.frame = CGRectMake((discountAmountLbl.frame.origin.x - fixedAmountWidth) - 5, 0, fixedAmountWidth, CART_CELL_HEIGHT-2);
    
    itemNameLbl.text = specialProductsModel.ItemName;
    itemNameLbl.frame = CGRectMake(CGRectGetMaxX(itemQuantityLbl.frame) + 5,0, fixedAmountLbl.frame.origin.x - CGRectGetMaxX(itemQuantityLbl.frame) - 4, CART_CELL_HEIGHT-2);
}

-(void) removeCartItem : (id) sender
{
    int quantity = [specialProductsModel.quantity intValue];
    quantity = quantity - 1;
    APP_DELEGATE.cartModel.productCount = APP_DELEGATE.cartModel.productCount-1;
    if (quantity<=0) {
        quantity = 0;
        
        [self didSwipeLeftInCell:nil];
        
        [APP_DELEGATE.cartModel.products removeObjectAtIndex:indexPath.row];
        
        id view = [self superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        
        UITableView *tableView = (UITableView *)view;
        [tableView reloadData];
        
        [delegate didPlusOrMinusPressed];
        
        return;
    }
    
    [specialProductsModel setQuantity:[NSString stringWithFormat:@"%d",quantity]];
    
    [self updateRow:specialProductsModel];
    
    [APP_DELEGATE.cartModel.products setObject:specialProductsModel atIndexedSubscript:indexPath.row];
    
    [delegate didPlusOrMinusPressed];
}

-(void) addCartItem : (id) sender
{
    int quantity = [specialProductsModel.quantity intValue];
    quantity = quantity + 1;
    APP_DELEGATE.cartModel.productCount = APP_DELEGATE.cartModel.productCount+1;
    
    [specialProductsModel setQuantity:[NSString stringWithFormat:@"%d",quantity]];
    
    [self updateRow:specialProductsModel];
    
    [APP_DELEGATE.cartModel.products setObject:specialProductsModel atIndexedSubscript:indexPath.row];
    
    [delegate didPlusOrMinusPressed];
}

-(void)didSwipeRightInCell:(id)sender
{
    [delegate didSwipeRightInCellWithIndexPath:indexPath];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        [swipeView setFrame:CGRectMake(-100, 0, self.contentView.frame.size.width, CART_CELL_HEIGHT)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            [editView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, CART_CELL_HEIGHT)];
            
        } ];
    }];
}

-(void)didSwipeLeftInCell:(id)sender
{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.15 animations:^{
        [swipeView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, CART_CELL_HEIGHT)];
    }];
}

@end
