//
//  PokerStateMachine.h
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PokerStateMachine : NSObject

+ (id)sharedInstance;

- (void)tidyUpCards;

- (NSArray *)serverCards:(int)number;

@end
