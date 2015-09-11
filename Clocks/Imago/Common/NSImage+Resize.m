//
//  NSImage+Resize.m
//  Imago
//
//  Created by Eoin Norris on 02/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "NSImage+Resize.h"

@implementation NSImage (Resize)

+ (NSImage *)resizeImage:(NSImage *)anImage
                 newSize:(NSSize)newSize{
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}


- (CGImageRef)cgImageOfSize:(NSSize)newSize
{
    NSRect rect = NSMakeRect(0, 0, newSize.width, newSize.height);
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    
    [context setImageInterpolation:NSImageInterpolationLow];
    CGImageRef imageRef = [self CGImageForProposedRect:&rect
                                                    context:context
                                                 hints:@{NSDeviceColorSpaceName:NSDeviceWhiteColorSpace}];
    
    return imageRef;
}



@end
