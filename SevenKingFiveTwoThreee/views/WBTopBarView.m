//
//  WBTopBarView.m
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "WBTopBarView.h"

#import "Storage.h"

@implementation WBTopBarView

- (void)dealloc {
    [_lblTime release];
    [_lblPokerCountInEnemy release];
    [_lblPokerCountOnDesktop release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.backgroundColor = [UIColor darkGrayColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        backView.backgroundColor = [UIColor colorWithRed:0.0f green:128.0/255.0 blue:1.0f alpha:1.0f];
        backView.alpha = 0.3f;
        [self addSubview:backView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-80, 0, 80, self.bounds.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
        [format setDateFormat:@"HH:mm"];
        label.text = [format stringFromDate:[NSDate date]];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:label];
        _lblTime = label;
        
        [NSTimer scheduledTimerWithTimeInterval:50.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 150, self.bounds.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:label];
        _lblPokerCountInEnemy = label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, self.bounds.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:label];
        _lblPokerCountOnDesktop = label;
        
    }
    return self;
}

- (void)updatePokerCountInEnemy:(int)count {
    _lblPokerCountInEnemy.text = [NSString stringWithFormat:@"对方牌数:%d", count];
}

- (void)updatePokerCountOnDesktop:(int)count {
    _lblPokerCountOnDesktop.text = [NSString stringWithFormat:@"牌堆牌数:%d", count];
}

- (void)updateTime {
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"HH:mm"];
    _lblTime.text = [format stringFromDate:[NSDate date]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
