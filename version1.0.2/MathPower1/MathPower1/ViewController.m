//
//  ViewController.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/08/02.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    GADInterstitial *interstitial_;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = @"ca-app-pub-4865564788176487/6852024251";
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial{
    //広告が読み終わったら表示
    [interstitial_ presentFromRootViewController:self];
}

-(IBAction)buttonTapped1:(id)sender
{

}

-(IBAction)modoru:(UIStoryboardSegue *)sender
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
