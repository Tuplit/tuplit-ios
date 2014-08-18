//
//  CustomCallOutViewController.m
//  Tuplit
//
//  Created by ev_mac1 on 20/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CustomCallOutView.h"
#import "CategoryModel.h"

#define FRAME_HEIGHT 80
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
    
    annMerchantNameLbl = [[UILabel alloc ] initWithFrame:CGRectMake(50,5,110,20)];
    annMerchantNameLbl.textColor = UIColorFromRGB(0x000000);
    annMerchantNameLbl.backgroundColor = [UIColor clearColor];
    annMerchantNameLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
//    annMerchantNameLbl.userInteractionEnabled = YES;
    annMerchantNameLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:annMerchantNameLbl];
    
    annMerchantCatgLbl = [[UILabel alloc ] initWithFrame:CGRectMake(50,CGRectGetMaxY(annMerchantNameLbl.frame)+5,110,14)];
    annMerchantCatgLbl.textColor = UIColorFromRGB(0x000000);
    annMerchantCatgLbl.backgroundColor = [UIColor clearColor];
    annMerchantCatgLbl.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    annMerchantCatgLbl.numberOfLines=0;
    //    annMerchantNameLbl.userInteractionEnabled = YES;
//    annMerchantCatgLbl.text = @"category";
    annMerchantCatgLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:annMerchantCatgLbl];
    
    NSLog(@"width = %d",FRAME_WIDTH);
    annDiscountLbl = [[UILabel alloc ] initWithFrame:CGRectMake(FRAME_WIDTH-45,3,30,20)];
    annDiscountLbl.textColor = UIColorFromRGB(0x000000);
    annDiscountLbl.backgroundColor = [UIColor clearColor];
//    annDiscountLbl.userInteractionEnabled = YES;
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
//    annDistanceLbl.userInteractionEnabled = YES;
    annDistanceLbl.textAlignment = NSTextAlignmentLeft;
    annDistanceLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    annDistanceLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    annDistanceLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview : annDistanceLbl];
    
    UIImage * customerShoppedImage1 = getImage(@"shop_bag", NO);
    UIImageView * anncustomerShoppedImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDiscountLbl.frame)-15,FRAME_HEIGHT-customerShoppedImage1.size.height-23,customerShoppedImage1.size.width, customerShoppedImage1.size.height)];
    anncustomerShoppedImg.backgroundColor = [UIColor clearColor];
    anncustomerShoppedImg.image           = customerShoppedImage1;
    [self addSubview:anncustomerShoppedImg];
    
    customershoppedLbl = [[UILabel alloc ] initWithFrame:CGRectMake(FRAME_WIDTH-45,CGRectGetMaxY(annDistanceLbl.frame)-3,30,20)];
    customershoppedLbl.textColor = UIColorFromRGB(0x000000);
    customershoppedLbl.backgroundColor = [UIColor clearColor];
    //    annDiscountLbl.userInteractionEnabled = YES;
    customershoppedLbl.textAlignment = NSTextAlignmentLeft;
    customershoppedLbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    [self addSubview:customershoppedLbl];
    
    UIImage * annDistanceImg = [UIImage imageNamed:@"MapDistance.png"];
    annDistanceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(annDistanceLbl.frame)-13,CGRectGetMaxY(annDiscountLbl.frame)+5,annDistanceImg.size.width, annDistanceImg.size.height)];
    annDistanceImgView.backgroundColor = [UIColor clearColor];
    annDistanceImgView.image = annDistanceImg;
    [self addSubview:annDistanceImgView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"TutorNextLight.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calloutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(FRAME_WIDTH-20,(FRAME_HEIGHT-20-15)/2, 20, 20);
    [self  addSubview:button];
}


- (void)setMerchant:(MerchantModel *)merchant
{
    NSArray* priceComponent = [merchant.Category componentsSeparatedByString: @","];
    NSLog(@"%@",merchant.Category);
    if(priceComponent.count>0&&APP_DELEGATE.catgDict.count>0)
    {
        CategoryModel *catgModel = [APP_DELEGATE.catgDict valueForKey:[priceComponent objectAtIndex:0]];
        merModel = merchant;
        annMerchantCatgLbl.text = catgModel.CategoryName;
    }
    
//    NSLog(@"%@",catgModel.CategoryName);
    
    annLogoImgView.imageURL = [NSURL URLWithString:merchant.Icon];
    annMerchantNameLbl.text = [merchant.CompanyName stringWithTitleCase];
    annDiscountLbl.text = merchant.DiscountTier;
    annDistanceLbl.text = [TuplitConstants getDistance:[merchant.distance doubleValue]];
   
    
    float height = [annMerchantCatgLbl.text heigthWithWidth:annMerchantCatgLbl.frame.size.width andFont:annMerchantCatgLbl.font];
    annMerchantCatgLbl.height = height;
    
    customershoppedLbl.text = merchant.TotalUsersShopped;
//    int width = [annMerchantCatgLbl.text widthWithFont:annMerchantCatgLbl.font];
//       [customershoppedLbl positionAtX:FRAME_WIDTH-8-width];
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
    [_delegate calloutButtonClicked:(NSString *)annotation.title];
}

@end
