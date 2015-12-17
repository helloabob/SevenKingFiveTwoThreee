//
//  Player.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 13-9-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "Player.h"
#import "PokerStateMachine.h"
#import "PokerCardView.h"
#import "PokerCard.h"
#import "CommandTool.h"
#import "BTU.h"
#import "JSON.h"

@interface Player() {
    UIButton *btnSilence;
    UIButton *btnPush;
}
@end

@implementation Player

- (void)dealloc {
    CLog(@"player_dealloc");
    self.cardsInHand = nil;
    self.cardsOutHand = nil;
    self.view = nil;
    self.photo = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.cardsInHand = [NSMutableArray array];
        self.cardsOutHand = [NSMutableArray array];
        self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 160, 480, 160)] autorelease];
        self.view.backgroundColor = [UIColor clearColor];
        
        WBUIButton *btn = [[WBUIButton alloc] init];
        [btn setTitle:@"放弃" forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, 10, 50, 30);
        btn.tag = 2001;
        [btn addTarget:self action:@selector(UserAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn release];
        btnSilence = btn;
        
        
        btn = [[WBUIButton alloc] init];
        [btn setTitle:@"出牌" forState:UIControlStateNormal];
        btn.frame = CGRectMake(70, 10, 50, 30);
        btn.tag = 2002;
        [btn addTarget:self action:@selector(UserAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn release];
        btnPush = btn;
    }
    return self;
}

- (void)setCanPushCard:(BOOL)canPushCard {
    if (_canPushCard != canPushCard) {
        _canPushCard = canPushCard;
    }
    if (_canPushCard) {
        btnPush.alpha = 1;
        btnSilence.alpha = 1;
    } else {
        btnPush.alpha = 0;
        btnSilence.alpha = 0;
    }
}

- (void)UserAction:(UIButton *)sender {
    if (sender.tag == 2001) {
        NSString *str_data = [[NSDictionary dictionaryWithObjectsAndKeys:@"ok", BTUParameterKey, BTUGiveUpKey, BTUActionKey, nil] JSONFragment];
        NSError *error = nil;
        [[BTU sharedInstance] sendData:[str_data dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
        if ([[Storage sharedInstance] gamePlace]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalServerPokerKey, BTUActionKey, nil]];
        }
        self.canPushCard = NO;
        
    } else {
        NSMutableArray *array = [NSMutableArray array];
        for (PokerCardView *cardView in self.cardsInHand) {
            if (cardView.isSelected) {
                [array addObject:cardView.pokerCard];
            }
        }
        if (array.count > 0) {
            if ([CommandTool checkValidation:array]) {
                if ([CommandTool isLargeThan:array]) {
                    [self pushCards:array];
                } else {
                    [CommandTool showAlert:@"出牌不符合规则"];
                    [self.cardsInHand makeObjectsPerformSelector:@selector(unSelect)];
                }
            } else {
                [CommandTool showAlert:@"出牌不符合规则"];
                [self.cardsInHand makeObjectsPerformSelector:@selector(unSelect)];
            }
        } else {
            [CommandTool showAlert:@"请选择一张牌"];
            [self.cardsInHand makeObjectsPerformSelector:@selector(unSelect)];
        }
    }
}

- (void)pullCards:(NSArray *)cards {
    [[Storage sharedInstance] setLastcards:nil];
//    [[Storage sharedInstance] minusPokerCountOnDesktop:(int)cards.count];
    if (cards == nil) {
        return [self tidyUp];
    }
    
        for (PokerCard *card in cards) {
            PokerCardView *cardView = [[PokerCardView alloc] initWithFrame:CGRectMake(0, 0, 56, 80)];
            cardView.isBackSide = NO;
            cardView.pokerCard = card;
            [self.cardsInHand addObject:cardView];
            [cardView release];
        }
        [self.cardsOutHand removeAllObjects];
        [self tidyUp];
//    }
    
}

- (void)pushCards:(NSArray *)cards {
    [[Storage sharedInstance] setLastcards:nil];
    NSMutableArray *cardViews = [NSMutableArray array];
    for (PokerCard *card in cards) {
        for (PokerCardView *cardView in self.cardsInHand) {
            if ([cardView isEqualToPokerCard:card]) {
                [cardView setAllFrame:CGRectMake(0, 0, 42, 60)];
                [cardViews addObject:cardView];
                break;
            }
        }
    }
    [self.cardsInHand removeObjectsInArray:cardViews];
    [self.cardsOutHand removeAllObjects];
    [self.cardsOutHand addObjectsFromArray:cardViews];
    [self tidyUp];
//    if ([CommandTool gamePlace]) {
        NSError *error = nil;
        NSArray *array = [CommandTool convertPokerCardToDictionary:cards];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array, BTUParameterKey, BTUGuestPushCardsKey, BTUActionKey, nil];
        [[BTU sharedInstance] sendData:[[dict JSONFragment] dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
//    }
    self.canPushCard = NO;
    
    if (self.cardsInHand.count == 0 && [[Storage sharedInstance] isOutofPoker] == YES) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalIWinKey, BTUActionKey, nil]];
        
        [CommandTool showAlert:@"恭喜您赢了!"];
        NSError *error = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"ok", BTUParameterKey, BTUYouLoseKey, BTUActionKey, nil];
        [[BTU sharedInstance] sendData:[[dict JSONFragment] dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
    }
}

- (void)tidyUp {
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[PokerCardView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.cardsInHand makeObjectsPerformSelector:@selector(unSelect)];
    self.cardsInHand = [NSMutableArray arrayWithArray:[CommandTool sortArray:self.cardsInHand]];
//    CLog(@"%d",0-self.cardsInHand.count/2);
    for (int i = 0; i < self.cardsInHand.count; i++) {
        PokerCardView *cardView = [self.cardsInHand objectAtIndex:i];
        cardView.center = CGPointMake(self.view.center.x+(i-(int)self.cardsInHand.count/2)*60, self.view.bounds.size.height-10-cardView.bounds.size.height/2);
        [self.view addSubview:cardView];
    }
    for (int i = 0; i < self.cardsOutHand.count; i++) {
        PokerCardView *cardView = [self.cardsOutHand objectAtIndex:i];
        cardView.center = CGPointMake(self.view.center.x+(i-(int)self.cardsOutHand.count/2)*45, cardView.bounds.size.height/2+5);
        [self.view addSubview:cardView];
    }
}

@end
