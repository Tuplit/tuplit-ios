//
//  Global.m
//  Tuplit
//
//  Created by ev_mac6 on 19/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (Global *)instance
{
	static Global * wInstance;
	
	@synchronized(self)
	{
		if (!wInstance)
        {
            wInstance = [[Global alloc] init];
        }
	}
	
	return wInstance;
}

@end
