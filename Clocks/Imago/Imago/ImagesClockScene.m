//
//  ImagesClockScene.m
//  
//
//  Created by Eoin Norris on 02/03/2014.
//
//

#import "ImagesClockScene.h"
#import "Led.h"
#import "LedSpriteContainer.h"
#import "PhysicsClockItemSprite.h"
#import "OUSTwitterAccountManager.h"
#import "OUSTwitterObject.h"
#import "OUSViewController.h"


@implementation ImagesClockScene

// Alternatively the subclasses can subclass addOrChange...Leds to not use these
- (void)horizontalLed:(Led*)led
                frame:(CGRect)frame
                 isOn:(BOOL)isOnNow
                wasOn:(BOOL)wasOn
{
}

- (void)verticalLed:(Led*)led
              frame:(CGRect)frame
               isOn:(BOOL)isOnNow
              wasOn:(BOOL)wasOn
{
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
    
    SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:NO duration:duration];
    SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
    SKAction* targetAction = [SKAction performSelector:@selector(addPhysicsOnLed) onTarget:leaf];
    
    SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction,targetAction]];
    
	return sequence;
	
}


-(void)addSpritesToThisLed:(id)object
{
    NSAssert(YES, @"Subclasses to override addSpritesToThisLed:");
	LedSpriteContainer* container = (LedSpriteContainer*)object;
	
	NSMutableArray* cSprites = [container.sprites mutableCopy];
    if (cSprites == nil)
        cSprites = [NSMutableArray array];
    
	NSInteger i,count = [cSprites count];
    
    if (count < kMaxNumberOfLedSprites){
        PhysicsClockItemSprite* sprite = [self getRandomImageSprite:container.containingLed.frame
                                                               ofType:0];
        for (NSInteger i =count ; i < kMaxNumberOfLedSprites; i++) {
            [cSprites addObject:sprite];
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

-(PhysicsClockItemSprite*)getImageInRect:(CGRect)frame
                           forIdentifier:(NSString*)identifier
{
    CGImageRef imageRef =  [[OUSTwitterAccountManager sharedInstance] getRandomTwitterThumbsFromStore];
    SKTexture* leafTexture = [SKTexture textureWithCGImage:imageRef];
    
	PhysicsClockItemSprite *leaf = [PhysicsClockItemSprite spriteNodeWithTexture:leafTexture];
    
    CGFloat sizeDelta = CCRANDOM_MINUS1_1() * kSpriteMaximumDelta;
    leaf.size = CGSizeMake(kSpriteNormalSize + sizeDelta, kSpriteNormalSize + sizeDelta);
    
	return leaf;
}


-(PhysicsClockItemSprite*)getRandomImageSprite:(CGRect)frame
                                        ofType:(NSInteger)type{
    CGImageRef imageRef =  [[OUSTwitterAccountManager sharedInstance] getRandomTwitterThumbsFromStore];
    
    SKTexture* texture = [SKTexture textureWithCGImage:imageRef];
    
	PhysicsClockItemSprite *sprite = [PhysicsClockItemSprite spriteNodeWithTexture:texture];
    
    CGFloat sizeDelta = CCRANDOM_MINUS1_1() * kSpriteMaximumDelta;
    sprite.size = CGSizeMake(kSpriteNormalSize + sizeDelta, kSpriteNormalSize + sizeDelta);
    
	return sprite;
}

-(PhysicsClockItemSprite*)getSpriteForTexture:(SKTexture*)texture{

	PhysicsClockItemSprite *sprite = [PhysicsClockItemSprite spriteNodeWithTexture:texture];
    
    CGFloat sizeDelta = CCRANDOM_MINUS1_1() * kSpriteMaximumDelta;
    sprite.size = CGSizeMake(kSpriteNormalSize + sizeDelta, kSpriteNormalSize + sizeDelta);
    
	return sprite;
}

-(CGPoint)randomStartPoint{
    CGFloat xRange = self.frame.size.width , yRange = self.frame.size.height;
    CGFloat x = CCRANDOM_0_1() * xRange;
    CGFloat y = yRange + (CCRANDOM_0_1() * (yRange / 5.0));
        
    
    return CGPointMake(x, y);
}

-(void)addFallingChosenItemSprites:(SKTexture *)texture{
    
    NSInteger numberOfLeaves = lroundf(CCRANDOM_0_1() * kMaxNumberOfSpritesPerSecond);
    
    numberOfLeaves += (self.storedWindType);
    
    for (int i =0; i< numberOfLeaves; i++) {
        
        SpritesZPosition positon = (CCRANDOM_0_1() * kFarFrontClock *-1);
        
        CGPoint location = [self randomStartPoint];
        CGFloat sizef = 20.0; // kLeafSize
//        CGRect frame = CGRectMake(location.x, location.y, sizef, sizef);
        
        PhysicsClockItemSprite *sprite = [self getSpriteForTexture:texture];
        
        sprite.position = location;
        sprite.scale = [self getScaleBaseOnLeafPosition:positon];
        sprite.alpha = [self getAlphaBasedOnLeafPosition:positon];
        
        
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sizef, sizef)];
        sprite.physicsBody.affectedByGravity = YES;
        
        sprite.physicsBody.categoryBitMask = leafCategoryFallingOn;
        sprite.physicsBody.collisionBitMask = 0;
        sprite.physicsBody.mass = 1.0; // make sure it doesnt break the leafs for now.
        sprite.physicsBody.restitution = 0.5;
        
        SKAction* targetAction = [SKAction performSelector:@selector(cleanup) onTarget:sprite];
        SKAction* delayAction = [SKAction waitForDuration:2.0];
        
        SKAction* sequence = [SKAction sequence:@[delayAction,targetAction]];
        
        if ([sprite hasActions] == YES)
            [sprite removeAllActions];
        
        [sprite runAction:sequence];
        
        [self addChild:sprite];
    }
    
}



-(void)addRandomSprites{
    
    NSInteger numberOfLeaves = lroundf(CCRANDOM_0_1() * kMaxNumberOfSpritesPerSecond);
    
    numberOfLeaves += (self.storedWindType);
    
    for (int i =0; i< numberOfLeaves; i++) {
        
        SpritesZPosition positon = (CCRANDOM_0_1() * kFarFrontClock *-1);
        
        CGPoint location = [self randomStartPoint];
        CGFloat sizef = 20.0; // kLeafSize
        CGRect frame = CGRectMake(location.x, location.y, sizef, sizef);
        
        PhysicsClockItemSprite *sprite = [self getRandomImageSprite:frame
                                                           ofType:0];
        sprite.position = location;
        sprite.scale = [self getScaleBaseOnLeafPosition:positon];
        sprite.alpha = [self getAlphaBasedOnLeafPosition:positon];
        
        
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sizef, sizef)];
        sprite.physicsBody.affectedByGravity = YES;
        
        sprite.physicsBody.categoryBitMask = leafCategoryFallingOn;
        sprite.physicsBody.collisionBitMask = 0;
        sprite.physicsBody.mass = 1.0; // make sure it doesnt break the leafs for now.
        sprite.physicsBody.restitution = 0.5;
        
        SKAction* targetAction = [SKAction performSelector:@selector(cleanup) onTarget:sprite];
        SKAction* delayAction = [SKAction waitForDuration:2.0];
        
        SKAction* sequence = [SKAction sequence:@[delayAction,targetAction]];
        
        if ([sprite hasActions] == YES)
            [sprite removeAllActions];
        
        [sprite runAction:sequence];
        
        [self addChild:sprite];
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
				PhysicsClockItemSprite* sprite = [self getRandomImageSprite:led.frame
                                                                     ofType:0];
				sprite.containingFrame = led.frame;
                
                BOOL isVertical = led.frame.size.width < led.frame.size.height;
                
                CGFloat yPos = led.frame.origin.y + (isVertical ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.height : (led.frame.size.height / 2.0));
                CGFloat xPos  = led.frame.origin.x +  ((isVertical == NO) ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.width : (led.frame.size.width / 2.0));
                
                yPos =  yPos + CCRANDOM_MINUS1_1()  * (led.frame.size.height / 2.0);
                xPos = xPos + CCRANDOM_0_1()  *  5.0;
                
                
                CGPoint endPosition = ccp(xPos, yPos);
                CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
                
                sprite.position = startPosition;
                
                
                CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
                CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
                CGFloat wait = 0.5f  + (CCRANDOM_0_1() * 1.0f);
                
                
                CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                                 startPosition:startPosition
                                                   endPosition:endPosition];
                
                SKAction *action = [SKAction followPath:path asOffset:NO orientToPath:NO duration:duration];
                SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
                SKAction *sequence = [SKAction sequence:@[delayedAction,action,]];
                
                
				[lSprites addObject:sprite];
				if (sequence)
					[moveToActions addObject:sequence];
                
				
				if (led.isON)
				{
					
					// subclasses to override
					[self addChild:sprite];
					if (action)
						[sprite runAction:action];
                    
                    [self drawLed:led];
                    
				}
				else {
					sprite.position = CGPointMake(sprite.position.x, 600);
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
				PhysicsClockItemSprite* sprite = [self getRandomImageSprite:led.frame
                                                                     ofType:0];
                sprite.containingFrame = led.frame;
                
                
                
                BOOL isVertical = led.frame.size.width < led.frame.size.height;
                
                
                CGFloat yPos = led.frame.origin.y + (isVertical ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.height : (led.frame.size.height / 2.0));
                CGFloat xPos  = led.frame.origin.x +  ((isVertical == NO) ? ((CGFloat)i / (CGFloat)numberOfSpritesPerLed) * led.frame.size.width : (led.frame.size.width / 2.0));
                
                yPos =  yPos + CCRANDOM_MINUS1_1()  * 5.0;
                xPos = xPos + CCRANDOM_0_1()  * (led.frame.size.width / 2.0);
                
                
                CGPoint endPosition = ccp(xPos, yPos);
                CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
                
                sprite.position = startPosition;
                
                
                CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
                CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
                CGFloat wait = 0.5f  + (CCRANDOM_0_1() * 1.0f);
                
                
                CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                                 startPosition:startPosition
                                                   endPosition:endPosition];
                
                SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:NO duration:duration];
                SKAction *delayedAction = [SKAction waitForDuration:wait withRange:(NSTimeInterval)0.9];
                SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction]];
                
				[lSprites addObject:sprite];
				
				if (led.isON)
				{
					[self addChild:sprite];
					if (sequence)
						[sprite runAction:sequence];
					
                    [self drawLed:led];
				}
				else {
					sprite.position = CGPointMake(sprite.position.x, 600);
				}
				
			}
			
			ledContainer.sprites = lSprites;
			ledContainer.moveToActions = moveToActions;
			
			
			[self.allLedsDictionary setObject:ledContainer forKey:description];
		}
	}
}
-(void)doSetUp{
    if (self.pastSetUp == NO){
        self.pastSetUp = YES;
        [self addLedSprites];
    }
}


