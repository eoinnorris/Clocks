//
//  OUSAppDelegate.h
//  Imago
//
//  Created by Eoin Norris on 02/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "OUSLocationManager.h"


typedef enum {
    OUSTimeLineTypeHomeline,
    OUSTimeLineLocalTrends,
    OUSTimeLineUserSearch
} OUSTimeLineType;

@interface OUSAppDelegate : NSObject <NSApplicationDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (weak) IBOutlet SKView *skView;


@property (nonatomic) NSString* userName;


@end
