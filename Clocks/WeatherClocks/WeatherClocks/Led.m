//
//  Led.m
//  LeafClock
//
//  Created by Eoin norris on 25/10/2009.
//  Copyright 2009 Occasionally Useful Software. All rights reserved.
//

#import "Led.h"

#define kMaxNumber 4

@implementation Led

@synthesize vertices=_vertices;

-(void)setVertices:(CGPoint [])inVertices 
{
	NSInteger i;
	
	_vertices = malloc(sizeof(CGPoint) * 4.0);
	for (i=0; i<kMaxNumber; i++)
	{
		_vertices[i] = CGPointMake(inVertices[i].x, inVertices[i].y);
	}
}



@end
