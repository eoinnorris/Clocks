//
//  FallingLeavesClockScene.m
//  WeatherClocks
//
//  Created by Eoin Norris on 15/06/2013.
//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import "FallingLeavesClockScene.h"
#import "LedSpriteContainer.h"
#import "Led.h"
#import "PhysicsClockItemSprite.h"
#import "LeafClockItemFallingSprite.h"
#import "DateTimeLedContoller.h"
#define hiddenOffset  -10.0
#define kFallingLeavesInterval  -10.0


@implementation FallingLeavesClockScene



-(NSInteger)numberOfSprites
{
	return kMaxNumberOfSprites;
}

-(NSInteger)numberOfSpritesPerLed
{
	return kMaxNumberOfLedLeaves;
}

-(NSInteger)numberOfMovingSprites
{
	return kMaxNumberOfFastLeaves;
}

-(NSInteger)numberOfSpriteTypes
{
	return kMaxNumberOfLeaveTypes;
}

-(NSInteger)maxNumberOfSpritesToRemove
{
	return kMaxNumberOfLeavesToRemove;
}


-(CGPathRef)getPathForControlPoint:(CGPoint)cP1
                     startPosition:(CGPoint)startPosition
                       endPosition:(CGPoint)endPosition{
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, NULL, startPosition.x , startPosition.y);
    CGPathAddQuadCurveToPoint(mutablePath, NULL, cP1.x, cP1.y, endPosition.x, endPosition.y);
    CGPathAddLineToPoint(mutablePath, NULL, endPosition.x, endPosition.y);
    
    return CGPathCreateCopy(mutablePath);
}

-(void)addVideo{
    SKVideoNode* vNode = [SKVideoNode videoNodeWithVideoFileNamed:@"Beautiful Day"];
    vNode.position = CGPointMake((self.frame.size.width - vNode.size.width)/2.0,
                                 (self.frame.size.height - vNode.size.height)/2.0);
    [self addChild:vNode];
    [vNode play];
}

-(void)doSetUp{
    if (self.pastSetUp == NO){
        self.pastSetUp = YES;
        [self addLedSprites];
        [self addVideo];
    }
}
- (void)showWindSpeed{
#if DEBUGGING
    if (self.infoLabel == nil){
        
        self.infoLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.infoLabel.fontSize = 13.0;
        self.infoLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.infoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        
        CGRect frame = self.infoLabel.frame;
        self.infoLabel.position = CGPointMake(30.0, self.size.height - (frame.size.height + 20.0));
        [self addChild:self.infoLabel];
    }
    
    switch (self.storedWindType) {
        case kWindNone:
            self.infoLabel.text = @"No Wind";
            break;
            
        case kWindModerate:
            self.infoLabel.text = @"Moderate Wind";
            break;
            
        case kWindStrong:
            self.infoLabel.text = @"Strong Wind";
            break;
            
        default:
            break;
    }
    
#endif
}
// A global 2D vector specifying the field force acceleration due to gravity. The unit is meters per second so a standard earth gravity would be { 0.0, +/-9.8 }.
- (void)removeFilter{
    self.scene.shouldEnableEffects = YES;
}

- (void)updateWind:(WindType)windtype{
    switch (windtype) {
        case kWindNone:
            self.physicsWorld.gravity = CGPointMake(CCRANDOM_MINUS1_1() * 2.0, -7.0 + CCRANDOM_MINUS1_1() * 2.0) ;
            self.physicsWorld.speed = 0.8;
            break;
            
        case kWindModerate:
            self.physicsWorld.gravity = CGPointMake(11.0 + CCRANDOM_MINUS1_1() * 2.0,-11.0 + CCRANDOM_MINUS1_1() * 2.0);
            self.physicsWorld.speed = 1.0;
            break;
            
        case kWindStrong:{
            self.physicsWorld.gravity = CGPointMake(15.0 + CCRANDOM_MINUS1_1() * 2.0, -2.0 + CCRANDOM_MINUS1_1() * 2.0);
            self.physicsWorld.speed = 1.5 + CCRANDOM_MINUS1_1() * 1.0;
        }
            break;
            
        default:
            break;
    }
    
    // to do  - fix
//    self.scene.shouldEnableEffects = (windtype > kWindModerate);
    [self performSelector:@selector(removeFilter) withObject:nil afterDelay:0.1];
    
    self.storedWindType = windtype;
    
    [self showWindSpeed];
}


