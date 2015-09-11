//
//  OUSTwitterObject.m
//  Imago
//
//  Created by Eoin Norris on 05/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "OUSTwitterObject.h"

@implementation OUSTwitterObject

- (void)setThumbNail:(CGImageRef)thumbNail_{
    
    if (_thumbNail){
        CFRelease(_thumbNail);
    }
    _thumbNail = thumbNail_;
    
    if (_thumbNail){
        CFRetain(_thumbNail);
    }
}

- (void)setImageLarge:(CGImageRef)imageLarge_{
    if (_imageLarge) {
        CFRelease(_imageLarge);
    }
    _imageLarge = imageLarge_;
    if (_imageLarge) {
        CFRetain(imageLarge_);
    }
}


- (void)setImageMedium:(CGImageRef)imageMedium_{
    if (_imageMedium) {
        CFRelease(_imageMedium);
    }
    _imageMedium = imageMedium_;
    if (_imageMedium) {
        CFRetain(_imageMedium);
    }
}


- (void)dealloc
{
    if (_thumbNail) 
        CFRelease(_thumbNail);
    if (_imageLarge) 
         CFRelease(_imageLarge);
    if (_imageMedium) 
         CFRelease(_imageMedium);
}

@end
