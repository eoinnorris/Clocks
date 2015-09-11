//
//  ImagesClockScene.h
//  
//
//  Created by Eoin Norris on 02/03/2014.
//
//

#import "ClockScene.h"
#import "OUSViewController.h"

@class PhysicsClockItemSprite;
@class OUSTwitterObject;

@interface ImagesClockScene : ClockScene

@property NSTimeInterval lastSpriteTime;
@property NSTimeInterval lastPlacardTime;

@property(strong,nonatomic) PhysicsClockItemSprite* magnifiedSprite;
@property(strong,nonatomic) PhysicsClockItemSprite* placardSprite;
@property(strong,nonatomic) OUSViewController* placardViewController;
@property(strong,nonatomic) OUSTwitterObject* chosenTwitterObject;


@property(strong,nonatomic)  SKSpriteNode* placard;
@property(strong,nonatomic)  SKLabelNode* searchName;




@end