-(SKColor*)dateFontColor
{
	//return ccc3(0xf1, 0xC8, 0x27);
    return [SKColor colorWithDeviceRed:104.0/255.0 green:140.0/255.0  blue:40.0/255.0  alpha:1.0];
}

-(SKColor*)secondsFontColor
{
    return [self dateFontColor];
}

-(NSInteger)distanceFromBottomForDate
{
	return [self distanceFromBottomForSeconds] - 50.0;
}

-(NSInteger)distanceFromLeftForDate
{
	return (( self.frame.size.width / 2.0) - 5.0); // FIX ME!
}

-(NSInteger)distanceFromBottomForSeconds
{
	return (self.frame.size.height * ( 1/ 3.0)) + [self secondsFontSize] - 20.0;
}

-(NSInteger)distanceFromLeftForSeconds
{
	return (self.frame.size.width / 2.0);
}



- (void)updateWindRandomly{
    NSInteger value = lroundf(CCRANDOM_0_1() * 2.0);
    WindType type = (WindType)value;
    [self updateWind:type];
}

- (void)updateWindBasedOnTimeOrRandomy{
    NSInteger seconds = [self getSecondsPastMinuteValue];
    // from  seconds to minute change, until 2 seconds past minute change, wind is moderate or fast
    
    if ((seconds > 55) || (seconds <= 2)) {
            [self updateWind:kWindStrong];
    }
    // from 2 secons to 10 seconds past minute wind is always non existant.
    else if ((seconds > 2) && (seconds <= 5)) {
            [self updateWind:kWindNone];
    } else {
        [self updateWindRandomly];
    }
    
    return ;
}



-(CGPoint)getStartPointBasedWind:(WindType)wind{
    CGFloat xRange = self.frame.size.width , yRange = self.frame.size.height;
    CGFloat x = 0.0,y = 0.0;
    switch (wind) {
        case kWindNone:
            x = CCRANDOM_0_1() * xRange;
            y = yRange + (CCRANDOM_0_1() * (yRange / 5.0));
            break;
            
        case kWindModerate:
            x = CCRANDOM_0_1() * ( xRange * 2/3);
            y = yRange + (CCRANDOM_0_1() * (yRange / 10.0));
            break;
            
        case kWindStrong:
            x = CCRANDOM_0_1() * ( xRange * 2/3) - (xRange / 3);
            y = yRange - (CCRANDOM_0_1() * (yRange * 2/3));
            break;
            
        default:
            break;
    }
    
    return CGPointMake(x, y);
}

-(void)setPhyicsInteractionBasedOnLeafPosition:(SpritesZPosition)position
                                          leaf:(PhysicsClockItemSprite*)leaf{
    return;
}




-(void)addRandomLeaves{
    
    NSInteger numberOfLeaves = lroundf(CCRANDOM_0_1() * kMaxNumberOfLeavesPerSecond);
    
    numberOfLeaves += (self.storedWindType);
    
    for (int i =0; i< numberOfLeaves; i++) {
        
        SpritesZPosition positon = (CCRANDOM_0_1() * kFarFrontClock);
        
        CGPoint location = [self getStartPointBasedWind:self.storedWindType];
        CGFloat sizef = 20.0; // kLeafSize
        CGRect frame = CGRectMake(location.x, location.y, sizef, sizef);
        
        PhysicsClockItemSprite *leaf = [self getRandomSpriteType:frame];
        leaf.position = location;
        leaf.scale = [self getScaleBaseOnLeafPosition:positon];
        leaf.alpha = [self getAlphaBasedOnLeafPosition:positon];
        
        
        leaf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sizef, sizef)];
        leaf.physicsBody.affectedByGravity = YES;
        
        leaf.physicsBody.categoryBitMask = leafCategoryFallingOn;
        leaf.physicsBody.collisionBitMask = 0;
        leaf.physicsBody.mass = 1.0; // make sure it doesnt break the leafs for now.
        leaf.physicsBody.restitution = 0.5;
        
        SKAction* targetAction = [SKAction performSelector:@selector(cleanup) onTarget:leaf];
        SKAction* delayAction = [SKAction waitForDuration:2.0];

        SKAction* sequence = [SKAction sequence:@[delayAction,targetAction]];

        if ([leaf hasActions] == YES)
            [leaf removeAllActions];

        [leaf runAction:sequence];
        
        [self addChild:leaf];
    }

}

