//
//  Leaf.h
//  LeafClock
//
//  Created by Eoin norris on 29/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

static const uint32_t leafCategoryFallingOn  =  0x1 << 0;
static const uint32_t leafCategoryFallingOFFLED =  0x1 << 1;
static const uint32_t leafCategoryOnLed  =  0x1 << 2;

@interface PhysicsClockItemSprite : SKSpriteNode

@property(nonatomic) BOOL shouldBeLit;
@property(nonatomic) BOOL isOnLed;
@property(nonatomic) CGPoint leafStoredPosition;
@property(nonatomic) CGRect containingFrame;
@property(nonatomic) NSInteger i;

-(void)cleanup;
-(void)addPhysicsOnLed;
-(void)removePhysics;
@end
