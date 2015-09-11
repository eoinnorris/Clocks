//
//  OUSLocationManager.h
//  Imago
//
//  Created by Eoin Norris on 16/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OUSLocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager* locationManager;
@property(nonatomic) CLLocation* newlocation;

+ (OUSLocationManager*) sharedInstance;
- (void)startLocating;

@end
