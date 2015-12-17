//
//  WBTopBarView.h
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTopBarView : UIView {
    UILabel *_lblTime;
    UILabel *_lblPokerCountInEnemy;
    UILabel *_lblPokerCountOnDesktop;
}

- (void)updatePokerCountInEnemy:(int)count;
- (void)updatePokerCountOnDesktop:(int)count;

@end
