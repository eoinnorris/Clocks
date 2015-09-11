//
//  OUSTwitterAccountManager.m
//  Imago
//
//  Created by Eoin Norris on 02/03/2014.
//  Copyright (c) 2014 Occasionally Useful Software. All rights reserved.
//

#import "OUSTwitterAccountManager.h"
#import <Accounts/Accounts.h>
#import "STTwitterAPI.h"
#import "STTwitterOS.h"
#import "NSImage+Resize.h"
#import "OUSTwitterObject.h"
#import <CoreLocation/CoreLocation.h>


static NSInteger irandom(NSInteger start, NSInteger end)
{
	double r = random();
	r /= RAND_MAX;
	r = start + r*(end-start);
	
	return (NSInteger)round(r);
}

@interface OUSTwitterAccountManager ()
@property (nonatomic, strong) ACAccountStore *accountStore;
@end

@implementation OUSTwitterAccountManager

+ (OUSTwitterAccountManager*) sharedInstance
{
	static OUSTwitterAccountManager *singletonObject = nil;
	if (singletonObject == nil)
	{
		singletonObject = [[self alloc] init];
	}
	
	return singletonObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.images = CFArrayCreateMutable(kCFAllocatorDefault, 1, &kCFTypeArrayCallBacks);
        //CFRetain(self.images);
        self.accountStore = [[ACAccountStore alloc] init];
        self.twitterObjects = [NSMutableArray array];
        self.searchURLStrs = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    CFRelease(self.images);
    CFRelease(self.defaultImage);
    
}
- (void)loginAccount: (ACAccount*)account
             success:(void(^)(NSString* userName_))successBlock
               error:(void(^)(NSError *error))errorBlock
{
    if (!_twitterAPI){
        _twitterAPI= [STTwitterAPI twitterAPIOSWithAccount:account];
                
        [_twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
            successBlock(username);
        } errorBlock:^(NSError *error) {
            errorBlock(error);
        }];
    }
}

- (BOOL)hasImages{
    return (self.twitterObjects.count > 5);
}

- (void)getLocalTwitterAccount
{
    ACAccountType *twitterAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [_accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if(granted == NO) return;
        
        self.osxAccounts = [_accountStore accountsWithAccountType:twitterAccountType];
        
        if (self.osxAccounts.count){
            self.mainAccount = self.osxAccounts[0];
        }
    }];
}

-(void)storeSizes:(NSDictionary*)sizesDict
    inTwitterObject:(OUSTwitterObject*)twitterObject{
    
    NSDictionary* largeDict = [sizesDict objectForKey:@"large"];
    if (largeDict){
        NSString *largeHeight = [largeDict objectForKey:@"h"];
        NSString *largeWidth = [largeDict objectForKey:@"w"];
        
        twitterObject.largeImageHeight = [largeHeight floatValue];
        twitterObject.largeImageWidth = [largeWidth floatValue];
    }
    
    NSDictionary* mediumDict = [sizesDict objectForKey:@"medium"];

    if (mediumDict){
        NSString *mediumHeight = [mediumDict objectForKey:@"h"];
        NSString *mediumWidth = [mediumDict objectForKey:@"w"];
        
        twitterObject.mediumImageHeight = [mediumHeight floatValue];
        twitterObject.mediumImageWidth = [mediumWidth floatValue];
    }
}

-(void)storeUserInfo:(NSDictionary*)userDict
            inObject: (OUSTwitterObject*)twitterObject{
    twitterObject.userName = [userDict objectForKey:@"name"];
    twitterObject.profileImage = [NSImage imageNamed:@"TwitterEgg.png"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        NSString* profileUserURLStr = [userDict objectForKey:@"profile_image_url"];
        if (profileUserURLStr){
            NSURL* profileURL = [NSURL URLWithString:profileUserURLStr];
            twitterObject.profileImage = [[NSImage alloc] initWithContentsOfURL:profileURL];
        }
    });
}


-(void)storeDate:(NSString*)datStr{
    
}