- (void)reAddRemovedLeaf:(id)node{
    if ([node isKindOfClass:[LeafClockItemFallingSprite class]]){
        LeafClockItemFallingSprite* leaf = (LeafClockItemFallingSprite*)node;
        if (CGPointEqualToPoint(leaf.position, leaf.leafStoredPosition) == NO){
            if (CGRectContainsPoint(leaf.containingFrame, leaf.leafStoredPosition)) {
                CGFloat xPos = leaf.leafStoredPosition.x;
                CGFloat yPos = leaf.leafStoredPosition.y;
                
                CGPoint endPosition = ccp(xPos, yPos);
                CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
                
                leaf.position = startPosition;
                leaf.scale = 1.0;
                
                
                CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
                CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
                
                
                
                CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                                 startPosition:startPosition
                                                   endPosition:endPosition];
                
                SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
                SKAction *delayedAction = [SKAction waitForDuration:2.0 withRange:(NSTimeInterval)1.9];
                SKAction* targetAction = [SKAction performSelector:@selector(addPhysicsOnLed) onTarget:leaf];
                
                SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction,targetAction]];
                
                if ([leaf parent] == nil)
                    [self addChild:leaf];
                
                if ([leaf hasActions] == YES)
                    [leaf removeAllActions];
                
                [leaf runAction:sequence];
            }
        }
    }
}

- (BOOL)removeLeavesOnMouseDown{
    BOOL didRemove = NO;
    NSArray* nodes = [self nodesAtPoint:self.location];
    
    if  (nodes.count){
        for (SKNode *node in nodes) {
            if ([node isKindOfClass:[LeafClockItemFallingSprite class]]){
                LeafClockItemFallingSprite* leaf = (LeafClockItemFallingSprite*)node;
                leaf.leafStoredPosition = leaf.position;
                [self removeLeafImmediately:(PhysicsClockItemSprite*)node];
                [self performSelector:@selector(reAddRemovedLeaf:) withObject:node afterDelay:1.1];
                didRemove = YES;
            }
        }
    }
    return didRemove;
}

-(void)addSpriteToThisLed:(id)object
{
    PhysicsClockItemSprite* leaf = (PhysicsClockItemSprite*)object;
    
    if (leaf.parent == nil)
        [self addChild:leaf];
    
    CGFloat xPos = leaf.position.x;
    CGFloat yPos = leaf.position.y;
    
    CGPoint endPosition = ccp(xPos, yPos);
    CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
    
    leaf.position = startPosition;
    
    CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
    CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
    CGFloat wait = 0.5f  + (CCRANDOM_0_1() * 0.3f);
    CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                     startPosition:startPosition
                                       endPosition:endPosition];
    
    SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
    SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
    SKAction* targetAction = [SKAction performSelector:@selector(addPhysicsOnLed) onTarget:leaf];
    
    SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction,targetAction]];
    
    if ([leaf hasActions] == YES)
        [leaf removeAllActions];
    
   

    [leaf runAction:sequence];
	
}



- (void)addleavesOnMouseDown{
    
    if (self.isMouseDown){
        
        if ([self removeLeavesOnMouseDown] == YES)
            return;
            
        CGPoint location = self.location;
        CGFloat sizef = 20.0;
        CGRect frame = CGRectMake(location.x, location.y, sizef, sizef);
        
        LeafClockItemFallingSprite *leaf = [self getRandomFallingSpriteType:frame];
        
        leaf.position = location;
        leaf.scale = 1.1 +  CCRANDOM_MINUS1_1() * 1.0;
        leaf.zPosition = 20 +  CCRANDOM_0_1();
        
        leaf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sizef, sizef)];
        leaf.physicsBody.affectedByGravity = YES;
        
        leaf.physicsBody.categoryBitMask = leafCategoryFallingOn;
        leaf.physicsBody.collisionBitMask = leafCategoryOnLed;
        leaf.physicsBody.mass = 1.0; 
        leaf.physicsBody.restitution = 0.5;
        
        [self addChild:leaf];
    }
}

