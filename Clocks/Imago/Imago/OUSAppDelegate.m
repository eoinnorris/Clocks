//
//  OUSAppDelegate.m
//  Imago
//
//  Created by Eoin Norris on 02/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "OUSAppDelegate.h"
#import "ImagesClockScene.h"
#import "OUSTwitterAccountManager.h"

@implementation OUSAppDelegate

- (CIFilter*)glassFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CIGaussianBlur"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    
    return bumpDistortion;
}

- (CIFilter*)bloomFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CISharpenLuminance"];
    [bumpDistortion setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputSharpness"];
   // [bumpDistortion setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputIntensity"];
    
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

- (CIFilter*)curveFilter:(CGSize)size{
    CIFilter* bumpDistortion = [CIFilter filterWithName:@"CISRGBToneCurveToLinear"];
    // [bumpDistortion setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputIntensity"];
    
    //inputIntensity
    
    return bumpDistortion;
}

- (CIFilter*)vibranceFilter:(CGSize)size{
    CIFilter* vibranceFilter = [CIFilter filterWithName:@"CIVibrance"];
    [vibranceFilter setValue:[NSNumber numberWithFloat:3.0] forKey:@"inputAmount"];
    
    //inputIntensity
    
    return vibranceFilter;
}


- (void)loadScene{
   
    NSScreen *screen = [NSScreen mainScreen];
    CGRect screenFrame = screen.frame;
    
    CGSize size = CGSizeMake(screenFrame.size.width, screenFrame.size.height);
    
    SKScene *scene = [ImagesClockScene sceneWithSize:size];

    scene.filter = [self vibranceFilter:size];
    scene.shouldEnableEffects = NO;
    //
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    [self.skView presentScene:scene];
    
#if TRUE
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsDrawCount = YES;
#endif
}

- (void)setInititalScreenSize{
    NSScreen *screen = [NSScreen mainScreen];
    CGRect screenFrame = screen.frame;
    
    [self.window setFrame:screenFrame display:YES];
    self.skView.frame = screenFrame;
}

- (void)startLocating{
    [[OUSLocationManager sharedInstance] startLocating];
}

#pragma mark - Twitter Searches

- (OUSTimeLineType)timeLineType{
    return OUSTimeLineLocalTrends;
}

- (void)loadTwitterTrendsTimeLine{
    OUSTwitterAccountManager* sharedManager = [OUSTwitterAccountManager sharedInstance];
    [sharedManager loginAccount:sharedManager.mainAccount success:^(NSString *userName_) {
        [self startLocating];
        
        // to do - proper call back here.
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadScene];
        });
        
    } error:^(NSError *error) {
        // alert;
    }];
}


- (void)loadTwitterUserSearchTimeLine{
   // To do:
    
}


- (void)loadTwitterHomeTimeLine{
    OUSTwitterAccountManager* sharedManager = [OUSTwitterAccountManager sharedInstance];
    [sharedManager getLocalTwitterAccount];
    [sharedManager loginAccount:sharedManager.mainAccount success:^(NSString *userName_) {
        self.userName = userName_;
        [sharedManager getHomeLineAndFeedForUser:self.userName success:^(NSInteger imageCount) {
            NSLog(@"imageCount is %ld",(long)imageCount);
            [self loadScene];
        } error:^(NSError *error) {
            NSLog(@"error is %@",error);
            
        }];
    } error:^(NSError *error) {
        // alert;
    }];
    
}

- (void)loadTwitterSearch{
    OUSTimeLineType type = [self timeLineType];
    switch (type) {
        case OUSTimeLineTypeHomeline:
            [self loadTwitterHomeTimeLine];
            break;
            
        case OUSTimeLineLocalTrends:
            [self loadTwitterTrendsTimeLine];

            break;
        
        case OUSTimeLineUserSearch:
            [self loadTwitterUserSearchTimeLine];
            break;
            
            
        default:
            break;
    }
}

#pragma mark - launch

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    srand([NSDate timeIntervalSinceReferenceDate]);
    
    [self setInititalScreenSize];
    [self loadScene];
    
//    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];

    [self loadTwitterSearch];
    
}


@end
