//
//  CommandTool.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 13-9-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandTool : NSObject

//+ (void)setGamePlace:(BOOL)isHost;
//+ (BOOL)gamePlace;

//+ (void)setIsOutofPoker:(BOOL)isOutof;
//+ (BOOL)isOutofPoker;

//+ (void)setLastCards:(NSArray *)array;
//+ (NSArray *)lastCards;

+ (BOOL)checkValidation:(NSArray *)array;

+ (BOOL)isLargeThan:(NSArray *)array;

+ (NSArray *)convertDictionaryToPokerCard:(NSArray *)array;

+ (NSArray *)convertPokerCardToDictionary:(NSArray *)array;

+ (void)showAlert:(NSString *)alertBody;

+ (BOOL)isFirstOneToServer:(NSArray *)array1 withArray2:(NSArray *)array2;

+ (NSArray *)sortArray:(NSArray *)array;

+ (void)callRemoteToPullCards:(NSArray *)cards;

@end
