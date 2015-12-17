//
//  ViewController.m
//  SevenKingFiveTwoThreee
//
//  Created by wangbo on 9/15/13.
//  Copyright (c) 2013 wangbo. All rights reserved.
//

#import "ViewController.h"



@interface ViewController () {
    UITextField *txt;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *btn = [[[UIButton alloc] init] autorelease];
    [btn setTitle:@"CREATE GAME" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 200, 40);
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    btn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:btn];
    
    txt = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [self.view addSubview:txt];
    txt.returnKeyType = UIReturnKeyDone;
    txt.delegate = self;
    [txt setBorderStyle:UITextBorderStyleRoundedRect];
    txt.backgroundColor = [UIColor whiteColor];
    txt.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    [txt release];
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(200, 0, 100, 40);
    [btn setTitle:@"Send" forState:UIControlStateNormal];
    btn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    [btn addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    CLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tt) userInfo:nil repeats:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)tt {
    CLog(@"frame:%@",NSStringFromCGRect(txt.frame));
}

- (void)sendData {
    if(_session) {
        [_session sendDataToAllPeers:[txt.text dataUsingEncoding:NSUTF8StringEncoding] withDataMode:GKSendDataReliable error:nil];
    }
}

- (void)connect {
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    CLog(@"connected");
    self.session = session;
    [_session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateConnected) {
        CLog(@"state_connected");
    } else if (state == GKPeerStateDisconnected){
//        [self showAlert:@"state_disconnected"];
        CLog(@"state_disconnected");
        self.session = nil;
    } else {
        CLog(@"state:%d",state);
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    CLog(@"error:%@",error);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    CLog(@"connection_error:%@",error);
}

- (void)showAlert:(NSString *)theTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"received" message:theTitle delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    [self showAlert:str];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
////    return UIInterfaceOrientationLandscapeRight;
//    return uiinter;
//}

- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
//    return toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
