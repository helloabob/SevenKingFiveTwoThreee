//
//  PokerCard.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "PokerCard.h"

@implementation PokerCard

- (void)showCard {
    CLog(@"rank:%d color:%d",self.cardRank,self.cardColor);
}

@end