- (void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];
    [self doSetUp];
    
    if ((currentTime - self.lastLeaveTime) >= 0.1){
        [self addRandomLeaves];
        self.lastLeaveTime = currentTime;
    }
    
    if ((currentTime - self.lastTime) >= 1.0){
        [self updateWindBasedOnTimeOrRandomy];
        self.lastTime = currentTime;
    }
    
    [self addleavesOnMouseDown];

}

-(NSString*)spritesFormatedName{
	return @"leaf_%D.png";
}

- (void)removeLeafImmediately:(PhysicsClockItemSprite *)leaf{
    if (leaf.physicsBody == nil)
        leaf.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:leaf.frame.size.width];
    
    leaf.physicsBody.affectedByGravity = YES;
    leaf.physicsBody.dynamic = YES;
    [leaf performSelector:@selector(cleanup) withObject:nil afterDelay:1.0];
}


- (void)removeLeaf:(PhysicsClockItemSprite *)leaf
{
    double delayInSeconds = CCRANDOM_0_1() * 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (leaf.physicsBody == nil)
            leaf.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:leaf.frame.size.width];
        
        leaf.physicsBody.affectedByGravity = YES;
        leaf.physicsBody.dynamic = YES;
        [leaf performSelector:@selector(cleanup) withObject:nil afterDelay:1.0];
    });
  
}


-(void)removeSprites:(LedSpriteContainer*)container
{
	NSArray* cSprites = container.sprites;
	NSInteger i,count = [cSprites count];
	
	for (i=0; i< count; i++)
	{
		PhysicsClockItemSprite* leaf = [cSprites objectAtIndex:i];
        [self removeLeaf:leaf];
	}
}

#define LED_LEAVES_HAVE_PHYSICS 1

-(void)addSpritesToThisLed:(id)object
{
	LedSpriteContainer* container = (LedSpriteContainer*)object;
	
	NSMutableArray* cSprites = [container.sprites mutableCopy];
    if (cSprites == nil)
        cSprites = [NSMutableArray array];
    
	NSInteger i,count = [cSprites count];
    
    if (count < kMaxNumberOfLedLeaves){
        LeafClockItemFallingSprite* leaf = [self getRandomFallingSpriteType:container.containingLed.frame];
        for (NSInteger i =count ; i < kMaxNumberOfLedLeaves; i++) {
            [cSprites addObject:leaf];
        }
    }
    
    count = [cSprites count];
    
	if (cSprites.count > 0){
		for (i=0; i< count; i++){
			PhysicsClockItemSprite* leaf = [cSprites objectAtIndex:i];
			CGRect frame = container.containingLed.frame;
			SKAction* moveOnAction = [self getMoveToAction:frame forPosition:i maximum:count andSprite:leaf];
            
           
            
			if ([leaf parent] != self)
				[self addChild:leaf];
			
			if ([leaf hasActions] == YES){
                [leaf removeAllActions];
            }
            [leaf runAction:moveOnAction];
		}
	} 
}


