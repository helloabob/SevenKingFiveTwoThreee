//
//  Storage.h
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

@property (nonatomic, assign) BOOL gamePlace;

@property (nonatomic, assign) BOOL isOutofPoker;

@property (nonatomic, strong) NSArray *lastcards;

//@property (nonatomic, assign) int pokerCountOnDesktop;

+ (id)sharedInstance;

//- (void)minusPokerCountOnDesktop:(int)count;

@end