- (void)removeSpriteImmediately:(PhysicsClockItemSprite *)sprite{
    if (sprite.physicsBody == nil)
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.frame.size.width];
    
    sprite.physicsBody.affectedByGravity = YES;
    sprite.physicsBody.dynamic = YES;
    [sprite performSelector:@selector(cleanup) withObject:nil afterDelay:1.0];
}

- (void)reAddRemovedLeaf:(id)node{
    if ([node isKindOfClass:[PhysicsClockItemSprite class]]){
        PhysicsClockItemSprite* sprite = (PhysicsClockItemSprite*)node;
        if (CGPointEqualToPoint(sprite.position, sprite.leafStoredPosition) == NO){
            if (CGRectContainsPoint(sprite.containingFrame, sprite.leafStoredPosition)) {
                CGFloat xPos = sprite.leafStoredPosition.x;
                CGFloat yPos = sprite.leafStoredPosition.y;
                
                CGPoint endPosition = ccp(xPos, yPos);
                CGPoint startPosition = ccp(xPos - (100.0 + CCRANDOM_0_1() * xPos) , self.frame.size.height + CCRANDOM_0_1() * 50.0);
                
                sprite.position = startPosition;
                sprite.scale = 1.0;
                
                
                CGPoint controlPoint_1 = ccp( xPos - ( 25.0 + (CCRANDOM_0_1() * 50.0)), yPos + 50.0);
                CGFloat duration = 0.5f  + (CCRANDOM_0_1() * 0.5f);
                
                
                
                CGPathRef path =  [self getPathForControlPoint:controlPoint_1
                                                 startPosition:startPosition
                                                   endPosition:endPosition];
                
                SKAction *moveToAction = [SKAction followPath:path asOffset:NO orientToPath:NO duration:duration];
                SKAction *delayedAction = [SKAction waitForDuration:2.0 withRange:(NSTimeInterval)1.9];
                SKAction* targetAction = [SKAction performSelector:@selector(addPhysicsOnLed) onTarget:sprite];
                
                SKAction *sequence = [SKAction sequence:@[delayedAction,moveToAction,targetAction]];
                
                if ([sprite parent] == nil)
                    [self addChild:sprite];
                
                if ([sprite hasActions] == YES)
                    [sprite removeAllActions];
                
                [sprite runAction:sequence];
            }
        }
    }
}



