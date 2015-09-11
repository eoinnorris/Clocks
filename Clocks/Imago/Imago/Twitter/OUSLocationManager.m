//
//  OUSLocationManager.m
//  Imago
//
//  Created by Eoin Norris on 16/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "OUSLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "OUSTwitterAccountManager.h"

@implementation OUSLocationManager

+ (OUSLocationManager*) sharedInstance
{
	static OUSLocationManager *singletonObject = nil;
	if (singletonObject == nil)
	{
		singletonObject = [[self alloc] init];
	}
	
	return singletonObject;
}


- (void)startLocating{
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation_ fromLocation:(CLLocation *)oldLocation{
    OUSTwitterAccountManager* sharedManager = [OUSTwitterAccountManager sharedInstance];
    [self.locationManager stopUpdatingLocation];
    
    self.newlocation = newLocation_;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sharedManager getTrendsCloseToLocation:self.newlocation];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"ERROR : %@ in %s", error,__PRETTY_FUNCTION__);
}

@end
