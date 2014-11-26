//
//  SearchTableCell.m
//  Tuplit
//
//  Created by ev_mac1 on 17/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "MerchantSearchCell.h"


@implementation MerchantSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,SEARCH_CELL_HEIGHT)];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:containerView];
        
        merchantImgView=[[EGOImageView alloc]initWithPlaceholderImage:nil imageViewFrame:CGRectMake(10,(SEARCH_CELL_HEIGHT - 40)/2,40,40)];
        merchantImgView.backgroundColor = [UIColor brownColor];
        merchantImgView.contentMode = UIViewContentModeScaleAspectFill;
        merchantImgView.layer.cornerRadius = 20;
        merchantImgView.clipsToBounds = YES;
        [containerView addSubview:merchantImgView];
        
        merchantNameLbl = [[UILabel alloc ] initWithFrame:CGRectMake(10 + 40 + 10, 3,200,25)];
        merchantNameLbl.backgroundColor = [UIColor clearColor];
        merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        merchantNameLbl.userInteractionEnabled = YES;
        merchantNameLbl.textAlignment = NSTextAlignmentLeft;
        merchantNameLbl.textColor = UIColorFromRGB(0x000000);
        [containerView addSubview:merchantNameLbl];
        
        descriptionLbl = [[UILabel alloc ] initWithFrame:CGRectMake(8 + 40 + 10, CGRectGetMaxY(merchantNameLbl.frame) - 3,200,20)];
        descriptionLbl.backgroundColor = [UIColor clearColor];
        descriptionLbl.textAlignment = NSTextAlignmentLeft;
        descriptionLbl.textColor = [UIColor lightGrayColor]; //UIColorFromRGB(0Xffffff);
        descriptionLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        [containerView addSubview:descriptionLbl];
        
        distanceLbl  = [[UILabel alloc ] initWithFrame:CGRectMake(containerView.frame.size.width - 30 - 5,containerView.frame.size.height - 20 - 5,30,20)];
        distanceLbl.textColor = [UIColor lightGrayColor]; //UIColorFromRGB(0x000000);
        distanceLbl.backgroundColor = [UIColor clearColor];
        distanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        distanceLbl.userInteractionEnabled = YES;
        distanceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        distanceLbl.textAlignment = NSTextAlignmentRight;
        [containerView addSubview : distanceLbl];
        
        UIImage *distanceImage = [UIImage imageNamed:@"MapDistance"];
        distanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((containerView.frame.size.width - distanceLbl.frame.size.width - distanceLbl.size.width), containerView.frame.size.height - 22, distanceImage.size.width, distanceImage.size.height)];
        distanceImageView.backgroundColor = [UIColor clearColor];
        distanceImageView.image = distanceImage;
        [containerView addSubview:distanceImageView];
        
        //Discount Label
        discountLbl = [[UILabel alloc ] initWithFrame:CGRectMake(containerView.frame.size.width - 30, 5,30,20)];
        discountLbl.textColor = [UIColor lightGrayColor];
        discountLbl.backgroundColor = [UIColor clearColor];
        discountLbl.textAlignment = NSTextAlignmentLeft;
        discountLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        [containerView addSubview:discountLbl];
        
        UIImage *discountImage = [UIImage imageNamed:@"DiscountMap"];
        discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(discountLbl.frame) - discountLbl.frame.size.width, 8,discountImage.size.width, discountImage.size.height)];
        discountImageView.backgroundColor = [UIColor clearColor];
        discountImageView.image = discountImage;
        [containerView addSubview:discountImageView];
        
        int yPosition;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            yPosition = self.size.height + 6.30;
        }
        else{
            yPosition = self.size.height + 5;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(61, yPosition, (320 - 60), 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setMerchant:(MerchantModel *) merchant
{
    [merchantImgView setImageURL:[NSURL URLWithString:merchant.Icon]];
    [merchantNameLbl setText:[merchant.CompanyName stringWithTitleCase]];
    [descriptionLbl setText:merchant.ShortDescription];
    [distanceLbl setText:[TuplitConstants getDistance:[merchant.distance doubleValue]]];
    
    [discountLbl setText:merchant.DiscountTier];
    
    CGRect discountFrame = discountLbl.frame;
    discountFrame.size.width = [discountLbl.text widthWithFont:discountLbl.font];
    discountFrame.origin.x = self.contentView.frame.size.width - discountFrame.size.width - 10;
    [discountLbl setFrame:discountFrame];
    
    CGRect discountImageViewFrame = discountImageView.frame;
    discountImageViewFrame.origin.x = CGRectGetMinX(discountLbl.frame) - discountImageView.frame.size.width - 3;
    [discountImageView setFrame:discountImageViewFrame];
    
    if (distanceLbl.text.length > 0) {
        
        CGRect distanceFrame = distanceLbl.frame;
        distanceFrame.size.width = [distanceLbl.text widthWithFont:distanceLbl.font];
        distanceFrame.origin.x = self.contentView.frame.size.width - distanceFrame.size.width - 10;
        [distanceLbl setFrame:distanceFrame];
        
        CGRect distanceImageViewFrame = distanceImageView.frame;
        distanceImageViewFrame.origin.x = CGRectGetMinX(distanceLbl.frame) - distanceImageView.frame.size.width - 2;
        [distanceImageView setFrame:distanceImageViewFrame];
        
        if(distanceImageView.frame.origin.x > 150) {
            CGRect descriptionFrame = descriptionLbl.frame;
            descriptionFrame.size.width = 170;
            descriptionLbl.frame = descriptionFrame;
        }
        else
        {
            CGRect descriptionFrame = descriptionLbl.frame;
            descriptionFrame.size.width = 200;
            descriptionLbl.frame = descriptionFrame;
        }
        
        distanceLbl.hidden = NO;
        distanceImageView.hidden = NO;
    }
    else
    {
        CGRect descriptionFrame = descriptionLbl.frame;
        descriptionFrame.size.width = 200;
        descriptionLbl.frame = descriptionFrame;
        
        distanceLbl.hidden = YES;
        distanceImageView.hidden = YES;
    }
    
    discountImageView.hidden = NO;
    if([merchant.NewTag intValue]==1)
    {
        discountImageView.image = getImage(@"NewIcon", NO);
    }
    else
    {
        if ([merchant.TagType intValue] == 1) {
            [discountImageView setImage:[UIImage imageNamed:@"DiscountMap"]];
        }
        else if([merchant.TagType intValue] == 2)
        {
            [discountImageView setImage:[UIImage imageNamed:@"red_tag"]];
        }
        else if([merchant.TagType intValue] == 3)
        {
            [discountImageView setImage:[UIImage imageNamed:@"FavouriteStar"]];
        }
        else{
            discountImageView.hidden = YES;
        }
    }
}

- (void) setCategory:(CategoryModel *) categoryModel
{
    [merchantImgView setImageURL:[NSURL URLWithString:categoryModel.CategoryIcon]];
    [merchantNameLbl setText:[categoryModel.CategoryName stringWithTitleCase]];
    distanceLbl.text = @"";
    discountLbl.text = @"";
    
    NSString *merchantCount;
    if ([categoryModel.MerchantCount intValue] == 1) {
        merchantCount = [NSString stringWithFormat:@"%@ Merchant",categoryModel.MerchantCount];
    }
    else
    {
        merchantCount = [NSString stringWithFormat:@"%@ Merchants",categoryModel.MerchantCount];
    }
    
    [descriptionLbl setText:merchantCount];
    
    distanceLbl.hidden = YES;
    distanceImageView.hidden = YES;
    discountImageView.hidden = YES;
}

@end