- (BOOL)removeSpritesOnMouseDown{
    BOOL didRemove = NO;
    NSArray* nodes = [self nodesAtPoint:self.location];
    
    if  (nodes.count){
        for (SKNode *node in nodes) {
            if ([node isKindOfClass:[PhysicsClockItemSprite class]]){
                PhysicsClockItemSprite* sprite = (PhysicsClockItemSprite*)node;
                sprite.leafStoredPosition = sprite.position;
                [self removeSpriteImmediately:(PhysicsClockItemSprite*)node];
                [self performSelector:@selector(reAddRemovedLeaf:) withObject:node afterDelay:1.1];
                didRemove = YES;
            }
        }
    }
    return didRemove;
}


- (BOOL)magnifySpriteOnMouseDown{
    BOOL didMagnify = NO;
    if (self.isMouseDown){
        NSArray* nodes = [self nodesAtPoint:self.location];
        
        if  (nodes.count){
            for (SKNode *node in nodes) {
                if ([node isKindOfClass:[PhysicsClockItemSprite class]]){
                    PhysicsClockItemSprite* sprite = (PhysicsClockItemSprite*)node;
                    sprite.leafStoredPosition = sprite.position;
                    [sprite setScale:3.0];
                    sprite.zPosition = -200.0;
                    self.magnifiedSprite = sprite;
                    
                    didMagnify = YES;
                    break; // Just the one
                }
            }
        }
    }
    return didMagnify;
}

