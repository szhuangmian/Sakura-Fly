//
//  MainViewController.m
//  SakuraFly
//
//  Created by Chenglin on 15-10-1.
//  Copyright (c) 2015年 Chenglin. All rights reserved.
//

#import "InitialViewController.h"
#import "PrimaryScene.h"
#import "GameKitHeaders.h"

@import GameKit;

@interface InitialViewController ()

@property (strong, nonatomic) ADInterstitialAd *interstitial;
@property (strong, nonatomic) ADBannerView *adBanner;
@property (assign, nonatomic) BOOL requestingAd;
@property (strong, nonatomic) PrimaryScene *mainScene;
@property (assign, nonatomic) BOOL gameCenterEnabled;

@end


@implementation InitialViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainScene = [[PrimaryScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    _mainScene.scaleMode = SKSceneScaleModeAspectFit;
    [_mainScene runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"backGround.mp3" waitForCompletion:YES]]];
    SKView *view = (SKView *)self.view;
#ifdef DEBUG
    view.showsDrawCount = YES;
    view.showsFPS = YES;
    view.showsNodeCount = YES;
#else
    [self authenticateLocalPlayer];
#endif
    [view presentScene:_mainScene];
}

#pragma mark - game center

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;        }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}

#pragma mark -iAd

-(void)showFullScreenAd {
    _interstitial = [[ADInterstitialAd alloc] init];
    _interstitial.delegate = self;
    [UIViewController prepareInterstitialAds];
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    [self requestInterstitialAdPresentation];
    NSLog(@"interstitialAdREQUEST");
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    _interstitial = nil;
    _requestingAd = NO;
    NSLog(@"interstitialAd didFailWithERROR");
    NSLog(@"%@", error);
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"interstitialAdDidLOAD");
    [UIViewController prepareInterstitialAds];
    if(!_mainScene.isGameStart){
        [self requestInterstitialAdPresentation];
        NSLog(@"interstitialAdDidPRESENT");
    }
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    NSLog(@"interstitialAdDidUNLOAD");
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
    NSLog(@"interstitialAdDidFINISH");
}


@end
