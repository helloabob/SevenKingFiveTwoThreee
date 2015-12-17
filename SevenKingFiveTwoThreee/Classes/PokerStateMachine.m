//
//  PokerStateMachine.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "PokerStateMachine.h"
#import "PokerCard.h"

#import "JSON.h"
#import "BTU.h"

static PokerStateMachine *_shared;

@interface PokerStateMachine() {
    NSMutableArray *_cards;
}

@end

@implementation PokerStateMachine

+ (id)sharedInstance {
    if (_shared == nil) {
        _shared = [[PokerStateMachine alloc] init];
    }
    return _shared;
}

- (void)tidyUpCards {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 15; i ++) {
        for (int j = 0; j < 4; j ++) {
            PokerCard *card = [[PokerCard alloc] init];
            card.cardColor = j;
            card.cardRank = i;
            [array addObject:card];
            [card release];
            if (i == 12 || i == 13) {
                break;
            }
        }
    }
//    [array makeObjectsPerformSelector:@selector(showCard)];
    
    NSMutableArray *messArray = [NSMutableArray array];
    while (array.count > 0) {
        int index = arc4random()%array.count;
        [messArray addObject:[array objectAtIndex:index]];
        [array removeObjectAtIndex:index];
    }
    
//    [messArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){15, 39}]];
    
    [self setCards:messArray];
}

- (NSArray *)serverCards:(int)number {
    NSRange range;
    //todo 加判断
    if (_cards.count == 0) {
        [[Storage sharedInstance] setIsOutofPoker:YES];
//        [CommandTool setIsOutofPoker:YES];
        NSError *error = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"ok", BTUParameterKey, BTUOutofPokerKey, BTUActionKey, nil];
        [[BTU sharedInstance] sendData:[[dict JSONFragment] dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
        return nil;
    } else if (_cards.count <= number) {
        range.location = 0;
        range.length = _cards.count;
        [[Storage sharedInstance] setIsOutofPoker:YES];
        NSError *error = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"ok", BTUParameterKey, BTUOutofPokerKey, BTUActionKey, nil];
        [[BTU sharedInstance] sendData:[[dict JSONFragment] dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
    } else {
        [[Storage sharedInstance] setIsOutofPoker:NO];
        range.location = 0;
        range.length = number;
    }
    NSArray *array = [_cards objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    [_cards removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    [self notifyPokerCardsLeft];
    
    return array;
}

- (void)notifyPokerCardsLeft {
    [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalUpdateTopBarKey, BTUActionKey, [NSNumber numberWithInt:(int)_cards.count], @"count", nil]];
    NSError *error = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)_cards.count], BTUParameterKey, BTUUpdateTopBarKey, BTUActionKey, nil];
    [[BTU sharedInstance] sendData:[[dict JSONFragment] dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
}

- (void)setCards:(NSMutableArray *)cards {
    if (_cards != cards) {
        [_cards release];
        _cards = [cards retain];
    }
}

@end