- (void)handleMouseUp{
    [self.magnifiedSprite setScale:1.0];

}

- (void)addSpritesOnMouseDown{
    
    if (self.isMouseDown){
        
        if ([self magnifySpriteOnMouseDown] == NO){
            CGPoint location = self.location;
            CGFloat sizef = 20.0;
            CGRect frame = CGRectMake(location.x, location.y, sizef, sizef);
            
            PhysicsClockItemSprite *sprite = [self getRandomImageSprite:frame
                                                                 ofType:0];
            
            sprite.position = location;
            sprite.scale = 1.1 +  CCRANDOM_MINUS1_1() * 1.0;
            sprite.zPosition = 20 +  CCRANDOM_0_1();
            
            sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sizef, sizef)];
            sprite.physicsBody.affectedByGravity = YES;
            
            sprite.physicsBody.categoryBitMask = leafCategoryFallingOn;
            sprite.physicsBody.collisionBitMask = leafCategoryOnLed;
            sprite.physicsBody.mass = 1.0;
            sprite.physicsBody.restitution = 0.5;
            
            [self addChild:sprite];
        }
    }
}

-(CGPathRef)getPathForStartPosition:(CGPoint)startPosition
                       endPosition:(CGPoint)endPosition{
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, NULL, startPosition.x , startPosition.y);
    CGPathAddLineToPoint(mutablePath, NULL, endPosition.x, endPosition.y);
    
    return CGPathCreateCopy(mutablePath);
}

#define kSpriteScale 0.5
#define kPlacardSlopY 30.0
#define kPlacardSlopX 170.0

#define kTwitterTextWidthSlop 300.0
#define kTwitterTextHeightSlop 30.0
#define kPlacardMaxWidth 300.0

-(CGImageRef)loadPlacardImageFromViewController:(OUSTwitterObject *)twitterObject{
    if (self.placardViewController == nil){
        self.placardViewController = [[OUSViewController alloc] initWithNibName:@"OUSViewController" bundle:[NSBundle mainBundle]];
        self.placardViewController.view.alphaValue = 1.0;
    }
    
    self.placardViewController.twitterFeedLabel.stringValue = twitterObject.mainText;
    self.placardViewController.userNameLabel.stringValue = twitterObject.userName;
    self.placardViewController.userImageView.image = twitterObject.profileImage;

    return self.placardViewController.imageForTwitterView;
}

-(void)showTwitterSearchDetails{
    NSString* fontName = [self twitterFontName];
	CGFloat fontSize = [self twitterFontSize];
    CGSize screenSize = [self size];
    NSString* searchTerm = self.chosenTwitterObject.searchString;

    
    if (_searchName == nil){
        _searchName = [SKLabelNode labelNodeWithFontNamed:fontName];
        _searchName.fontSize = fontSize;
        _searchName.fontColor = [self twitterFontColor];
        if (self.searchName.parent == nil){
            [self addChild:_searchName];
        }
    }
    
    _searchName.text = searchTerm;
    
    CGFloat x = roundf(screenSize.width/2.0 - ((fontSize * searchTerm.length)/2.0));
    CGFloat y = roundf(screenSize.height - 100.0);
    _searchName.position = ccp(x,y);

}