- (void)addOrChangeVerticalLeds
{
	BOOL firstTime = NO;
	
	
	if (self.verticalLeds == NULL)
	{
		self.verticalLeds = [NSMutableArray arrayWithCapacity:kMaxNumberOfVerticalLeds];
		firstTime = YES;
	}
	
	for (int j = 0; j < kNumberOfDigits; j++)
	{
		CGFloat xPosRow = j* ( kLEDDistance +  kMaxHorizontalLedWidth);
		
		NSMutableArray* subarray = firstTime ? NULL :  [self.verticalLeds objectAtIndex:j] ;
		
		if (subarray == NULL)
		{
			subarray = [NSMutableArray arrayWithCapacity:kVerticalLedCount];
		}
		
		for (int i=0; i<kVerticalLedCount; i++)
		{
			Led* led = (firstTime) ? NULL : [subarray objectAtIndex:i];
			
			if (led == NULL)
			{
				led = [[Led alloc] init];
				
				CGFloat xPos = (i < 2)  ?  xPosRow + [self positionFromLeft]:
                kMaxHorizontalLedWidth - kMaxVerticalLedWidth + xPosRow + [self positionFromLeft];
				
				CGFloat yPos = (i%2) ? [self distanceFromBottom] :
                [self distanceFromBottom] + kMaxVerticalLedHeight + kMaxHorizontalLedHeight;
				CGRect frame = CGRectMake(xPos, yPos , kMaxVerticalLedWidth, kMaxVerticalLedHeight + (kMaxHorizontalLedHeight * 2.0) );
				
				CGPoint vertices[] = { ccp(xPos,yPos ), ccp(xPos,yPos+kMaxVerticalLedHeight + kMaxHorizontalLedHeight * 2.0),
					ccp(xPos+kMaxVerticalLedWidth,yPos+kMaxVerticalLedHeight + kMaxHorizontalLedHeight * 2),
					ccp(xPos+kMaxVerticalLedWidth,yPos ) };
				
				
				led.vertices = vertices;
				led.frame = frame;
				led.description = [NSString stringWithFormat:@"%@%@",[self.digitNames objectAtIndex:j],
                                   [self.verticalNames objectAtIndex:i]];
				[subarray addObject:led];
			}
			
			
			bool isOnNow =  [[DateTimeLedContoller sharedInstance] showVerticalLedBasedOnTimeType:(WeatherClockTimeType)j
																					  ledPosition:(WeatherClockVerticalLedPosition)i];
			
			if ((led.isON == YES) & (isOnNow == NO))
				led.wasON = YES;
			else
				led.wasON = NO;
			
			
			if ((isOnNow == YES) && (led.isON == NO))
				led.wasOFF = YES;
			else
				led.wasOFF = NO;
			
			led.isON = isOnNow; // store the values;
			
			
			if (led.wasON == YES)
			{
				LedSpriteContainer* ledContainer = [self.allLedsDictionary objectForKey:led.description];
				[self removeSprites:ledContainer];
			}
			else if (led.wasOFF == YES)
			{
				LedSpriteContainer* ledContainer = [self.allLedsDictionary objectForKey:led.description];
				[self performSelector:@selector(addSpritesToThisLed:) withObject:ledContainer afterDelay:1.0];
			}
			
		}
		[self.verticalLeds addObject:subarray];
	}
	
}



- (void)addOrChangeHoriztonalLeds
{
	BOOL firstTime = NO;
	
	self.needsToAddSpritesFirstTime = ([self.allLedsDictionary count] == 0);
	
	if (self.horizontalLeds == NULL)
	{
		firstTime = YES;
		self.horizontalLeds = [NSMutableArray arrayWithCapacity:kMaxNumberOfHorizontalLeds];
	}
	
	for (int j=0; j<kNumberOfDigits; j++)
	{
		NSMutableArray* subarray = (firstTime) ? NULL : [self.horizontalLeds objectAtIndex:j];
		
		if (subarray == NULL)
		{
			subarray = [NSMutableArray arrayWithCapacity:kHorizontalLedCount];
		}
		
		
		for (int i=0; i<kHorizontalLedCount; i++)
		{
			
			Led* led = (firstTime) ? NULL : [subarray objectAtIndex:i];
			if (led == NULL)
			{
				led = [[Led alloc] init];
				
				CGFloat xPos = [self positionFromLeft] + j* ( kLEDDistance +  kMaxHorizontalLedWidth);
				CGFloat yPos = ([self distanceFromBottom]) + ((kMaxVerticalLedHeight + kMaxHorizontalLedHeight)* i);
				
				if (i == 0) yPos-= kMaxHorizontalLedHeight;
				
				CGPoint vertices[] = { ccp(xPos,yPos), ccp(xPos,yPos+kMaxHorizontalLedHeight),
					ccp(xPos+kMaxHorizontalLedWidth,yPos+kMaxHorizontalLedHeight), ccp(xPos+kMaxHorizontalLedWidth,yPos) };
				CGRect frame = CGRectMake(xPos, yPos, kMaxHorizontalLedWidth, kMaxHorizontalLedHeight);
				
				led.vertices = vertices;
				led.frame = frame;
				led.description = [NSString stringWithFormat:@"%@%@",[self.digitNames objectAtIndex:j],
                                   [self.horizontalNames objectAtIndex:i]];
				[subarray addObject:led];
			}
			
			bool isOnNow =  [[DateTimeLedContoller sharedInstance] showHoriztonalLedBasedOnTimeType:(WeatherClockTimeType)j
																						ledPosition:(WeatherClockHorizontalLedPosition)i];
			
			if ((led.isON == YES) & (isOnNow == NO))
				led.wasON = YES;
			else
				led.wasON = NO;
			
			
			if ((isOnNow == YES) && (led.isON == NO))
				led.wasOFF = YES;
			else
				led.wasOFF = NO;
			
			led.isON = isOnNow; // store the values;
			
			if (led.wasON == YES)
			{
				LedSpriteContainer* ledContainer = [self.allLedsDictionary objectForKey:led.description];
				[self removeSprites:ledContainer];
			}
			else if (led.wasOFF == YES)
			{
				LedSpriteContainer* ledContainer = [self.allLedsDictionary objectForKey:led.description];
				[self performSelector:@selector(addSpritesToThisLed:) withObject:ledContainer afterDelay:1.0];
			}
			
			
		}
		[self.horizontalLeds addObject:subarray];
	}
	
}


