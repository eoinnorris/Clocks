//
//  OUSViewController.h
//  Imago
//
//  Created by Eoin Norris on 08/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OUSViewController : NSViewController
@property (weak) IBOutlet NSTextField *userNameLabel;
@property (weak) IBOutlet NSImageView *userImageView;
@property (weak) IBOutlet NSTextField *twitterFeedLabel;
@property (weak) IBOutlet NSTextField *timeLabel;


- (CGImageRef)imageForTwitterView;

@end
