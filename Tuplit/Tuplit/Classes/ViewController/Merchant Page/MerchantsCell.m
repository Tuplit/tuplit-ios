//
//  MerchantsCell.m
//  Tuplit
//
//  Created by ev_mac1 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "MerchantsCell.h"

@implementation MerchantsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,MERCHANT_CELL_HEIGHT)];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:containerView];
        
        productImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""] imageViewFrame:containerView.bounds];
        productImgView.backgroundColor = [UIColor clearColor];
        [productImgView setContentMode:UIViewContentModeScaleAspectFill];
        productImgView.clipsToBounds = YES;
        productImgView.delegate = self;
        [containerView addSubview:productImgView];
        
        UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        shadowImgView.backgroundColor = [UIColor clearColor];
        [shadowImgView setImage:[UIImage imageNamed:@"shadow"]];
        [productImgView addSubview:shadowImgView];
        
        //Discount Label
        discountLbl = [[UILabel alloc ] initWithFrame:CGRectMake(containerView.frame.size.width - 30, 5,30,20)];
        discountLbl.backgroundColor = [UIColor clearColor];
        discountLbl.textAlignment = NSTextAlignmentLeft;
        discountLbl.textColor = UIColorFromRGB(0Xffffff);
        discountLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        [containerView addSubview:discountLbl];
        
        UIImage *discountImage = [UIImage imageNamed:@"DiscountMap"];
        discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(discountLbl.frame) - discountLbl.frame.size.width, 8,discountImage.size.width, discountImage.size.height)];
        discountImageView.backgroundColor = [UIColor clearColor];
        discountImageView.image = discountImage;
        [containerView addSubview:discountImageView];
        
        //Merchant details
        UIView *merchantdetailView = [[UIView alloc] initWithFrame:CGRectMake(0, containerView.frame.size.height - 45, containerView.frame.size.width, 45)];
        [merchantdetailView setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:merchantdetailView];
        
        /*blurView = [[FXBlurView alloc] initWithFrame:merchantdetailView.bounds];
         blurView.blurRadius = 2;
         blurView.tintColor = UIColorFromRGB(0x000000);
         blurView.underlyingView = productImgView;
         [merchantdetailView addSubview:blurView];*/
        
        merchantImgView=[[EGOImageView alloc]initWithPlaceholderImage:nil imageViewFrame:CGRectMake(8,-3,40,40)];
        merchantImgView.backgroundColor = [UIColor whiteColor];
        merchantImgView.contentMode = UIViewContentModeScaleAspectFill;
        merchantImgView.layer.cornerRadius = 20;
        merchantImgView.clipsToBounds = YES;
        [merchantdetailView addSubview:merchantImgView];
        
        merchantNameLbl = [[UILabel alloc ] initWithFrame:CGRectMake(8 + 40 + 10, -3,200,25)];
        merchantNameLbl.backgroundColor = [UIColor clearColor];
        merchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        merchantNameLbl.userInteractionEnabled = YES;
        merchantNameLbl.textAlignment = NSTextAlignmentLeft;
        merchantNameLbl.textColor = UIColorFromRGB(0Xffffff);
        [merchantdetailView addSubview:merchantNameLbl];
        
        descriptionLbl = [[UILabel alloc ] initWithFrame:CGRectMake(8 + 40 + 10, CGRectGetMaxY(merchantNameLbl.frame) - 3,200,20)];
        descriptionLbl.backgroundColor = [UIColor clearColor];
        descriptionLbl.textAlignment = NSTextAlignmentLeft;
        descriptionLbl.textColor = UIColorFromRGB(0Xffffff);
        descriptionLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        [merchantdetailView addSubview:descriptionLbl];
        
        distanceLbl  = [[UILabel alloc ] initWithFrame:CGRectMake(merchantdetailView.frame.size.width - 30 - 5,merchantdetailView.frame.size.height - 20 - 5,30,20)];
        distanceLbl.textColor = UIColorFromRGB(0Xffffff);
        distanceLbl.backgroundColor = [UIColor clearColor];
        distanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
        distanceLbl.userInteractionEnabled = YES;
        distanceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        distanceLbl.textAlignment = NSTextAlignmentRight;
        [merchantdetailView addSubview : distanceLbl];
        
        UIImage *distanceImage = [UIImage imageNamed:@"MapDistance"];
        distanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((merchantdetailView.frame.size.width - distanceLbl.frame.size.width - distanceImage.size.width), merchantdetailView.frame.size.height - 22, distanceImage.size.width, distanceImage.size.height)];
        distanceImageView.backgroundColor = [UIColor clearColor];
        distanceImageView.image = distanceImage;
        [merchantdetailView addSubview:distanceImageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,containerView.frame.size.height - 1,self.size.width,1)];
        lineView.backgroundColor = APP_DELEGATE.defaultColor;
        [containerView addSubview:lineView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setMerchant:(MerchantModel *) merchant
{
    [productImgView setImageURL:[NSURL URLWithString:merchant.Image]];
    [discountLbl setText:merchant.DiscountTier];
    
    CGRect discountFrame = discountLbl.frame;
    discountFrame.size.width = [discountLbl.text widthWithFont:discountLbl.font];
    discountFrame.origin.x = self.contentView.frame.size.width - discountFrame.size.width - 10;
    [discountLbl setFrame:discountFrame];
    
    CGRect discountImageViewFrame = discountImageView.frame;
    discountImageViewFrame.origin.x = CGRectGetMinX(discountLbl.frame) - discountImageView.frame.size.width - 3;
    [discountImageView setFrame:discountImageViewFrame];
    
    [merchantImgView setImageURL:[NSURL URLWithString:merchant.Icon]];
    [merchantNameLbl setText:[merchant.CompanyName stringWithTitleCase]];
    [descriptionLbl setText:[merchant.ShortDescription capitaliseFirstLetter]];
    [distanceLbl setText:[TuplitConstants getDistance:[merchant.distance doubleValue]]];
    
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
    
    if ([merchant.TagType intValue] == 1)                               // 1/3
    {
        [discountImageView setImage:[UIImage imageNamed:@"DiscountMap"]];
    }
    else if([merchant.TagType intValue] == 2)                           // 2/3
    {
        [discountImageView setImage:[UIImage imageNamed:@"red_tag"]];
    }
    else if([merchant.TagType intValue] == 3)                           // 3/3
    {
        [discountImageView setImage:[UIImage imageNamed:@"FavouriteStar"]];
    }
    else
    {
        discountImageView.hidden = YES;
    }

}

#pragma mark - EGOImageViewDelegate

- (void)imageViewLoadedImage:(EGOImageView*)imageView {
    
    
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error {
    
}

@end
