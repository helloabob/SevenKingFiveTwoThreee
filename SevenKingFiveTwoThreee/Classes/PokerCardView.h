//
//  PokerCardView.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PokerCard.h"

@interface PokerCardView : UIView

@property (nonatomic, strong) PokerCard *pokerCard;
@property (nonatomic, assign) BOOL isBackSide;
@property (nonatomic, assign) BOOL isSelected;

- (BOOL)isEqualToPokerCard:(PokerCard *)card;

- (void)setAllFrame:(CGRect)frame;

- (void)showCard;

- (void)unSelect;

@end
