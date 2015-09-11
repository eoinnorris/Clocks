//
//  DateTimeLedContoller.m
//  Confetti
//
//  Created by Eoin norris on 15/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DateTimeLedContoller.h"


@implementation DateTimeLedContoller 

@synthesize thisDate;
@synthesize isOn;

+ (DateTimeLedContoller*) sharedInstance
{
	static id singletonObject = nil;
	if (singletonObject == nil)
	{
		singletonObject = [[self alloc] init];
	}
	
	return singletonObject;
}

- (void)setTime
{
	thisDate = [NSDate date];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setTime];
	}
	return self;
}


-(void)showVerticalTopLeftLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  YES;
			break;
		case 1:
			self.isOn =  NO;
			break;
		case 2:
			self.isOn =  NO;
			break;
		case 3:
			self.isOn =  NO;
			break;
		case 4:
			self.isOn =  YES;
			break;
		case 5:
			self.isOn =  YES;
			break;
		case 6:
			self.isOn =  YES;
			break;
		case 7:
			self.isOn =  NO;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  YES;
			break;
			
			
		default:
			self.isOn =  NO;
			break;
	}
}


-(void)showVerticalTopRightLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  YES;
			break;
		case 1:
			self.isOn =  YES;
			break;
		case 2:
			self.isOn =  YES;
			break;
		case 3:
			self.isOn =  YES;
			break;
		case 4:
			self.isOn =  YES;
			break;
		case 5:
			self.isOn =  NO;
			break;
		case 6:
			self.isOn =  NO;
			break;
		case 7:
			self.isOn =  YES;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  YES;
			break;
			
			
		default:
			self.isOn =  NO;
			break;
	}
}

-(void)showVerticalBottomRightLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  YES;
			break;
		case 1:
			self.isOn =  YES;
			break;
		case 2:
			self.isOn =  NO;
			break;
		case 3:
			self.isOn =  YES;
			break;
		case 4:
			self.isOn =  YES;
			break;
		case 5:
			self.isOn =  YES;
			break;
		case 6:
			self.isOn =  YES;
			break;
		case 7:
			self.isOn =  YES;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  YES;
			break;
			
			
		default:
			self.isOn =  NO;
			break;
	}
}

-(void)showVerticalBottomLeftLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  YES;
			break;
		case 1:
			self.isOn =  NO;
			break;
		case 2:
			self.isOn =  YES;
			break;
		case 3:
			self.isOn =  NO;
			break;
		case 4:
			self.isOn =  NO;
			break;
		case 5:
			self.isOn =  NO;
			break;
		case 6:
			self.isOn =  YES;
			break;
		case 7:
			self.isOn =  NO;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  NO;
			break;
			
			
		default:
			self.isOn =  NO;
			break;
	}
}

-(void)showHoriztontalBottomLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  YES;
			break;
		case 1:
			self.isOn =  NO;
			break;
		case 2:
			self.isOn =  YES;
			break;
		case 3:
			self.isOn =  YES;
			break;
		case 4:
			self.isOn =  NO;
			break;
		case 5:
			self.isOn =  YES;
			break;
		case 6:
			self.isOn =  YES;
			break;
		case 7:
			self.isOn =  NO;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  YES;
			break;
			
			
		default:
			self.isOn =  NO;
			break;
	}
}


-(void)showHoriztontalMiddleLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  NO;
			break;
		case 1:
			self.isOn =  NO;
			break;
		case 2:
			self.isOn =  YES;
			break;
		case 3:
			self.isOn =  YES;
			break;
		case 4:
			self.isOn =  YES;
			break;
		case 5:
			self.isOn =  YES;
			break;
		case 6:
			self.isOn =  YES;
			break;
		case 7:
			self.isOn =  NO;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  YES;
			break;
			
		default:
			self.isOn =  NO;
			break;
	}
	
}
-(void)showHoriztontalTopLedBasedOnValue:(id)object
{
	NSNumber* num = (NSNumber*)object;
	NSInteger value = [num integerValue];
	
	switch (value) {
		case 0:
			self.isOn =  YES;
			break;
		case 1:
			self.isOn =  NO;
			break;
		case 2:
			self.isOn =  YES;
			break;
		case 3:
			self.isOn =  YES;
			break;
		case 4:
			self.isOn =  NO;
			break;
		case 5:
			self.isOn =  YES;
			break;
		case 6:
			self.isOn =  YES;
			break;
		case 7:
			self.isOn =  YES;
			break;
		case 8:
			self.isOn =  YES;
			break;
		case 9:
			self.isOn =  YES;
			break;
			
			
		default:
			self.isOn =  NO;
			break;
	}
	
}


-(BOOL)showLedBasedOnTimeType:(WeatherClockTimeType)timeType selector:(SEL)selector
{
	self.isOn  = NO;
	
	thisDate = [NSDate date]; 
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:thisDate];
	
	if (timeType == HourFirstDigit)
	{
		NSInteger thisHour = [components hour];
		NSInteger firstDigit = (NSInteger)floor(thisHour / 10);
		NSNumber* firstDigitNum = [NSNumber numberWithInteger:firstDigit];
       [self performSelector:selector withObject:firstDigitNum];
	}
	else if (timeType == HourSecondDigit)
	{
		NSInteger thisHour = [components hour];
		thisHour = thisHour % 10;
		NSNumber* hour2Num = [NSNumber numberWithInteger:thisHour];

		[self performSelector:selector withObject:hour2Num];
		
	} else if (timeType == MinuteFirstDigit)
	{
		NSInteger thisMinute = [components minute];
		NSInteger firstDigit = (NSInteger)floor(thisMinute / 10);
		NSNumber* minute1 = [NSNumber numberWithInteger:firstDigit];
        [self performSelector:selector withObject:minute1];
		
	} else if (timeType == MinuteSecondDigit)
	{
		NSInteger thisMinute = [components minute];
		NSInteger digit2 = thisMinute % 10;
		NSNumber* minute2 = [NSNumber numberWithInteger:digit2];
		 [self performSelector:selector withObject:minute2];
		
	}
	return self.isOn ;
}	

-(BOOL)showHoriztonalLedBasedOnTimeType:(WeatherClockTimeType)timeType ledPosition:(WeatherClockHorizontalLedPosition)position
{
	BOOL result = NO;
	if (position  == HoriztonalTop)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showHoriztontalBottomLedBasedOnValue:)];
	} else if (position  == HoriztonalMiddle)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showHoriztontalMiddleLedBasedOnValue:)];
	} 
	else if (position  == HoriztonalBottom)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showHoriztontalTopLedBasedOnValue:)];
	}
	
	return result;
}



-(BOOL)showVerticalLedBasedOnTimeType:(WeatherClockTimeType)timeType ledPosition:(WeatherClockVerticalLedPosition)position
{
	BOOL result = NO;
	if (position  == VerticalTopLeft)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showVerticalBottomLeftLedBasedOnValue:)];
	} else if (position  == VerticalTopRight)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showVerticalBottomRightLedBasedOnValue:)];
	} 
	else if (position  == VerticalBottomLeft)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showVerticalTopLeftLedBasedOnValue:)];
	} else if (position  == VerticalBottomRight)
	{
		result = [self showLedBasedOnTimeType:timeType selector:@selector(showVerticalTopRightLedBasedOnValue:)];
	}
	
	return result;
}

@end
