//
//  BTU.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "BTU.h"

static BTU *_shared = nil;

@implementation BTU

+ (id)sharedInstance {
    if (_shared == nil) {
        _shared = [[BTU alloc] init];
     }
    return _shared;
}

- (void)connect {
    GKPeerPickerController *picker = [[[GKPeerPickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
}

- (BOOL)sendData:(NSData *)data withError:(NSError **)error {
    if (self.session) {
        BOOL result = [self.session sendData:data toPeers:[NSArray arrayWithObject:self.peerId] withDataMode:GKSendDataReliable error:error];
        if (*error) {
            CLog(@"error in bluetooth:%@",*error);
        }
        return result;
    }
    return NO;
}

- (void)startTimer {
 
}

- (void)endTimer {
    
}

/*delegate method in GKPeerPickerControllerDelegate*/
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    self.peerId = peerID;
    self.session = session;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    //switch to the playing scene, when get access to other device through bluetooth.
    [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalBluetoothDidConnect, BTUActionKey, nil]];
}

/*delegate method in GKSessionDelegate*/
- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    self.session = nil;
}

/*delegate method in GKSessionDelegate*/
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    CLog(@"session_state:%d",state);
    if (state == GKPeerStateConnected) {
        
    }
}

/*delegate method block in GKSession*/
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    [[NSNotificationCenter defaultCenter] postNotificationName:BTUReceiveDataNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObject:data forKey:BTUReceiveDataKey]];
}

@end
