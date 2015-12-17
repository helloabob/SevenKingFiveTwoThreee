//
//  PokerCardView.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "PokerCardView.h"

#import <QuartzCore/QuartzCore.h>

const int PokerValue[15] = {4,6,8,9,10,11,12,13,1,3,2,-1,-2,5,7};

@interface PokerCardView() {
    
}

@end

@implementation PokerCardView

- (void)dealloc {
    self.pokerCard = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0f;
        _isSelected = NO;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        iv.tag = 2001;
        [self addSubview:iv];
        [iv release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)setAllFrame:(CGRect)frame {
    self.frame = frame;
    UIImageView *iv = (UIImageView *)[self viewWithTag:2001];
    iv.frame = self.bounds;
}

- (BOOL)isEqualToPokerCard:(PokerCard *)card {
    if (self.pokerCard.cardColor == card.cardColor && self.pokerCard.cardRank == card.cardRank) {
        return YES;
    }
    return NO;
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    self.isSelected = !_isSelected;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected) {
            self.center = CGPointMake(self.center.x, self.center.y-10);
        } else {
            self.center = CGPointMake(self.center.x, self.center.y+10);
        }
    }
}

- (void)unSelect {
    self.isSelected = NO;
}

- (void)setPokerCard:(PokerCard *)pokerCard {
    if (_pokerCard != pokerCard) {
        _pokerCard = [pokerCard retain];

        NSString *image_url = [NSString stringWithFormat:@"c%d_%d.jpg", pokerCard.cardRank, pokerCard.cardColor];
        UIImageView *iv = (UIImageView *)[self viewWithTag:2001];
        iv.image = [UIImage imageNamed:image_url];
        iv.frame = self.bounds;
    }
}

- (void)showCard {
    CLog(@"rank:%d color:%d",self.pokerCard.cardRank,self.pokerCard.cardColor);
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
