//
//  OUSShadowView.m
//  Imago
//
//  Created by Eoin Norris on 08/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "OUSShadowView.h"

@implementation OUSShadowView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) drawRect:(CGRect)rect
{
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    NSColor * whiteColor = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    CGContextSetFillColorWithColor(context.graphicsPort, whiteColor.CGColor);
    CGContextFillRect(context.graphicsPort, self.bounds);
    
    CGContextSetFillColorWithColor(context.graphicsPort, whiteColor.CGColor);

}

@end
