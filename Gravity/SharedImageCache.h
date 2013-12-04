//
//  SharedImageCache.h
//  Image Cache
//
//  Created by Grant Davis on 6/5/10.
//  Copyright 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"


@interface SharedImageCache : NSObject {

}

+ (ImageCache*)imageCache;
+ (ImageCache*)initWithMaxMemoryBytes:(NSUInteger)memBytes maxDiskBytes:(NSUInteger)diskBytes;
+ (void)clearCache;

@end
