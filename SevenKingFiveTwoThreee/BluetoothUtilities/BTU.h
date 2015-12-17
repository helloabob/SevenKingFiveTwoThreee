//
//  BTU.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>


@interface BTU : NSObject<GKSessionDelegate,GKPeerPickerControllerDelegate>

@property (nonatomic, strong) GKSession *session;
@property (nonatomic, strong) NSString *peerId;

+ (id)sharedInstance;

- (void)connect;

- (BOOL)sendData:(NSData *)data withError:(NSError **)error;

- (void)startTimer;
- (void)endTimer;

@end
