//
//  WCGraphicUtilities.h
//  WeatherClocks
//
//  Created by Eoin Norris on 15/06/2013.
//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKEmitterNode (WeatherClockAdditions)
+ (instancetype)wc_emitterNodeWithEmitterNamed:(NSString *)emitterFileName;
@end
