//
//  SoundTool.h
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface SoundTool : NSObject

+ (void)playBackGroundSound;

+ (void)changeBGSoundVolume:(float)volume;

+ (void)playEmotionSound;

+ (void)playVictorySound;

@end
