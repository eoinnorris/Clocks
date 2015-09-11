//
//  ENAppDelegate.h
//  WeatherClocks
//

//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface ENAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@end
