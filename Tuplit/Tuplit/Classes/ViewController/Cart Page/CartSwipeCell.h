//
//  CartSwipeCell.h
//  Tuplit
//
//  Created by ev_mac8 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialProductsModel.h"

#define CART_CELL_HEIGHT 52

@protocol CartSwipeCellProtocol <NSObject>

- (void) didSwipeRightInCellWithIndexPath:(NSIndexPath *) indexPath;
- (void) didPlusOrMinusPressed;

@end

@interface CartSwipeCell : UITableViewCell
{
    UIView *swipeView;
    UIView *editView;
    
    NSNumberFormatter *numberFormatter;
    SpecialProductsModel *specialProductsModel;
}

@property(nonatomic,retain) NSIndexPath *indexPath;
@property(nonatomic,retain) id <CartSwipeCellProtocol> delegate;

@property(nonatomic,strong) UILabel *itemNameLbl,*fixedAmountLbl,*discountAmountLbl,*itemQuantityLbl;
@property(nonatomic,strong) EGOImageView *itemImgView;

-(void) didSwipeLeftInCell:(id)sender;
-(void) didSwipeRightInCell:(id)sender;
-(void) updateRow:(SpecialProductsModel*) specialProductsModel;

@end
