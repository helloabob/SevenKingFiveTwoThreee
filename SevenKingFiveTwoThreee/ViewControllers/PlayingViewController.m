//
//  PlayingViewController.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 13-9-16.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "PlayingViewController.h"

#import "Player.h"

#import "EnemyPlayer.h"

#import "BTU.h"

#import "JSON.h"

#import "SoundTool.h"

@interface PlayingViewController () {
    Player          *mySidePlayer;  //自己方
    EnemyPlayer     *enemySidePlayer;   //对方
    
    WBUIButton      *btnPrepare;  //准备按钮
    
    WBUIButton      *btnExit;
    
    
    
    BOOL            enemyIsReady;   //对方是否准备好
    BOOL            meIsReady;      //自己是否准备好
    
    UILabel         *lblPrepare;
}

@end

@implementation PlayingViewController

- (void)dealloc {
    self.topBarView = nil;
    self.mainView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setMainMenuHidden:(BOOL)hidden {
//    btnStart.hidden = hidden;
//    btnConnect.hidden = hidden;
//    btnSetting.hidden = hidden;
    self.mainView.hidden = hidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game_bg"]];
    iv.frame = self.view.bounds;
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:iv];
    [iv release];
    
    WBUIButton *btn = [[WBUIButton alloc] init];
    [btn setTitle:@"准备" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 40);
    btn.center = self.view.center;
    btn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [btn addTarget:self action:@selector(prepareGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn release];
    btnPrepare = btn;
    btnPrepare.hidden = YES;
    
    btn = [[WBUIButton alloc] init];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    btn.frame = CGRectMake(220, 0, 100, 40);
    [btn addTarget:self action:@selector(exitGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn release];
    btnExit = btn;
    btnExit.hidden = YES;
    
    lblPrepare = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lblPrepare.text = @"对方已准备好";
    lblPrepare.center = CGPointMake(self.view.center.x, 50);
    lblPrepare.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:lblPrepare];
    [lblPrepare release];
    lblPrepare.hidden = YES;
//    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(tt) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BTUReceived:) name:BTUReceiveDataNotificationNameKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LocalReceived:) name:LocalNotificationNameKey object:nil];
    
    _mainView = [[WBMainView alloc] initWithFrame:self.view.bounds];
    self.mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mainView];
    
    _topBarView = [[WBTopBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
    self.topBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.topBarView];
    [self.topBarView updatePokerCountInEnemy:5];
//    [self.topBarView updatePokerCountOnDesktop:34];
    
    //start to play background sound.
    [SoundTool playBackGroundSound];
}

- (void)LocalReceived:(NSNotification *)notif {
    NSString *actionName = [notif.userInfo objectForKey:BTUActionKey];
    if ([actionName isEqualToString:LocalServerPokerKey]) {
        NSArray *server_cards = [[PokerStateMachine sharedInstance] serverCards:5-enemySidePlayer.numberOfCardsInHand];
        [enemySidePlayer pullCards:server_cards];
//        [CommandTool callRemoteToPullCards:server_cards];
        enemySidePlayer.numberOfCardsInHand = 5;
        server_cards = [[PokerStateMachine sharedInstance] serverCards:5-mySidePlayer.cardsInHand.count];
        [mySidePlayer pullCards:server_cards];
        mySidePlayer.canPushCard = YES;
    } else if ([actionName isEqualToString:LocalIWinKey]) {
        [SoundTool playVictorySound];
        [self exitGame:nil];
    } else if ([actionName isEqualToString:LocalBluetoothDidConnect]) {
        [self setMainMenuHidden:YES];
        btnPrepare.hidden = NO;
    } else if ([actionName isEqualToString:LocalUpdateTopBarKey]) {
        NSNumber *num = [notif.userInfo objectForKey:@"count"];
        [_topBarView updatePokerCountOnDesktop:[num intValue]];
    }
}

- (void)BTUReceived:(NSNotification *)notif {
    NSData *data = (NSData *)[notif.userInfo objectForKey:BTUReceiveDataKey];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str JSONValue];
    CLog(@"receive_data:%@",dict);
    NSString *action = [dict objectForKey:BTUActionKey];
    if ([action isEqualToString:BTUGuestStartGameKey]) {
        [self initScene:NO];
    } else if([action isEqualToString:BTUGuestPullCardsKey]) {
        NSArray *array = [dict objectForKey:BTUParameterKey];
        [mySidePlayer pullCards:[CommandTool convertDictionaryToPokerCard:array]];
    } else if ([action isEqualToString:BTUGuestPushCardsKey]) {
        NSArray *array = [CommandTool convertDictionaryToPokerCard:[dict objectForKey:BTUParameterKey]];
        [enemySidePlayer pushCards:array];
        if (mySidePlayer.cardsInHand.count == 0) {
            NSString *str_data = [[NSDictionary dictionaryWithObjectsAndKeys:@"ok", BTUParameterKey, BTUGiveUpKey, BTUActionKey, nil] JSONFragment];
            NSError *error = nil;
            [[BTU sharedInstance] sendData:[str_data dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
            if ([[Storage sharedInstance] gamePlace]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LocalNotificationNameKey object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LocalServerPokerKey, BTUActionKey, nil]];
            }
        } else {
            [[Storage sharedInstance] setLastcards:array];
            mySidePlayer.canPushCard = YES;
            if (mySidePlayer.cardsInHand.count < 5) {
                [SoundTool playEmotionSound];
            }
        }
    } else if ([action isEqualToString:BTUItsYourTurnKey]) {
        mySidePlayer.canPushCard = YES;
    } else if ([action isEqualToString:BTUGiveUpKey]) {
        if ([[Storage sharedInstance] gamePlace]) {
            NSArray *server_cards = [[PokerStateMachine sharedInstance] serverCards:5-mySidePlayer.cardsInHand.count];
            [mySidePlayer pullCards:server_cards];
            server_cards = [[PokerStateMachine sharedInstance] serverCards:5-enemySidePlayer.numberOfCardsInHand];
            [enemySidePlayer pullCards:server_cards];
//            [CommandTool callRemoteToPullCards:server_cards];
            enemySidePlayer.numberOfCardsInHand = 5;
            mySidePlayer.canPushCard = YES;
        } else {
            mySidePlayer.canPushCard = YES;
        }
    } else if ([action isEqualToString:BTUYouLoseKey]) {
        [CommandTool showAlert:@"你输了，加油!"];
        [SoundTool playVictorySound];
        [self exitGame:nil];
    } else if ([action isEqualToString:BTUOutofPokerKey]) {
        [[Storage sharedInstance] setIsOutofPoker:YES];
    } else if ([action isEqualToString:BTUGuestPrepareGameKey]) {
        lblPrepare.hidden = NO;
        if (meIsReady == YES) {
            [self initScene:YES];
        } else {
            enemyIsReady = YES;
        }
    } else if ([action isEqualToString:BTUUpdateTopBarKey]) {
        NSNumber *num = [dict objectForKey:BTUParameterKey];;
        [_topBarView updatePokerCountOnDesktop:[num intValue]];
    }
}