-(void)fadeInTwitterPlacard:(OUSTwitterObject *)twitterObject{
    CGImageRef placardImage = [self loadPlacardImageFromViewController:twitterObject];
    SKTexture* texture = [SKTexture textureWithCGImage:placardImage];
        
    if (self.placard.parent)
        [self.placard removeFromParent];
    
    self.placard.anchorPoint = CGPointMake(0.0, 0.0);
    self.placard = [SKSpriteNode spriteNodeWithTexture:texture];
    CGFloat x = roundf(kPlacardSlopX + kPlacardMaxWidth + kTwitterTextWidthSlop);
    CGFloat y = roundf(self.placardSprite.position.y + 110.0);
    
    self.placard.position = ccp(x,y);
    self.placard.xScale = 1.0;
    self.placard.yScale = 1.0;
    [self addChild:self.placard];
}

-(void)addPlacardForTwitterObject:(OUSTwitterObject *)twitterObject{
    SKTexture* texture = [SKTexture textureWithCGImage:twitterObject.imageMedium];
    
    CGFloat width = twitterObject.mediumImageWidth;
    CGFloat height = twitterObject.mediumImageHeight;
    
    if (width > kPlacardMaxWidth){
        height = height * (kPlacardMaxWidth/ width);
        width = kPlacardMaxWidth;
    }
    
    if (self.placard.parent)
        [self.placard removeFromParent];
    
    if (self.placardSprite.parent)
        [self.placardSprite removeFromParent];

    PhysicsClockItemSprite *sprite = [PhysicsClockItemSprite spriteNodeWithTexture:texture];
    
    

    NSScreen *screen = [NSScreen mainScreen];
    CGRect screenFrame = screen.frame;
        
    CGPoint startPosition = CGPointMake(screenFrame.size.width, kPlacardSlopY);
    CGPoint endPosition = CGPointMake(kPlacardSlopX, kPlacardSlopY);
    CGFloat maxHeight = [self distanceFromBottomForDate];
    
    sprite.anchorPoint = CGPointMake(0.0, 0.0);
    sprite.position = startPosition;
    sprite.zPosition = -100;
    sprite.size = CGSizeMake(width, height);
    sprite.xScale = (height > maxHeight) ? maxHeight/(height + kPlacardSlopY) : 1.0;
    sprite.yScale = (height > maxHeight) ? maxHeight/(height + kPlacardSlopY) : 1.0;


    CGFloat duration = 0.35f  + (CCRANDOM_0_1() * 0.1f);
    self.placardSprite = sprite;
    CGPathRef path =  [self getPathForStartPosition:startPosition
                                       endPosition:endPosition];
    
    SKAction *moveToAction = [SKAction followPath:path
                                         asOffset:NO
                                     orientToPath:NO
                                         duration:duration];
    

    SKAction *fadeAction  =[SKAction fadeAlphaTo:1.0 duration:duration];
    SKAction *sequence = [SKAction group:@[fadeAction,moveToAction]];
    
    double delayInSeconds = duration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fadeInTwitterPlacard:twitterObject];
    });

    [self addChild:sprite];
    sprite.alpha = 0.0;

    
    if ([sprite hasActions] == YES){
        [sprite removeAllActions];
    }
    [sprite runAction:sequence];
    
}

-(void)addOrChangePlacard:(NSTimeInterval)currentTime{
    
    if ((currentTime - self.lastPlacardTime) >= 7.0){
        self.lastPlacardTime = currentTime;

        self.placardNumber++;
        self.placardNumber %= kTimeToPlacardChange;
        
        [[OUSTwitterAccountManager sharedInstance] getNextTwitterMediumObject:self.placardNumber success:^(OUSTwitterObject *twitterObject) {
            if (twitterObject.imageMedium){
                self.chosenTwitterObject = twitterObject;
                [self addPlacardForTwitterObject:twitterObject];
            }
        }];
    }
}

-(void)addChosenItemSprites{
    if (self.chosenTwitterObject != nil){
        SKTexture* texture = [SKTexture textureWithCGImage:self.chosenTwitterObject.thumbNail];
        [self addFallingChosenItemSprites:texture];
    }
}

- (BOOL)dataReady{
    return [OUSTwitterAccountManager sharedInstance].hasImages;
    
}

- (void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];
    if (self.dataReady){
        [self doSetUp];
        if ((currentTime - self.lastSpriteTime) >= 0.1){
            [self addChosenItemSprites];
            [self addRandomSprites];
            self.lastSpriteTime = currentTime;
            [self addOrChangePlacard:currentTime];
            [self showTwitterSearchDetails];
        }
        
        [self addSpritesOnMouseDown];
    }
}

@end
