//
//  Leaf.m
//  LeafClock
//
//  Created by Eoin norris on 29/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhysicsClockItemSprite.h"


@implementation PhysicsClockItemSprite

-(void)cleanup{
    [self removePhysics];
    if (self.parent != nil)
        [self removeFromParent];
}

-(void)addPhysicsOnLed{
    if (self.physicsBody == nil)
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width / 2.0];
    
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    
    self.physicsBody.categoryBitMask = leafCategoryOnLed;
    self.physicsBody.collisionBitMask = leafCategoryFallingOn;
}

-(void)removePhysics{

    self.physicsBody = nil;
    if (self.parent != nil)
        [self removeFromParent];
    
}

@end
