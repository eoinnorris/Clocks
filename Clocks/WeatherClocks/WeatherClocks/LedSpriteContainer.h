//
//  LeafContainer.h
//  LeafClock
//
//  Created by Eoin norris on 26/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sprite;
@class Led;
@class BezierBy;

@interface LedSpriteContainer : NSObject 

@property(nonatomic) NSInteger ledIndex;
@property(nonatomic) NSInteger addedSpriteIndex;
@property(nonatomic,strong) NSArray* sprites;
@property(nonatomic,strong) Led* containingLed;
@property(nonatomic,strong) NSMutableArray* moveToActions;
@property(nonatomic,strong) NSMutableArray* moveFromActions;
@property(nonatomic,strong) NSMutableArray* moveToLedActions;
@property(nonatomic,strong) NSMutableArray* moveFromLedActions;

@end