// created_at
-(void)imagesFromStatusJson:(NSArray*)statuses
                  searchStr:(NSString*)searchString{
    for (NSDictionary* statusDict in statuses) {
        NSInteger count = CFArrayGetCount(self.images);
        if (count > kMaxNumberOfImages)
            break;
        if ([statusDict isKindOfClass:[NSDictionary class]]){
            OUSTwitterObject* twitterObject = [[OUSTwitterObject alloc] init];
            NSDictionary* entities = [statusDict objectForKey:@"entities"];
            NSArray* mediaArray = [entities objectForKey:@"media"];
            twitterObject.mainText = [statusDict objectForKey:@"text"];
            
            [self storeUserInfo:[statusDict objectForKey:@"user"]
                       inObject:twitterObject];
            
            if (mediaArray.count){
                NSDictionary* media = mediaArray[0];
                NSString* type = [media objectForKey:@"type"];
                if ([type isEqualToString:@"photo"]){
                    NSString* mediaURLStr = [media objectForKey:@"media_url"];
                    NSDictionary* sizesDict = [media objectForKey:@"sizes"];
                    if (sizesDict.count){
                        [self storeSizes:sizesDict
                            inTwitterObject:twitterObject];
                    }
                    twitterObject.imageURLStr = mediaURLStr;
                    mediaURLStr = [mediaURLStr stringByAppendingString:@":thumb"];
                    NSURL* mediaURL = [NSURL URLWithString:mediaURLStr];
                    if (mediaURL){
                        NSImage* thisImage = [[NSImage alloc] initWithContentsOfURL:mediaURL];
                        if (thisImage ){
                            NSInteger size_ = kSpriteNormalSize + kSpriteMaximumDelta;
                            CGImageRef imageRef = [thisImage cgImageOfSize:CGSizeMake(size_, size_)];
                            twitterObject.thumbNail = imageRef;
                            twitterObject.searchString = searchString;
                            [self.twitterObjects addObject:twitterObject];
                        }
                    }
                }
            }
        }
    }
    return;
}

-(void)getAccountStatus
{
    [self.twitterAPI getAccountSettingsWithSuccessBlock:^(NSDictionary *settings) {
        NSLog(@"settings are %@",settings);
    } errorBlock:^(NSError *error) {
        NSLog(@"error (%@) returned from %s",error, __PRETTY_FUNCTION__);
    }];
}

-(void)getFirstSearchFromTrends:(NSArray*)inTrends{
    self.twitterObjects = [NSMutableArray array];
    
    for (NSString* urlStr in inTrends) {
        if ([urlStr isKindOfClass:[NSString class]]){
            [self.twitterAPI getSearchTweetsWithQuery:urlStr
                                         successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                 NSLog(@"statuses = %@",statuses);
                 [self imagesFromStatusJson:statuses
                                  searchStr:urlStr];
            } errorBlock:^(NSError *error) {
                NSLog(@"error is %@",error);
            }];
        }
    }
}

-(void)getUrlsFromTrends:(NSArray*)trends{
    for (NSDictionary* dict in trends) {
        NSString* searchURLStr = [dict objectForKey:@"name"];
        if (searchURLStr){
            [self.searchURLStrs addObject:searchURLStr];
        }
    }
    
    [self getFirstSearchFromTrends:self.searchURLStrs];
}

- (void)getTrendsCloseToLocation:(CLLocation*)location{
    NSString* latStr = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString* lonStr = [NSString stringWithFormat:@"%f",location.coordinate.longitude];

    if (self.lastDate
        && abs([self.lastDate timeIntervalSinceNow] <600)){
        return;

    }
    
    self.lastDate = [NSDate date];
    [self.twitterAPI getTrendsClosestToLatitude:latStr
                                       longitude:lonStr
                                    successBlock:^(NSArray *locations) {
           if(locations.count && [locations isKindOfClass:[NSArray class]]){
               NSDictionary* locationDict = locations[0];
               NSNumber* woeid = [locationDict objectForKey:@"woeid"];
               NSString* woeidStr = [NSString stringWithFormat:@"%ld",[woeid longValue]];
               
               if (woeidStr){
                  //[self.twitterAPI getTrendsForWOEID:@"23424803" 
                  [self.twitterAPI getTrendsForWOEID:woeidStr excludeHashtags:[NSNumber numberWithBool:NO] successBlock:^(NSDate *asOf, NSDate *createdAt, NSArray *locations, NSArray *trends) {
                      [self getUrlsFromTrends:trends];
                    } errorBlock:^(NSError *error) {
                      NSLog(@"error (%@) returned from %s",error, __PRETTY_FUNCTION__);
                  }];
               }
           }
        // do search
    } errorBlock:^(NSError *error) {
        NSLog(@"error (%@) returned from %s",error, __PRETTY_FUNCTION__);
    }];
}


