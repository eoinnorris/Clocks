//
//  ENAppDelegate.m
//  WeatherClocks
//
//  Created by Eoin Norris on 14/06/2013.
//  Copyright (c) 2013 Occasionally Useful Software. All rights reserved.
//

#import "ENAppDelegate.h"
#import "ClockScene.h"
#import "FallingLeavesClockScene.h"

@implementation ENAppDelegate

@synthesize window = _window;



- (CIFilter*)flashFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIExposureAdjust"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:7] forKey:@"inputEV"];

    return bumpDistortion;
}

- (CIFilter*)glassFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIGaussianBlur"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    
    return bumpDistortion;
}

- (CIFilter*)bloomFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIBloom"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputRadius"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:20.0] forKey:@"inputIntensity"];

    //inputIntensity
    
    return bumpDistortion;
}

- (CIFilter*)pointFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIPointillize"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputRadius"];
    // [bumpDistortion setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputIntensity"];
    
    //inputIntensity
    
    return bumpDistortion;
}


- (CIFilter*)comicFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIGlassDistortion"];
    //[bumpDistortion setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputIntensity"];
    // [bumpDistortion setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputIntensity"];
    
    //inputIntensity
    
    return bumpDistortion;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    NSScreen *screen = [NSScreen mainScreen];
    CGRect screenFrame = screen.frame;
    
    CGSize size = CGSizeMake(screenFrame.size.width, screenFrame.size.height);
    
    /* Pick a size for the scene */
    SKScene *scene = [FallingLeavesClockScene sceneWithSize:size];

    scene.filter = [self comicFilter:size];
    scene.shouldEnableEffects = YES;

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFill;

    [self.skView presentScene:scene];
    
#if DEBUGGING
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsDrawCount = YES;
#endif
    
    srand([NSDate timeIntervalSinceReferenceDate]);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
