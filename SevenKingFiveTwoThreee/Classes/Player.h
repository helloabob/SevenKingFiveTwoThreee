//
//  Player.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 13-9-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

//头像
@property (nonatomic, strong) UIImageView *photo;

//手里的牌
@property (nonatomic, strong) NSMutableArray *cardsInHand;

//本轮打出去的牌
@property (nonatomic, strong) NSMutableArray *cardsOutHand;

//玩家界面
@property (nonatomic, strong) UIView *view;

//
@property (nonatomic, assign) BOOL canPushCard;


- (void)pullCards:(NSArray *)cards;
- (void)pushCards:(NSArray *)cards;


@end
