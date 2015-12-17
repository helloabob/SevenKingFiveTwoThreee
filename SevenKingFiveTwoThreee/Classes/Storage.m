//
//  Storage.m
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "Storage.h"

@implementation Storage

+ (id)sharedInstance {
    static Storage *store = nil;
    static dispatch_once_t dot;
    dispatch_once(&dot,^{
        store = [[Storage alloc] init];
    });
    return store;
}

//- (void)minusPokerCountOnDesktop:(int)count {
//    if (count <= 0) {
//        return;
//    }
//    self.pokerCountOnDesktop -= count;
//    [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalUpdateTopBarKey, BTUActionKey, nil]];
//}

@end