-(LeafClockItemFallingSprite*)getRandomFallingSpriteType:(CGRect)frame

{
	NSInteger numberOfSpriteTypes = [self numberOfSpriteTypes];
	NSInteger leafvalue =	(NSInteger)(floor(CCRANDOM_0_1() * numberOfSpriteTypes));
	
	NSString* leafStrImageName = [NSString stringWithFormat:[self spritesFormatedName],leafvalue];
    
    if (CCRANDOM_0_1() > 0.5)
        leafStrImageName = @"leaf_02.png";
    else
        leafStrImageName = @"leaf_00.png";
    
	SKTexture* leafTexture = [SKTexture textureWithImageNamed:leafStrImageName];
    
	LeafClockItemFallingSprite *leaf = [LeafClockItemFallingSprite spriteNodeWithTexture:leafTexture];
    
    CGFloat sizeDelta = CCRANDOM_MINUS1_1() * 10.0;
    leaf.size = CGSizeMake(20.0 + sizeDelta, 20.0 + sizeDelta);
    
	return [leaf copy];
}

- (CIFilter*)flashFilter{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIExposureAdjust"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:7] forKey:@"inputEV"];
    
    return bumpDistortion;
}

- (CIFilter*)blurFilter{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIDiscBlur"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputRadius"];
    
    return bumpDistortion;
}


-(PhysicsClockItemSprite*)getRandomSpriteType:(CGRect)frame{
	NSInteger numberOfSpriteTypes = [self numberOfSpriteTypes];
	NSInteger leafvalue =	(NSInteger)(floor(CCRANDOM_0_1() * numberOfSpriteTypes));
	
	NSString* leafStrImageName = [NSString stringWithFormat:[self spritesFormatedName],leafvalue];
    
    if (CCRANDOM_0_1() > 0.5)
        leafStrImageName = @"leaf_02.png";
    else
        leafStrImageName = @"leaf_00.png";

	SKTexture* leafTexture = [SKTexture textureWithImageNamed:leafStrImageName];
   //leafTexture = [leafTexture textureByApplyingCIFilter:[self blurFilter]];

	PhysicsClockItemSprite *leaf = [PhysicsClockItemSprite spriteNodeWithTexture:leafTexture];
    CGFloat sizeDelta = CCRANDOM_MINUS1_1() * 10.0;
    leaf.size = CGSizeMake(20.0 + sizeDelta, 20.0 + sizeDelta);
    
#if LED_LEAVES_HAVE_PHYSICS
    SKAction *delayedAction = [SKAction waitForDuration:2.0];
    SKAction* targetAction = [SKAction performSelector:@selector(addPhysicsOnLed) onTarget:leaf];
    SKAction* sequence = [SKAction sequence:@[delayedAction,targetAction]];
    if (leaf.hasActions == YES)
        [leaf removeAllActions];

    [leaf runAction:sequence];
#endif

	return leaf;
}

