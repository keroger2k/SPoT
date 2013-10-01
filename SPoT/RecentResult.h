//
//  RecnetResult.h
//  SPoT
//
//  Created by Kyle Rogers on 10/1/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentResult : NSObject

+ (NSArray *)allRecentImages; // of RecentResults

@property (readonly, nonatomic) NSDate *displayTime;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

@end
