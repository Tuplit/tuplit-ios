//
//  TLCatagoryView.m
//  Tuplit
//
//  Created by ev_mac11 on 19/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLCategoryView.h"
#import "CategoryModel.h"

@implementation TLCategoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUpCategoryView:(NSArray *)categories andWidth:(float)width
{
    int xPosition = 3, yPosition = 3;
    int viewHeight = 0;
    
    for (int i = 0; i < categories.count; i++)
    {
        CategoryModel *categoryModel = [categories objectAtIndex:i];
        
        UIImage * categoryImg = getImage(@"res", NO);
        
        int labelWidth = [categoryModel.CategoryName widthWithFont:[UIFont fontWithName:@"HelveticaNeue" size:12]]+1;
        
        if (xPosition + categoryImg.size.width + 3+labelWidth <= width)
        {
            xPosition = xPosition == 3 ? xPosition : xPosition + 2;
        }
        else
        {
            xPosition = 3;
            yPosition += categoryImg.size.height+3;
        }
        
        EGOImageView * categoryImageView =[[EGOImageView alloc]initWithPlaceholderImage:nil imageViewFrame:CGRectMake(xPosition, yPosition, categoryImg.size.width, categoryImg.size.height)];
        categoryImageView.imageURL = [NSURL URLWithString:categoryModel.CategoryIcon];
        [categoryImageView setTag:(i+2200)];
        [self addSubview:categoryImageView];
        
        xPosition += categoryImg.size.width + 3;
    
        UILabel * catagoryNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(xPosition, yPosition, labelWidth, categoryImg.size.height)];
        catagoryNameLabel.text=categoryModel.CategoryName;
        [catagoryNameLabel setTag:(i+2300)];
        catagoryNameLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
        catagoryNameLabel.backgroundColor=[UIColor clearColor];
        catagoryNameLabel.textColor = UIColorFromRGB(0x999999);
//        [catagoryNameLabel sizeToFit];
        [self addSubview:catagoryNameLabel];

        xPosition += labelWidth;
        viewHeight = CGRectGetMaxY(catagoryNameLabel.frame);
    }
    [self setHeight:MAX(yPosition, viewHeight)];
    self.ctgviewHeight = self.height;
}


@end
