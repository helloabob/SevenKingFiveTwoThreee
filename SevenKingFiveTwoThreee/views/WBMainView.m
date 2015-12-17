//
//  WBMainView.m
//  SevenKingFiveTwoThreee
//
//  Created by mac0001 on 10/12/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "WBMainView.h"
#import "WBUIButton.h"
#import "BTU.h"

#import "SoundTool.h"

@implementation WBMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.backgroundColor = [UIColor darkTextColor];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg.jpg"]];
        iv.frame = self.bounds;
        iv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:iv];
        [iv release];
        
        WBUIButton *btn = [[WBUIButton alloc] init];
        [btn setTitle:@"开始游戏" forState:UIControlStateNormal];
        //    btn.frame = CGRectMake(110, 0, 100, 40);
        btn.frame = CGRectMake(0, 0, 100, 40);
        btn.center = CGPointMake(100, self.center.y-50);
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [btn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn release];
        btnStart = btn;
        
        btn = [[WBUIButton alloc] init];
        [btn setTitle:@"游戏设置" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 100, 40);
        btn.center = CGPointMake(100, self.center.y+50);
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [btn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn release];
        btnSetting = btn;
        
    }
    return self;
}

- (void)setting:(id)sender {
//    [SoundTool playMainSound];
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    
}

- (void)start:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalBluetoothDidConnect, BTUActionKey, nil]];
    [[BTU sharedInstance] connect];
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
