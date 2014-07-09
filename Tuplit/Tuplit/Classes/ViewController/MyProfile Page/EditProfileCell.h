//
//  EditProfileCellTableViewCell.h
//  Tuplit
//
//  Created by ev_mac8 on 20/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROFILE_CELL_HEIGHT 52

@class EditProfileCell;

@protocol EditProfileCellProtocol <NSObject>
-(void) didSwipeRightInCellWithIndexPath:(NSIndexPath *) indexPath;
@end


@interface EditProfileCell : UITableViewCell
{
    UIView *swipeView;
    UIView *editView;
}

@property(nonatomic,retain) NSIndexPath *indexPaths;
@property(nonatomic,assign) NSInteger sections;
@property(nonatomic,retain) id <EditProfileCellProtocol> delegate;

-(void)didSwipeLeftInCell:(id)sender;
-(void)didSwipeRightInCell:(id)sender;

@end
