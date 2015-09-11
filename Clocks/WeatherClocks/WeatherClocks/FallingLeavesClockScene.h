//
//  FallingLeavesClockScene.h
//  WeatherClocks
//
//  Created by Eoin Norris on 15/06/2013.
//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import "ClockScene.h"
#import "PhysicsClockItemSprite.h"

#define kMaxNumberOfSprites			30
#define kMaxNumberOfLedLeaves		10
#define kMaxNumberOfFastLeaves		30
#define kMaxNumberOfLeaveTypes		2
#define kMaxNumberOfLeavesToRemove 30

#define OnLeafZPosition 2
#define FallOffLeafZPosition 1

#define kMaxNumberOfLeavesPerSecond 4





@interface FallingLeavesClockScene : ClockScene

@property(strong,atomic) NSMutableArray* fallenSpritesNormal;
@property(strong,atomic) NSMutableArray* fallenSpritesGust;

@property(strong,atomic) NSMutableArray* normalActions;
@property(strong,atomic) NSMutableArray* fastActions;

@property(strong,atomic) NSMutableArray* fallingLeafs;

@property NSTimeInterval lastLeaveTime;

@property NSTimeInterval fallingLeavesInterval;



@end
