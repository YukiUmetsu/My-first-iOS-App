//
//  LastExplanationView.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/12/14.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "LastExplanationView.h"

@implementation LastExplanationView
{
    
    GADBannerView *bannerView_;
    UIButton *btnToExplanation;
    int scrnHeight;
    
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    scrnHeight = rect.size.height;
    
    [self setPicAndBtn];
    
    if (scrnHeight > 500){
    // 画面上部に標準サイズのビューを作成する
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // 広告ユニット ID を指定する
    bannerView_.adUnitID = @"ca-app-pub-4865564788176487/6712423459";
    
    // ユーザーに広告を表示した場所に後で復元する UIViewController をランタイムに知らせて
    // ビュー階層に追加する
    bannerView_.rootViewController = self;
    bannerView_.frame = CGRectMake(0, self.view.frame.size.height - 50, 320, 50);
    [self.view addSubview:bannerView_];
    
    // 一般的なリクエストを行って広告を読み込む
    [bannerView_ loadRequest:[GADRequest request]];
    }
    
}

-(void)setPicAndBtn
{
    //説明ページへ飛ばすボタンを設置
    btnToExplanation = [UIButton new];
    btnToExplanation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (scrnHeight < 500){
        btnToExplanation.frame = CGRectMake(15, 430, 290, 30);
    } else {
        btnToExplanation.frame = CGRectMake(15, 457, 290, 30);
    }
    [btnToExplanation setTitle:@"メニュー画面に戻る" forState:UIControlStateNormal];
    [btnToExplanation.titleLabel setFont:[UIFont systemFontOfSize:16]];
    btnToExplanation.backgroundColor = [UIColor purpleColor];
    [btnToExplanation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnToExplanation addTarget:self action:@selector(goToExplanationPage)
               forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnToExplanation];
    
}

-(void)goToExplanationPage
{
    [self performSegueWithIdentifier:@"BackToMenuE" sender:self];
}
@end
