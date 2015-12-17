//
//  PokerCard.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

typedef enum {
    Club=0,
    Diamond,
    Heart,
    Spade,
}CardType;

#import <Foundation/Foundation.h>

@interface PokerCard : NSObject

@property (nonatomic, assign) int cardRank;
@property (nonatomic, assign) CardType cardColor;

- (void)showCard;

@end
