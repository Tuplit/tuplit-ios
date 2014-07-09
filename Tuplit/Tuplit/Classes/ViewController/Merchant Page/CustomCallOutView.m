//
//  CustomCallOutViewController.m
//  Tuplit
//
//  Created by ev_mac1 on 20/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CustomCallOutView.h"
#define FRAME_HEIGHT 65
#define FRAME_WIDTH 250

@interface CustomCallOutView ()

@end

@implementation CustomCallOutView
@synthesize delegate = _delegate;

-(void)loadView
{
    self.userInteractionEnabled = YES;
    
    self.backgroundColor = [UIColor clearColor];
    callOutImage = getImage(@"CallOut", NO);
    stretchableBackButtonImage = [callOutImage stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    self.image = stretchableBackButtonImage;
    
    annLogoImgView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"DiscountMap.ong"] imageViewFrame:CGRectMake(5,(FRAME_HEIGHT-40-19)/2,40,40)];
    annLogoImgView.backgroundColor = [UIColor clearColor];
    annLogoImgView.layer.cornerRadius = 40/2;
    annLogoImgView.clipsToBounds = YES;
    [self addSubview:annLogoImgView];
    
    annMerchantNameLbl = [[UILabel alloc ] initWithFrame:CGRectMake(50,0,110,FRAME_HEIGHT- 23)];
    annMerchantNameLbl.textColor = UIColorFromRGB(0x000000);
    annMerchantNameLbl.backgroundColor = [UIColor clearColor];
    annMerchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    annMerchantNameLbl.userInteractionEnabled = YES;
    annMerchantNameLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:annMerchantNameLbl];
    
    NSLog(@"width = %d",FRAME_WIDTH);
    annDiscountLbl = [[UILabel alloc ] initWithFrame:CGRectMake(FRAME_WIDTH-45,3,30,20)];
    annDiscountLbl.textColor = UIColorFromRGB(0x000000);
    annDiscountLbl.backgroundColor = [UIColor clearColor];
    annDiscountLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    annDiscountLbl.userInteractionEnabled = YES;
    annDiscountLbl.textAlignment = NSTextAlignmentLeft;
    annDiscountLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [self addSubview:annDiscountLbl];
    
    UIImage * annDiscountImg = [UIImage imageNamed:@"DiscountMap.png"];
    UIImageView * anndiscountImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDiscountLbl.frame)-15,5.7,annDiscountImg.size.width, annDiscountImg.size.height)];
    anndiscountImg.backgroundColor = [UIColor clearColor];
    anndiscountImg.image           = annDiscountImg;
    [self addSubview:anndiscountImg];
    
    annDistanceLbl= [[UILabel alloc ] initWithFrame:CGRectMake(178,CGRectGetMaxY(annDiscountLbl.frame),70,20)];
    annDistanceLbl.textColor = UIColorFromRGB(0x000000);
    annDistanceLbl.backgroundColor = [UIColor clearColor];
    annDistanceLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    annDistanceLbl.userInteractionEnabled = YES;
    annDistanceLbl.textAlignment = NSTextAlignmentLeft;
    annDistanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    annDistanceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    annDistanceLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview : annDistanceLbl];
    
    UIImage * annDistanceImg = [UIImage imageNamed:@"MapDistance.png"];
    annDistanceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDistanceLbl.frame)-13,CGRectGetMaxY(annDiscountLbl.frame)+5,annDistanceImg.size.width, annDistanceImg.size.height)];
    annDistanceImgView.backgroundColor = [UIColor clearColor];
    annDistanceImgView.image = annDistanceImg;
    [self addSubview:annDistanceImgView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"TutorNextLight.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calloutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(FRAME_WIDTH-20,15, 20, 20);
    [self  addSubview:button];
}



- (void)setMerchant:(MerchantModel *)merchant
{
    merModel = merchant;
    
    annLogoImgView.imageURL = [NSURL URLWithString:merchant.Icon];
    annMerchantNameLbl.text = merchant.CompanyName;
    annDiscountLbl.text = merchant.DiscountTier;
    annDistanceLbl.text = [TuplitConstants getDistance:[merchant.distance doubleValue]];
    
    if (annDistanceLbl.text.length > 0) {
        
        CGRect distanceFrame = annDistanceLbl.frame;
        distanceFrame.size.width = [annDistanceLbl.text widthWithFont:annDistanceLbl.font];
        distanceFrame.origin.x = FRAME_WIDTH - distanceFrame.size.width - 22;
        [annDistanceLbl setFrame:distanceFrame];
        
        CGRect distanceImageViewFrame = annDistanceImgView.frame;
        distanceImageViewFrame.origin.x = CGRectGetMinX(annDistanceLbl.frame) - annDistanceImgView.frame.size.width;
        [annDistanceImgView setFrame:distanceImageViewFrame];
            
        CGRect descriptionFrame = annMerchantNameLbl.frame;
        descriptionFrame.size.width = annDistanceImgView.frame.origin.x - 5 - 50;
        annMerchantNameLbl.frame = descriptionFrame;
        
        annDistanceLbl.hidden = NO;
        annDistanceImgView.hidden = NO;
    }
    else
    {
        annDistanceLbl.hidden = YES;
        annDistanceImgView.hidden = YES;
    }
    
}

#pragma mark - User Defined Methods


- (void)calloutButtonClicked
{
    CalloutAnnotation *annotation = self.annotation;
    [_delegate calloutButtonClicked:(NSString *)annotation.titlestr];
}

@end
