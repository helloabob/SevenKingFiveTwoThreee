//
//  EnemyPlayer.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/16/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnemyPlayer : NSObject

@property (nonatomic, assign) NSUInteger numberOfCardsInHand;

@property (nonatomic, strong) NSMutableArray *cardsOutHand;

@property (nonatomic, strong) UIView *view;

- (void)pullCards:(NSArray *)cards;

- (void)pushCards:(NSArray *)cards;

@end
