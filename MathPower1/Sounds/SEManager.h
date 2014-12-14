//
//  KoukaonManager.h
//  ChinanagonoUtaTouch
//
//  Created by Yukinaga Azuma on 12/11/02.
//  Copyright (c) 2012年 Yukinaga Azuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEManager : NSObject

@property(nonatomic) float soundVolume;

- (void)playSound:(NSString *)soundName;

@end
