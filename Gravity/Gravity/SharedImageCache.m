//
//  SharedImageCache.m
//  Image Cache
//
//  Created by Grant Davis on 6/5/10.
//  Copyright 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "SharedImageCache.h"


@implementation SharedImageCache

static ImageCache *cache = nil;

+ (ImageCache*)initWithMaxMemoryBytes:(NSUInteger)memBytes maxDiskBytes:(NSUInteger)diskBytes
{	
	if( cache == nil) {
		cache = [[ImageCache alloc] initWithMaxMemorySize:memBytes diskSize:diskBytes];
	}
	return cache;
}

+ (ImageCache*)imageCache
{
	if (cache == nil) {
        NSUInteger memoryMax = 2*1024*1024;     // 2 MB
        NSUInteger diskMax = 160*1024*1024;     // 160 MB
		cache = [[ImageCache alloc] initWithMaxMemorySize:memoryMax diskSize:diskMax];
	}
	return cache;
}

+ (void)clearCache
{
	[cache clear];
}

@end
