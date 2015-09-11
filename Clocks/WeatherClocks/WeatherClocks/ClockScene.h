//
//  ENMyScene.h
//  WeatherClocks
//

//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Led;

#define  kSoundEffectsOn  @"kSoundEffectsOn"
#define  kShowDate  @"kShowDate"

#define kSpriteSize  25.0

// 1024 x 768

#define  kTimeToPlacardChange       20
#define  kDistanceFromBottom		580.0f
#define  kDistanceFromBottomLandscape	360.0f

#define  kMaxHorizontalLedWidth		200.0f
#define  kMaxHorizontalLedHeight	40.0f
#define  kMaxVerticalLedWidth		40.0f
#define  kMaxVerticalLedHeight		90.0f
#define  kPositionFromLeft			40.0f
#define  kPositionFromLeftLandscape  200.0f
#define  kLEDDistance				120.0f

#define kMaxNumberOfVerticalLeds 16
#define kMaxNumberOfHorizontalLeds 12
#define kNumberOfDigits 4
#define kHorizontalLedCount 3
#define kVerticalLedCount 4

#define kMaximumNumberOfSprites 100

#define kMaximumNumberOfNormalActions 100
#define kMaximumNumberOfFastActions 100

typedef enum
{
	kWindNone,
    kWindModerate,
    kWindStrong
} WindType;



#define kMaxNumberOfSprites			10
#define kMaxNumberOfLedSprites		5
#define kMaxNumberOfFastSprites		10
#define kMaxNumberOfSpriteTypes     10
#define kMaxNumberOfSpritesToRemove 10
#define kMaxNumberOfSpritesPerSecond 1


typedef enum {
    kFarbehindClock,
    kBehindClock,
    kClockLevel,
    kFrontClock,
    kFarFrontClock
} SpritesZPosition;



@interface ClockScene : SKScene

@property(strong,atomic) SKSpriteNode *background;
@property(strong,atomic) NSArray* horizontalNames;
@property(nonatomic) NSInteger storedMinutes;

@property(strong,atomic) NSMutableArray* horizontalLeds;
@property(strong,atomic) NSMutableArray* verticalLeds;

@property(nonatomic) BOOL needsToAddSpritesFirstTime;

@property(strong,atomic)  NSMutableDictionary* allLedsDictionary;

@property(strong,atomic)  NSArray* digitNames;
@property(strong,atomic)  NSArray* verticalNames;

@property(strong,nonatomic)  SKLabelNode* dateLabel;
@property(strong,nonatomic) SKLabelNode* secondLabel;
@property(strong,nonatomic) SKLabelNode* infoLabel;

@property(strong,nonatomic) SKEmitterNode* rainEmitter;
@property BOOL isMouseDown;
@property CGPoint location;

@property BOOL soundON;
@property BOOL rainOn;
@property BOOL bgOn;
@property BOOL pastSetUp;

@property NSInteger placardNumber;


@property unsigned int effectID;
@property NSTimeInterval lastTime;
@property NSInteger minutesPassed;

-(CGFloat)distanceFromBottom;
-(CGFloat)positionFromLeft;
-(NSInteger)getSecondsPastMinuteValue;
-(CGFloat)secondsFontSize;
-(NSInteger)numberOfSprites;
-(NSInteger)numberOfSpritesPerLed;
-(NSInteger)numberOfMovingSprites;
-(NSInteger)numberOfSpriteTypes;
-(NSInteger)maxNumberOfSpritesToRemove;
-(CGPathRef)getPathForControlPoint:(CGPoint)cP1
                     startPosition:(CGPoint)startPosition
                       endPosition:(CGPoint)endPosition;

-(NSString*)dateFontName;
-(NSString*)secondsFontName;
-(SKColor*)dateFontColor;
-(NSInteger)distanceFromLeftForDate;
-(NSInteger)distanceFromBottomForDate;
-(CGFloat)dateFontSize;
-(CGFloat)twitterFontSize;
-(NSString*)twitterFontName;
-(SKColor*)twitterFontColor;
- (BOOL)dataReady;


-(void)drawLed:(Led*)led;
-(CGFloat)getAlphaBasedOnLeafPosition:(SpritesZPosition)position;
-(CGFloat)getScaleBaseOnLeafPosition:(SpritesZPosition)position;

@property(nonatomic) WindType storedWindType;

@end

