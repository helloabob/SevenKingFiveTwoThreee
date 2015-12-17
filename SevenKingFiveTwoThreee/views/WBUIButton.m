//
//  WBUIButton.m
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/9/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "WBUIButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation WBUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.layer.cornerRadius = 10.0f;
    }
    return self;
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