- (void)getHomeLineAndFeedForUser:(NSString*)userName
                          success:(void(^)(NSInteger imageCount))successBlock
                     error:(void(^)(NSError *error))errorBlock_{
    [self.twitterAPI getHomeTimelineSinceID:nil
                                      count:1000
                               successBlock:^(NSArray *statuses) {
                                   NSString *formatStr = [NSString stringWithFormat:@"%@'s Timeline",userName];
                                   [self imagesFromStatusJson:statuses searchStr:formatStr];
                                   NSInteger count = CFArrayGetCount(self.images);
                                   successBlock(count);
                               } errorBlock:^(NSError *error) {
                                   errorBlock_(error);
                               }];
}


- (void)getNextTwitterMediumObject:(NSInteger)select
                                success:(void(^)(OUSTwitterObject* twitterObject))success{
    NSInteger count = self.twitterObjects.count;
    if (count != 0){
        select = select % self.twitterObjects.count;
        OUSTwitterObject* twitter = self.twitterObjects[select];
        NSString* mediaURLStr = twitter.imageURLStr;
        mediaURLStr = [mediaURLStr stringByAppendingString:@":medium"];
        NSURL* mediaURL = [NSURL URLWithString:mediaURLStr];
        if (mediaURL){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
                NSImage* thisImage = [[NSImage alloc] initWithContentsOfURL:mediaURL];
                if (thisImage ){
                    CGFloat width = twitter.mediumImageWidth;
                    CGFloat height = twitter.mediumImageHeight;
                    twitter.imageMedium = [thisImage cgImageOfSize:CGSizeMake(width, height)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(twitter);
                    });
                }
            });
        }
    }
}


- (void)getNextTwitterLargeObject:(NSInteger)select
                     success:(void(^)(OUSTwitterObject* twitterObject))success{
    NSInteger count = self.twitterObjects.count;
    if (count != 0){
        select = select % self.twitterObjects.count;
        OUSTwitterObject* twitter = self.twitterObjects[select];
        NSString* mediaURLStr = twitter.imageURLStr;
        mediaURLStr = [mediaURLStr stringByAppendingString:@":large"];
        NSURL* mediaURL = [NSURL URLWithString:mediaURLStr];
        if (mediaURL){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
                NSImage* thisImage = [[NSImage alloc] initWithContentsOfURL:mediaURL];
                if (thisImage ){
                    CGFloat width = twitter.largeImageWidth;
                    CGFloat height = twitter.largeImageHeight;
                    twitter.imageLarge = [thisImage cgImageOfSize:CGSizeMake(width, height)];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(twitter);
                    });
                }
            });

        }
      
    }
    
    return;
}

- (CGImageRef)getRandomTwitterThumbsFromStore{
    CGImageRef image = nil;
    NSInteger count = self.twitterObjects.count;
    if (count != 0){
        NSInteger select = irandom(0, count-1);
        image = ((OUSTwitterObject*)(self.twitterObjects[select])).thumbNail;
   }
    
    if (image == nil){
        if (_defaultImage == nil){

            NSInteger size_ = kSpriteNormalSize + kSpriteMaximumDelta;
            _defaultImage= [[NSImage imageNamed:@"TwitterEgg.png"] cgImageOfSize:CGSizeMake(size_, size_)];
            CFRetain(_defaultImage);
        }
    
        image = _defaultImage;
    }
    
    return image;
}



@end