-(SKAction*)getMoveToAction:(CGRect)frame forPosition:(NSInteger)leafNumber
                    maximum:(NSInteger)maximum
                  andSprite:(PhysicsClockItemSprite*)leaf
{
	BOOL isVertical = frame.size.width < frame.size.height;
	
	CGFloat yPos = frame.origin.y + (isVertical ? ((CGFloat)leafNumber / (CGFloat)maximum) * frame.size.height : (frame.size.height / 2.0));
	CGFloat xPos  = frame.origin.x +  ((isVertical == NO) ? ((CGFloat)leafNumber / (CGFloat)maximum) * frame.size.width : (frame.size.width / 2.0));
    
    CGPoint endPosition = ccp(xPos, yPos);
    CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
    
    leaf.position = startPosition;
    
    
    CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
    CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
    CGFloat wait = 0.5f  + (CCRANDOM_0_1() * 0.3f);

    

    CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                     startPosition:startPosition
                                       endPosition:endPosition];
    
    SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
    SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
    SKAction* targetAction = [SKAction performSelector:@selector(addPhysicsOnLed) onTarget:leaf];

    SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction,targetAction]];
    
	return sequence;
	
}



-(void)setAllLedsToWasOff{
    
    for (NSArray* ledArray in self.horizontalLeds) {
        for (Led* led in ledArray) {
            led.wasOFF = YES;
        }
    }
    
    for (NSArray* ledArray in self.verticalLeds) {
        for (Led* led in ledArray) {
            led.wasOFF = YES;
        }
    }
}

-(void)addLedSprites
{
    
	NSInteger i;
	
	if (self.allLedsDictionary == NULL)
		self.allLedsDictionary = [NSMutableDictionary dictionaryWithCapacity:26];
	
	NSInteger numberOfSpritesPerLed = [self numberOfSpritesPerLed];
    
    // TODO - refactor
    
	for (NSArray* subarray in self.horizontalLeds)
	{
		
		NSInteger count = [subarray count];
		NSInteger position;
		
		for (position=0; position<count; position++)
		{
			Led* led = [subarray objectAtIndex:position];
			
			NSString* description = led.description;
			LedSpriteContainer* ledContainer = [[LedSpriteContainer alloc] init];
			
			ledContainer.containingLed = led;
			NSMutableArray* lSprites = [NSMutableArray arrayWithCapacity:numberOfSpritesPerLed];
			NSMutableArray* moveToActions = [NSMutableArray arrayWithCapacity:numberOfSpritesPerLed];
						
			
			for (i=0; i<numberOfSpritesPerLed; i++)
			{
				LeafClockItemFallingSprite* leaf = [self getRandomFallingSpriteType:led.frame];
				leaf.containingFrame = led.frame;
                
                BOOL isVertical = led.frame.size.width < led.frame.size.height;
                
                CGFloat yPos = led.frame.origin.y + (isVertical ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.height : (led.frame.size.height / 2.0));
                CGFloat xPos  = led.frame.origin.x +  ((isVertical == NO) ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.width : (led.frame.size.width / 2.0));
                
                yPos =  yPos + CCRANDOM_MINUS1_1()  * (led.frame.size.height / 2.0);
                xPos = xPos + CCRANDOM_0_1()  *  5.0;
                
                
                CGPoint endPosition = ccp(xPos, yPos);
                CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
                
                leaf.position = startPosition;


                CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
                CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
                CGFloat wait = 0.5f  + (CCRANDOM_0_1() * 1.0f);

                
                CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                                 startPosition:startPosition
                                                   endPosition:endPosition];
                
                SKAction *action = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
                SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
                SKAction *sequence = [SKAction sequence:@[delayedAction,action,]];
                
								
				[lSprites addObject:leaf];
				if (sequence)
					[moveToActions addObject:sequence];
		
				
				if (led.isON)
				{
					
					// subclasses to override
					[self addChild:leaf];
					if (action)
						[leaf runAction:action];
                    
                    [self drawLed:led];

				}
				else {
					leaf.position = CGPointMake(leaf.position.x, 600);
				}
				
			}
			ledContainer.sprites = lSprites;
            ledContainer.moveToActions = moveToActions;
			
			[self.allLedsDictionary setObject:ledContainer forKey:description];
		}
	}
	
	for (NSArray* subarray in self.verticalLeds)
	{
		NSInteger count = [subarray count];
		NSInteger position;
		
		for (position=0; position<count; position++)
		{
			Led* led = [subarray objectAtIndex:position];
			NSString* description = led.description;
			LedSpriteContainer* ledContainer = [[LedSpriteContainer alloc] init];
			
			ledContainer.containingLed = led;
            

			
			NSMutableArray* lSprites = [NSMutableArray arrayWithCapacity:numberOfSpritesPerLed];
			NSMutableArray* moveToActions = [NSMutableArray arrayWithCapacity:numberOfSpritesPerLed];
			
			for (i=0; i<numberOfSpritesPerLed; i++)
			{
				LeafClockItemFallingSprite* leaf = [self getRandomFallingSpriteType:led.frame];
                leaf.containingFrame = led.frame;

                BOOL isVertical = led.frame.size.width < led.frame.size.height;

                
                CGFloat yPos = led.frame.origin.y + (isVertical ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.height : (led.frame.size.height / 2.0));
                CGFloat xPos  = led.frame.origin.x +  ((isVertical == NO) ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.width : (led.frame.size.width / 2.0));
                
                yPos =  yPos + CCRANDOM_MINUS1_1()  * 5.0;
                xPos = xPos + CCRANDOM_0_1()  * (led.frame.size.width / 2.0);
                
                
                CGPoint endPosition = ccp(xPos, yPos);
                CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
                
                leaf.position = startPosition;
                
                
                CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
                CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
                CGFloat wait = 0.5f  + (CCRANDOM_0_1() * 1.0f);
                
                
                CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                                 startPosition:startPosition
                                                   endPosition:endPosition];
                
                SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:YES duration:duration];
                SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
                SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction]];
                
				[lSprites addObject:leaf];
				
				if (led.isON)
				{
					[self addChild:leaf];
					if (sequence)
						[leaf runAction:sequence];
					
                    [self drawLed:led];
				}
				else {
					leaf.position = CGPointMake(leaf.position.x, 600);
				}
				
			}
			
			ledContainer.sprites = lSprites;
			ledContainer.moveToActions = moveToActions;
			
			
			[self.allLedsDictionary setObject:ledContainer forKey:description];
		}
	}
}




