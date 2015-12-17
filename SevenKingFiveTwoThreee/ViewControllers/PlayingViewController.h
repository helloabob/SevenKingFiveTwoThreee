//
//  PlayingViewController.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 13-9-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PokerStateMachine.h"

#import "WBMainView.h"

#import "WBTopBarView.h"

@interface PlayingViewController : UIViewController

@property (nonatomic, strong) WBMainView *mainView;

@property (nonatomic, strong) WBTopBarView *topBarView;

@end
