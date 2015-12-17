//
//  ViewController.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>

@interface ViewController : UIViewController<GKSessionDelegate,GKPeerPickerControllerDelegate,UITextFieldDelegate>


@property (nonatomic, strong) GKSession *session;
@end
