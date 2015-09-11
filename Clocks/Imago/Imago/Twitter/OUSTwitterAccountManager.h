//
//  OUSTwitterAccountManager.h
//  Imago
//
//  Created by Eoin Norris on 02/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMaxNumberOfImages 50

@class OUSTwitterObject;
@class CLLocation;


@class ACAccount;
@class STTwitterAPI;
@interface OUSTwitterAccountManager : NSObject

@property (nonatomic,strong) NSArray *osxAccounts;
@property (nonatomic) CFMutableArrayRef images;
@property (nonatomic,strong) NSMutableArray *twitterObjects;
@property (nonatomic,strong) NSMutableArray *searchURLStrs;
@property (nonatomic) CGImageRef defaultImage;


@property (nonatomic,strong) ACAccount *mainAccount;
@property (nonatomic,strong) STTwitterAPI *twitterAPI;

@property (nonatomic) BOOL askedRecently;
@property (nonatomic,strong) NSDate *lastDate;


+ (OUSTwitterAccountManager*) sharedInstance;
- (BOOL)hasImages;

- (CGImageRef)getRandomTwitterThumbsFromStore;
- (void)getHomeLineAndFeedForUser:(NSString*)user
                          success:(void(^)(NSInteger imageCount))successBlock
                            error:(void(^)(NSError *error))errorBlock_;


- (void)getLocalTwitterAccount;
- (void)getTrendsCloseToLocation:(CLLocation*)location;
- (void)loginAccount: (ACAccount*)account
             success:(void(^)(NSString* userName_))successBlock
               error:(void(^)(NSError *error))errorBlock;

- (void)getNextTwitterLargeObject:(NSInteger)select
                          success:(void(^)(OUSTwitterObject* twitterObject))success;

- (void)getNextTwitterMediumObject:(NSInteger)select
                           success:(void(^)(OUSTwitterObject* twitterObject))success;
- (void)getAccountStatus;


@end
