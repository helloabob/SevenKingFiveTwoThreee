//
//  CommandTool.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 13-9-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "CommandTool.h"

#import "PokerCard.h"

#import "PokerCardView.h"

#import "JSON.h"

#import "BTU.h"


@implementation CommandTool

//+ (void)setGamePlace:(BOOL)isHost {
//    ishost = isHost;
//}
//
//+ (BOOL)gamePlace {
//    return ishost;
//}
//
//+ (void)setIsOutofPoker:(BOOL)isOutof {
//    isOutofPoker = isOutof;
//}
//+ (BOOL)isOutofPoker {
//    return isOutofPoker;
//}

+ (BOOL)checkValidation:(NSArray *)array {
    if (array == nil || array.count == 0) return NO;
    if (array.count == 1) return YES;
    BOOL validation_flag = YES;
    for (int i = 0; i< array.count-1; i++) {
        PokerCard *card = [array objectAtIndex:i];
        PokerCard *card2 = [array objectAtIndex:array.count-1];
        if (card.cardRank != card2.cardRank) {
            validation_flag = NO;
            break;
        }
    }
    return validation_flag;
}

+ (void)showAlert:(NSString *)alertBody {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+ (BOOL)isLargeThan:(NSArray *)array {
    NSArray *lastcards = [[Storage sharedInstance] lastcards];
    if (lastcards == nil) {
        return YES;
    } else if (array.count != lastcards.count) {
        return NO;
    }else {
        PokerCard *card2 = [array objectAtIndex:0];
        PokerCard *card1 = [lastcards objectAtIndex:0];
        if (card2.cardRank >= card1.cardRank) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (NSArray *)convertDictionaryToPokerCard:(NSArray *)array {
    NSMutableArray *newarray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        PokerCard *card = [[PokerCard alloc] init];
        card.cardRank = [[dict objectForKey:@"rank"] intValue];
        card.cardColor = [[dict objectForKey:@"color"] intValue];
        [newarray addObject:card];
        [card release];
    }
    return newarray;
}

+ (NSArray *)convertPokerCardToDictionary:(NSArray *)array {
    NSMutableArray *new_array = [NSMutableArray array];
    for (id element in array) {
        NSDictionary *dict = nil;
        if ([element isKindOfClass:[PokerCard class]]) {
            PokerCard *card = (PokerCard *)element;
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:card.cardRank],@"rank", [NSNumber numberWithInt:card.cardColor], @"color", nil];
        } else if ([element isKindOfClass:[PokerCardView class]]) {
            PokerCardView *card = (PokerCardView *)element;
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:card.pokerCard.cardRank],@"rank", [NSNumber numberWithInt:card.pokerCard.cardColor], @"color", nil];
        }
        
        [new_array addObject:dict];
    }
    return new_array;
}

+ (BOOL)isFirstOneToServer:(NSArray *)array1 withArray2:(NSArray *)array2 {
    NSArray *arr1 = [self sortArray:array1];
    NSArray *arr2 = [self sortArray:array2];
    PokerCard *card1 = [arr1 objectAtIndex:0];
    PokerCard *card2 = [arr2 objectAtIndex:0];
    if (card1.cardRank <= card2.cardRank) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)sortArray:(NSArray *)array {
    NSArray *new_array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[PokerCardView class]]) {
            PokerCardView *pv1 = (PokerCardView *)obj1;
            PokerCardView *pv2 = (PokerCardView *)obj2;
            if (pv1.pokerCard.cardRank < pv2.pokerCard.cardRank) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                return (NSComparisonResult)NSOrderedDescending;
            }
        } else if ([obj1 isKindOfClass:[PokerCard class]]) {
            PokerCard *pv1 = (PokerCard *)obj1;
            PokerCard *pv2 = (PokerCard *)obj2;
            if (pv1.cardRank < pv2.cardRank) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                return (NSComparisonResult)NSOrderedDescending;
            }
        } else {
            return (NSComparisonResult)NSOrderedAscending;
        }
    }];
    return new_array;
}

//+ (void)setLastCards:(NSArray *)array {
//    if (lastcards != array) {
//        [lastcards release];
//        lastcards = [array retain];
//    }
//}
//
//+ (NSArray *)lastCards {
//    return lastcards;
//}

+ (void)callRemoteToPullCards:(NSArray *)cards {
    if (cards == nil) {
        return;
    }
    NSArray *array = [CommandTool convertPokerCardToDictionary:cards];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array, BTUParameterKey, BTUGuestPullCardsKey, BTUActionKey, nil];
    NSError *error = nil;
    NSString *str = [dict JSONFragment];
    [[BTU sharedInstance] sendData:[str dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
}

@end
