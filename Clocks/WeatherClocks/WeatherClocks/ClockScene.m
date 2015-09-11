//
//  ENMyScene.m
//  WeatherClocks
//
//  Created by Eoin Norris on 14/06/2013.
//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import "ClockScene.h"
#import "Led.h"
#import "DateTimeLedContoller.h"
#import "WCGraphicUtilities.h"
#import "LedSpriteContainer.h"
#import "PhysicsClockItemSprite.h"


@implementation ClockScene

- (void)addRain{
    self.rainEmitter = [SKEmitterNode wc_emitterNodeWithEmitterNamed:@"Rain"];
    self.rainEmitter.position = CGPointMake(200.0, 768.0);
    [self addChild:self.rainEmitter];
}

- (void)didMoveToView:(SKView *)view{
    [self setUp];
}

- (void)setUp{
    [self setUpNamingDictionaries];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    return self;
}

- (BOOL)dataReady{
    return YES;
}

- (void)update:(NSTimeInterval)currentTime{
    
    [super update:currentTime];
    
    NSInteger minutesPassed = [NSDate timeIntervalSinceReferenceDate]/60;
	
	if ([self dataReady] && (minutesPassed > self.storedMinutes)){
		self.storedMinutes = minutesPassed;
        [self addOrChangeVerticalLeds];
        [self addOrChangeHoriztonalLeds];
        [self addOrChangeDate];
	}
	
    // subclasses should update self.lastTime
    if ((currentTime - self.lastTime) >= 1.0){
        [self addOrChangeSeconds];
    }
}
#pragma mark MouseMoved -