- (void)ItsYourTurn {
    NSString *str_data = [[NSDictionary dictionaryWithObjectsAndKeys:@"ok", BTUParameterKey, BTUItsYourTurnKey, BTUActionKey, nil] JSONFragment];
    NSError *error = nil;
    [[BTU sharedInstance] sendData:[str_data dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
}

- (void)tt {
    CLog(@"random:%d",arc4random()%54);
}

- (void)changeStateToPush:(BOOL)isPush {
    mySidePlayer.canPushCard = isPush;
}

- (void)initScene:(BOOL)isHost {
    lblPrepare.hidden = YES;
//    [[Storage sharedInstance] setPokerCountOnDesktop:54];
//    [self setMainMenuHidden:YES];
//    btnPrepare.hidden = YES;
    if (isHost) {
        [[PokerStateMachine sharedInstance] tidyUpCards]; //call machine to prepare the poker.
    }
    [[Storage sharedInstance] setGamePlace:isHost];
    
    if (mySidePlayer) {
        if (mySidePlayer.view && mySidePlayer.view.superview == self.view) {
            [mySidePlayer.view removeFromSuperview];
        }
        [mySidePlayer release];
    }
    
    mySidePlayer = [[Player alloc] init];
    mySidePlayer.canPushCard = NO;
//    if (isHost) {
//        [mySidePlayer pullCards:[[PokerStateMachine sharedInstance] serverCards:5]];
//    } else {
//        mySidePlayer.canPushCard = NO;
//    }
    
    [self.view addSubview:mySidePlayer.view];
    
    if (enemySidePlayer) {
        if (enemySidePlayer.view && enemySidePlayer.view.superview == self.view) {
            [enemySidePlayer.view removeFromSuperview];
        }
        [enemySidePlayer release];
    }
    enemySidePlayer = [[EnemyPlayer alloc] init];
//    if (isHost) {
//        [enemySidePlayer pullCards:[[PokerStateMachine sharedInstance] serverCards:5]];
//    }
    
    [self.view addSubview:enemySidePlayer.view];
    
    if (isHost) {
        NSString *str = [[NSDictionary dictionaryWithObjectsAndKeys:@"yes", BTUParameterKey, BTUGuestStartGameKey, BTUActionKey, nil] JSONFragment];
        NSError *error = nil;
        [[BTU sharedInstance] sendData:[str dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
        
        NSArray *array1 = [[PokerStateMachine sharedInstance] serverCards:5];
        NSArray *array2 = [[PokerStateMachine sharedInstance] serverCards:5];
        
        [mySidePlayer pullCards:array1];
        [enemySidePlayer pullCards:array2];
        
        if ([CommandTool isFirstOneToServer:array1 withArray2:array2]) {
            mySidePlayer.canPushCard = YES;
        } else {
            [self ItsYourTurn];
        }
//        mySidePlayer.canPushCard = YES;
    }
    
//    [self.view bringSubviewToFront:btnExit];
}

- (void)exitGame:(id)sender {
    [mySidePlayer.view removeFromSuperview];
    [mySidePlayer release];
    mySidePlayer = nil;
    [enemySidePlayer.view removeFromSuperview];
    [enemySidePlayer release];
    enemySidePlayer = nil;
    enemyIsReady = NO;
    meIsReady = NO;
    btnPrepare.hidden = NO;
//    [self setMainMenuHidden:NO];
}

- (void)prepareGame:(id)sender {
    btnPrepare.hidden = YES;
    if (enemyIsReady == YES) {
        [self initScene:YES];
    } else {
        meIsReady = YES;
        NSString *str = [[NSDictionary dictionaryWithObjectsAndKeys:@"yes", BTUParameterKey, BTUGuestPrepareGameKey, BTUActionKey, nil] JSONFragment];
        NSError *error = nil;
        [[BTU sharedInstance] sendData:[str dataUsingEncoding:NSUTF8StringEncoding] withError:&error];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
    //    return toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
