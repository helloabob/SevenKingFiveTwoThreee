//
//  EnemyPlayer.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/16/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "EnemyPlayer.h"

#import "PokerStateMachine.h"

#import "BTU.h"

#import "JSON.h"

#import "CommandTool.h"

#import "PokerCard.h"

#import "PokerCardView.h"

@implementation EnemyPlayer

- (void)dealloc {
    CLog(@"enemyplayer_dealloc");
    self.view = nil;
    self.cardsOutHand = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.cardsOutHand = [NSMutableArray array];
        self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 160)] autorelease];
        self.view.backgroundColor = [UIColor clearColor];
        //        self.view.alpha = 0.9f;
        
    }
    return self;
}

- (void)pullCards:(NSArray *)cards {
    if ([[Storage sharedInstance] gamePlace]) {
//        [[Storage sharedInstance] minusPokerCountOnDesktop:(int)cards.count];
        [CommandTool callRemoteToPullCards:cards];
//        NSArray *array = [CommandTool convertPokerCardToDictionary:cards];
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array, BTUParameterKey, BTUGuestPullCardsKey, BTUActionKey, nil];
//        NSError *error = nil;
//        NSString *str = [dict JSONFragment];
//        [[BTU sharedInstance] sendData:[str dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
    }
    self.numberOfCardsInHand += cards.count;
}

- (void)pushCards:(NSArray *)cards {
    self.numberOfCardsInHand -= cards.count;
    [self.cardsOutHand removeAllObjects];
    for (PokerCard *card in cards) {
        PokerCardView *cardView = [[PokerCardView alloc] initWithFrame:CGRectMake(0, 0, 42, 60)];
        cardView.isBackSide = NO;
        cardView.pokerCard = card;
        [self.cardsOutHand addObject:cardView];
        [cardView release];
    }
    [self tidyUp];
}

- (void)tidyUp {
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[PokerCardView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.cardsOutHand.count; i++) {
        PokerCardView *cardView = [self.cardsOutHand objectAtIndex:i];
        cardView.center = CGPointMake(self.view.center.x+(i-(int)self.cardsOutHand.count/2)*45, self.view.bounds.size.height - cardView.bounds.size.height/2-5);
        [self.view addSubview:cardView];
    }
}

@end
