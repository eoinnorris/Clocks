//
//  OUSTwitterObject.h
//  Imago
//
//  Created by Eoin Norris on 05/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OUSTwitterObject : NSObject

@property (nonatomic) CGImageRef thumbNail;
@property (nonatomic) CGImageRef imageMedium;
@property (nonatomic) CGImageRef imageLarge;

@property (nonatomic,strong) NSString *imageURLStr;
@property (nonatomic,strong) NSString *mainText;
@property (nonatomic,strong) NSString *friendlyDate;
@property (nonatomic,strong) NSString *fromText;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *dateString;
@property (nonatomic,strong) NSImage *profileImage;
@property (nonatomic,strong) NSString *searchString;



@property (nonatomic,strong) NSDate * date;

@property (nonatomic) CGFloat mediumImageHeight;
@property (nonatomic) CGFloat mediumImageWidth;

@property (nonatomic) CGFloat largeImageHeight;
@property (nonatomic) CGFloat largeImageWidth;


@end