-(void)addActions
{
	NSInteger i;
	
	if (self.normalActions  == NULL)
		self.normalActions = [NSMutableArray arrayWithCapacity:kMaximumNumberOfNormalActions];
	
	if (self.fastActions == NULL)
		self.fastActions = [NSMutableArray arrayWithCapacity:kMaximumNumberOfFastActions];
	
	
	for (i=0; i<kMaximumNumberOfNormalActions; i++)
	{
        CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 2.5f);
        CGPoint endPosition = ccp(i * 5.0, -415);
        CGPoint startPosition = ccp(endPosition.x,hiddenOffset);
        CGPoint controlPoint_1 = ccp( i * 5.0 - (25.0 + (CCRANDOM_0_1() * 150.0)), -250);
        CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                         startPosition:startPosition
                                           endPosition:endPosition];
        
        SKAction* slowAction = [SKAction followPath:path asOffset:YES orientToPath:YES duration:duration];
        
		[self.normalActions addObject:slowAction];
	}
	
	for (i=0; i<kMaximumNumberOfFastActions; i++)
	{
        CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f );
        CGPoint endPosition = ccp(i * 5.0, -415);
        CGPoint startPosition = ccp(endPosition.x,hiddenOffset);

        CGPoint controlPoint_1 = ccp( i * 5.0 - (25.0 + (CCRANDOM_0_1() * 150.0)), -250);
        CGPathRef path = [self getPathForControlPoint:controlPoint_1
                                        startPosition:startPosition
                                          endPosition:endPosition];
        
        SKAction* fastAction = [SKAction followPath:path asOffset:YES orientToPath:YES duration:duration];

    
		[self.fastActions addObject:fastAction];
	}
}



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self addActions];
    }
    return self;
}


@end
