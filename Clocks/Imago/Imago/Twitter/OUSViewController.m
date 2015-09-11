//
//  OUSViewController.m
//  Imago
//
//  Created by Eoin Norris on 08/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "OUSViewController.h"
#import "NSImage+Resize.h"

@interface OUSViewController ()

@end

@implementation OUSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (CGImageRef)imageForTwitterView {
    
    NSSize imgSize = self.view.bounds.size;
    
    NSBitmapImageRep * bir = [self.view bitmapImageRepForCachingDisplayInRect:[self.view bounds]];
    [bir setSize:imgSize];
    
    [self.view cacheDisplayInRect:[self.view bounds] toBitmapImageRep:bir];
    
    NSImage* image = [[NSImage alloc] initWithSize:imgSize];
    [image addRepresentation:bir];
    
    CGImageRef imageRef = [image cgImageOfSize:imgSize];

    
    return imageRef;
}





@end
