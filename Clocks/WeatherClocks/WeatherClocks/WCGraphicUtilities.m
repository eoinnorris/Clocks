//
//  WCGraphicUtilities.m
//  WeatherClocks
//
//  Created by Eoin Norris on 15/06/2013.
//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import "WCGraphicUtilities.h"

#pragma mark - SKEmitterNode Category

@implementation SKEmitterNode (WeatherClockAdditions)
+ (instancetype)wc_emitterNodeWithEmitterNamed:(NSString *)emitterFileName {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:emitterFileName ofType:@"sks"]];
}
@end