- (void)mouseDragged:(NSEvent *)theEvent{
    [super mouseDragged:theEvent];
    
    if (self.isMouseDown == YES){
        self.location =  [theEvent locationInNode:self];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent{
    [super mouseMoved:theEvent];
    
    if (self.isMouseDown == YES){
        self.location =  [theEvent locationInNode:self];
    }
}

- (void)handleMouseUp{
    
}

- (void)mouseUp:(NSEvent *)theEvent{
    [super mouseUp:theEvent];
    self.isMouseDown = NO;
    [self handleMouseUp];
}

-(void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    
    /* Called when a mouse click occurs */
    self.isMouseDown = YES;
    self.location =  [theEvent locationInNode:self];
}

#pragma mark - 

// subclasses can override

-(NSString*)dateFontName
{
    return @"Helvetica";
}

-(CGFloat)secondsFontSize
{
	return 26.0;
}
-(NSString*)secondsFontName
{
    return @"Helvetica";
}

-(CGFloat)twitterFontSize
{
	return 24.0;
}

-(NSString*)twitterFontName
{
    return @"American Typewriter";
}

-(SKColor*)twitterFontColor{
    return [SKColor colorWithCalibratedRed:0.0 green:179.0 blue:242.0 alpha:1.0];
}


-(SKColor*)dateFontColor
{
	//return ccc3(0xf1, 0xC8, 0x27);
    return [SKColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}

-(SKColor*)secondsFontColor
{
	//return ccc3(0xf1, 0xC8, 0x27);
    return [SKColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}

-(NSInteger)distanceFromBottomForDate
{
	return (self.frame.size.height * ( 1/ 4.0));
}

-(NSInteger)distanceFromLeftForDate
{
	return (( self.frame.size.width / 2.0) - 5.0); // FIX ME!
}

-(CGFloat)dateFontSize{
    return 26.0f;
}

-(void)addOrChangeDate
{
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	NSString* format = @"EEE d MMM";
	
	[outputFormatter setDateFormat:format];
	
	NSString* dateString = [outputFormatter stringFromDate:[NSDate date]];
	
	if (self.dateLabel == NULL)
	{
		NSString* fontName = [self dateFontName];
		NSAssert((fontName != NULL),@"Font is missing");
		
        self.dateLabel = [SKLabelNode labelNodeWithFontNamed:fontName];
        self.dateLabel.text = dateString;
        self.dateLabel.fontSize = [self dateFontSize];
        self.dateLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.dateLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;

		
		self.dateLabel.position = ccp( [self distanceFromLeftForDate], [self distanceFromBottomForDate]);
		self.dateLabel.fontColor = [self dateFontColor];
		[self addChild:self.dateLabel];
	}else {
		self.dateLabel.text = dateString;
	}
}

-(NSInteger)distanceFromBottomForSeconds
{
	return (self.frame.size.height * ( 1/ 4.0)) + [self secondsFontSize];
}



-(NSInteger)distanceFromLeftForSeconds
{
	return (self.frame.size.width / 2.0);
}

-(NSInteger)getSecondsPastMinuteValue{
  	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
	NSInteger second = [components second];
    return second;
}

-(void)addOrChangeSeconds
{
	CGFloat fontSize = [self secondsFontSize];
    NSInteger second = [self getSecondsPastMinuteValue];
	NSString* secondStr = [NSString stringWithFormat:@":%02ld", (long)second];
	if (self.secondLabel == NULL)
	{
		
		 NSString* fontName = [self secondsFontName];
        NSAssert((fontName != NULL),@"Font is missing");
		
        self.secondLabel = [SKLabelNode labelNodeWithFontNamed:fontName];
        self.secondLabel.text = secondStr;
        self.secondLabel.fontSize = fontSize;
        self.secondLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.secondLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        
        self.secondLabel.position = ccp([self distanceFromLeftForSeconds], [self distanceFromBottomForSeconds]);
		
		 self.secondLabel.fontColor = [self secondsFontColor];
		 [self addChild:self.secondLabel];
	}else {
        self.secondLabel.text = secondStr;
	}
	
}

-(void)setUpNamingDictionaries
{
	self.digitNames = @[@"H1",@"H2",@"M1",@"M2"];
	self.verticalNames = @[@"S1",@"S2",@"S4",@"S5"];
	self.horizontalNames = @[@"S0",@"S3",@"S6"];
}


#define DRAWING 0

-(void)drawLed:(Led*)led{
#if DRAWING
    SKShapeNode* drawNode = [SKShapeNode node];
    drawNode.path = CGPathCreateWithRect(led.frame,nil);
    drawNode.strokeColor = [SKColor redColor];
    [self addChild:drawNode];
#endif
}

-(void)setUpStandardDefaults
{
	
}

-(CGFloat)getScaleBaseOnLeafPosition:(SpritesZPosition)position{
    CGFloat result = 1.0;
    switch (position) {
        case kFarbehindClock:
            result = 0.2;
            break;
            
        case kBehindClock:
            result = 0.5;
            break;
            
        case kClockLevel:
            result = 1.0;
            break;
            
        case kFrontClock:
            result = 1.5;
            break;
            
        case kFarFrontClock:
            result = 2.0;
            break;
            
        default:
            break;
    }
    
    
    return result;
}

-(CGFloat)getAlphaBasedOnLeafPosition:(SpritesZPosition)position{
    CGFloat result = 1.0;
    switch (position) {
        case kFarbehindClock:
            result = 0.25;
            break;
            
        case kBehindClock:
            result = 0.75;
            break;
            
        case kClockLevel:
            result = 1.0;
            break;
            
        case kFrontClock:
            result = 0.75;
            break;
            
        case kFarFrontClock:
            result = 0.25;
            break;
            
        default:
            break;
    }
    
    
    return result;
}

-(CGPathRef)getPathForControlPoint:(CGPoint)cP1
                     startPosition:(CGPoint)startPosition
                       endPosition:(CGPoint)endPosition{
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, NULL, startPosition.x , startPosition.y);
    CGPathAddLineToPoint(mutablePath, NULL, endPosition.x, endPosition.y);
    
    return CGPathCreateCopy(mutablePath);
}



-(CGFloat)distanceFromBottom{
	 return kDistanceFromBottomLandscape;
	
}

-(CGFloat)positionFromLeft{
	return kPositionFromLeft;
}

-(NSInteger)numberOfSprites
{
	return kMaxNumberOfSprites;
}

-(NSInteger)numberOfSpritesPerLed
{
	return kMaxNumberOfLedSprites;
}

-(NSInteger)numberOfMovingSprites
{
	return kMaxNumberOfFastSprites;
}

-(NSInteger)numberOfSpriteTypes
{
	return kMaxNumberOfSpriteTypes;
}

-(NSInteger)maxNumberOfSpritesToRemove
{
	return kMaxNumberOfSpritesToRemove;
}


// Alternatively the subclasses can subclass addOrChange...Leds to not use these
- (void)horizontalLed:(Led*)led frame:(CGRect)frame isOn:(BOOL)isOnNow wasOn:(BOOL)wasOn
{
	NSAssert(NO,@"Subclasses to Override - can do nothing");
}

- (void)verticalLed:(Led*)led frame:(CGRect)frame isOn:(BOOL)isOnNow wasOn:(BOOL)wasOn
{
	NSAssert(NO,@"Subclasses to Override - can do nothing");
}

-(SKAction*)getMoveToAction:(CGRect)frame forPosition:(NSInteger)leafNumber
                    maximum:(NSInteger)maximum
                  andSprite:(PhysicsClockItemSprite*)leaf{
    NSAssert(YES, @"Subclasses to override getMoveToAction:::");
    return nil;
}

-(void)addSpritesToThisLed:(id)object
{
    NSAssert(YES, @"Subclasses to override addSpritesToThisLed:");
}

- (void)removeSprite:(PhysicsClockItemSprite *)leaf
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
        [self removeSprite:leaf];
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


@end
