//
//  EGOImageView.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOImageView.h"
#import "EGOImageLoader.h"

#define ACTIVITY_W_H 14

@implementation EGOImageView
@synthesize imageURL, placeholderImage, delegate;
@synthesize loadedFromCache = _loadedFromCache;

- (id)initWithPlaceholderImage:(UIImage*)anImage imageViewFrame:(CGRect)frame showActivityIndicator:(BOOL)showActivityIndicator {
    
    imageFrame = frame;
    return [self initWithPlaceholderImage:anImage delegate:nil showActivityIndicator:showActivityIndicator];
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate showActivityIndicator:(BOOL)showActivityIndicator {
	if((self = [super initWithImage:anImage])) {
		activity = [[UIActivityIndicatorView alloc] init];
		[activity setFrame:CGRectMake((self.frame.size.width - ACTIVITY_W_H)/2, (self.frame.size.height - ACTIVITY_W_H)/2, ACTIVITY_W_H, ACTIVITY_W_H)];
		[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:activity];
		activity.alpha = showActivityIndicator?1:0;
		
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
	}
	
	return self;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage imageViewFrame:(CGRect)frame {
    
    imageFrame = frame;
    
    activity = [[UIActivityIndicatorView alloc] init];
    [activity setFrame:CGRectMake((self.frame.size.width - ACTIVITY_W_H)/2, (self.frame.size.height - ACTIVITY_W_H)/2, ACTIVITY_W_H, ACTIVITY_W_H)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activity];
        
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate {
	if((self = [super initWithImage:anImage])) {
        activity = [[UIActivityIndicatorView alloc] init];
        [activity setFrame:CGRectMake((self.frame.size.width - ACTIVITY_W_H)/2, (self.frame.size.height - ACTIVITY_W_H)/2, ACTIVITY_W_H, ACTIVITY_W_H)];
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activity];
        
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
	}
	
	return self;
}

- (void) setImageFrame:(CGRect)frame
{
    //  self.frame=frame;
    imageFrame=frame;
    [self layoutSubviews];
}

- (void)setImageURL:(NSURL *)aURL {
        
	if(imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
	}
	
	NSString *myString = [aURL absoluteString];
    
    if(aURL && [myString isEqualToString:@""]) {
		self.image = self.placeholderImage;
		imageURL = nil;
		return;
	} else {
		imageURL = [aURL retain];
	}

	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self indicator:activity];
	
	if(anImage) {
		self.image = anImage;
        
        _loadedFromCache = YES;

		// trigger the delegate callback if the image was found in the cache
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
			[self.delegate imageViewLoadedImage:self];
		}
	} else {
		self.image = self.placeholderImage;
        _loadedFromCache = NO;
	}
}

- (void)activityIndicatorHide {
    
    [activity stopAnimating];
    activity.hidden = YES;
    activity = nil;
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
    
    [activity stopAnimating];
    
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification {
    
    [activity stopAnimating];
    
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;

	UIImage* anImage = [[notification userInfo] objectForKey:@"image"];
	self.image = anImage;
	[self setNeedsDisplay];
    
    _loadedFromCache = NO;
	
	if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) {
		[self.delegate imageViewLoadedImage:self];
	}
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
    
    [activity stopAnimating];
    
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)]) {
		[self.delegate imageViewFailedToLoadImage:self error:[[notification userInfo] objectForKey:@"error"]];
	}
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setFrame:imageFrame];
    
    [activity setFrame:CGRectMake((self.frame.size.width - ACTIVITY_W_H)/2, (self.frame.size.height - ACTIVITY_W_H)/2, ACTIVITY_W_H, ACTIVITY_W_H)];
}

#pragma mark -
- (void)dealloc {
    
    [activity release];
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	self.delegate = nil;
	self.imageURL = nil;
	self.placeholderImage = nil;
    [super dealloc];
}

@end
