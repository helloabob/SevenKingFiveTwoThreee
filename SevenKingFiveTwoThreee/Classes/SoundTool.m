//
//  SoundTool.m
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "SoundTool.h"

#import <AVFoundation/AVFoundation.h>

static AVAudioPlayer *bgPlayer;

static SystemSoundID soundIDTest = 0;
@implementation SoundTool

+ (void)playBackGroundSound {
//    AVAudioPlayer *bgPlayer = nil;
    if (bgPlayer == nil) {
        NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"wav"]];
        bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        bgPlayer.numberOfLoops = -1;
    }
    bgPlayer.volume = 0.1;
    [bgPlayer prepareToPlay];
    [bgPlayer play];
}

+ (void)changeBGSoundVolume:(float)volume {
    if (bgPlayer != nil) {
        bgPlayer.volume = volume;
    }
}

+ (void)playVictorySound {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"yingle" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID( (CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    AudioServicesPlaySystemSound(soundIDTest);
}

+ (void)playEmotionSound {
    
    int select = arc4random() % 2;
    NSString *filename = nil;
    if (select == 0) {
        filename = @"yasi";
    } else {
        filename = @"huanshang";
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID( (CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    AudioServicesPlaySystemSound(soundIDTest);
    
    //    AVAudioPlayer *bgPlayer = nil;
//    if (mainPlayer == nil) {
//        NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"main" ofType:@"wav"]];
//        mainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
////        mainPlayer.numberOfLoops = -1;
//    }
//    mainPlayer.volume = 1;
//    [mainPlayer prepareToPlay];
//    [mainPlayer play];
}

@end
