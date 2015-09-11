//
//  DateTimeLedContoller.h
//  Confetti
//
//  Created by Eoin norris on 15/02/2009.
//  Copyright 2009 Occasionally Useful Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum  {
	HourFirstDigit =0,
	HourSecondDigit =1,
	MinuteFirstDigit = 2,
	MinuteSecondDigit = 3
} WeatherClockTimeType;

typedef enum  {
	HoriztonalTop =0,
	HoriztonalMiddle =1,
	HoriztonalBottom = 2
} WeatherClockHorizontalLedPosition;


typedef enum  {
	VerticalTopLeft =1,
	VerticalTopRight =3,
	VerticalBottomLeft = 0,
	VerticalBottomRight = 2
} WeatherClockVerticalLedPosition;

@interface DateTimeLedContoller : NSObject {
	NSDate* thisDate;
	bool isOn;

}

@property(nonatomic, retain) NSDate *thisDate;
@property(nonatomic) bool isOn;

+ (DateTimeLedContoller*) sharedInstance;
- (void)setTime;
-(BOOL)showHoriztonalLedBasedOnTimeType:(WeatherClockTimeType)timeType ledPosition:(WeatherClockHorizontalLedPosition)position;
-(BOOL)showVerticalLedBasedOnTimeType:(WeatherClockTimeType)timeType ledPosition:(WeatherClockVerticalLedPosition)position;
@end
