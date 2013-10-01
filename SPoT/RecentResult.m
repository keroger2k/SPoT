//
//  RecnetResult.m
//  SPoT
//
//  Created by Kyle Rogers on 10/1/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "RecentResult.h"

@implementation RecentResult

#define ALL_RESULTS_KEY @"RecentResult_All"
#define DISPLAY_TIME_KEY @"DISPLAY_TIME"
#define TITLE_KEY @"TITLE"
#define SUBTITLE_KEY @"SUBTITLE"
#define URL_KEY @"URL"

+ (NSArray *)allRecentImages
{
    NSMutableArray *recentImages = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        RecentResult *result = [[RecentResult alloc] initFromPropertyList:plist];
        [recentImages addObject:result];
    }
    
    return recentImages;
}

// convenience initializer
- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _displayTime = resultDictionary[DISPLAY_TIME_KEY];
            _imageURL = [NSURL URLWithString:resultDictionary[URL_KEY]];
            _title = resultDictionary[TITLE_KEY];
            _subTitle = resultDictionary[SUBTITLE_KEY];
        }
    }
    return self;
}

// designated initializer
- (id)init
{
    self = [super init];
    if (self) {
        _displayTime = [NSDate date];
        _title = @"NO TITLE";
        _subTitle = @"NO SUBTITLE";
    }
    return self;
}

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.displayTime description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (id)asPropertyList
{
    return @{ DISPLAY_TIME_KEY : self.displayTime, URL_KEY : [self.imageURL absoluteString], TITLE_KEY : self.title, SUBTITLE_KEY : self.subTitle };
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self synchronize];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self synchronize];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    [self synchronize];
}

@end
