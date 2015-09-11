//
//  Led.h
//  LeafClock
//
//  Created by Eoin norris on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Led : NSObject 

@property(nonatomic) CGPoint* vertices;
@property(nonatomic) CGRect frame;
@property(nonatomic) BOOL isON;
@property(nonatomic) BOOL wasON;
@property(nonatomic) BOOL wasOFF;
@property(retain,nonatomic) NSString* description;
//@property(retain,nonatomic) CCParticleSystem* emitter;

@end
