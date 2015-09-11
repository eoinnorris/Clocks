//
//  NSImage+Resize.h
//  Imago
//
//  Created by Eoin Norris on 02/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Resize)

+ (NSImage *)resizeImage:(NSImage*)anImage
                 newSize:(NSSize)newSize;
- (CGImageRef)cgImageOfSize:(NSSize)newSize;
@end
