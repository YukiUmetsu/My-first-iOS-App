//
//  Done.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/08/03.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "Done.h"
#import "SEManager.h"
#import "AppDelegate.h"

@interface Done ()
{
    
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *monsterLvLabel;
    IBOutlet UILabel *nextLvLabel;
    
    SEManager *koukaonKanri;
    
    int Game1Score;
    int Game2Score;
    int Game3Score;
    int currentScore;
    int monsterLevel;
    int nextLevel;
    
    UIImageView *monsterView;
    
    bool goRight;
    bool countPlus;
    NSTimer *animationTimer;
    
    UIImageView *img;
    UIImageView *fimg;
    int AnimationCount;
    int AnimationLoop;
    int positionX;
    NSMutableArray *imageArray;
    NSMutableArray *fimageArray;
}
@end

@implementation Done

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //効果音再生
    koukaonKanri = [SEManager new];
    [koukaonKanri playSound:@"otukaresama.mp3"];
    
    Game1Score = 0;
    Game2Score = 0;
    Game3Score = 0;
    
    //モンスターレベル＆現在のスコアの読み込み
    [self loadMonsterLevel];
    
    //ゲームからスコアの読み込み
     AppDelegate *aD1 = [UIApplication sharedApplication].delegate;
     AppDelegate *aD2 = [UIApplication sharedApplication].delegate;
     AppDelegate *aD3 = [UIApplication sharedApplication].delegate;
    
    //現在のスコアを設定
    if (aD1.savedScore1 > 0) {
    Game1Score = *(aD1.savedScore1);
    }
    if (aD2.savedScore2 > 0) {
    Game2Score = *(aD2.savedScore2);
    }
    if (aD3.savedScore3 >0) {
    Game3Score = *(aD3.savedScore3);
    }
    currentScore += Game1Score + Game2Score + Game3Score;
    
    //モンスターレベル更新
    //スコアが1000以上ならばモンスターレベル＋1
    if (currentScore > 1000 ) {
        monsterLevel++;
        currentScore -= 1000;
        }
        
    //ラベル表示
    monsterLvLabel.text = [NSString stringWithFormat:@"Lv %d", monsterLevel];
    scoreLabel.text = [NSString stringWithFormat:@"%d", currentScore];
    monsterLvLabel.text = [NSString stringWithFormat:@"Lv %d", monsterLevel];
    nextLevel = 1000 - currentScore;
    nextLvLabel.text = [NSString stringWithFormat:@"%d", nextLevel];
    
    //初めのモンスタービューの表示
    monsterView = [UIImageView new];
    monsterView.image =[UIImage imageNamed:@"クリオロ2.png"];
    monsterView.frame = CGRectMake(30, 100, 95, 95);
    [self.view addSubview:monsterView];
    [self.view bringSubviewToFront:monsterView];
    
    //モンスターアニメーション
    animationTimer= [NSTimer scheduledTimerWithTimeInterval:0.05
                                       target:self
                                     selector:@selector(monsterAnimation)
                                     userInfo:nil
                                      repeats:YES];
    AnimationCount = 1;
    goRight = YES;
    countPlus = YES;
    AnimationLoop = 0;
    [self setPictures];

    [self saveMonsterLevel];

}


-(void)loadMonsterLevel
{
    //モンスターレベルと現在のスコア保存
    NSUserDefaults *mLv = [NSUserDefaults standardUserDefaults];
    monsterLevel = (int)[mLv integerForKey:@"モンスターレベル"];
    
    NSUserDefaults *cScore = [NSUserDefaults standardUserDefaults];
    currentScore = (int)[cScore integerForKey:@"現在のスコア"];

    }

-(void)setPictures
{
    // アニメーション用画像を配列にセット
    imageArray = [NSMutableArray new];
    fimageArray = [NSMutableArray new];
    
    img = [UIImageView new];
    fimg = [UIImageView new];
    
    for (int i = 2; i < 11; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"クリオロ%d.png", i];
        img.image = [UIImage imageNamed:imagePath];
        [imageArray addObject:img];
    }
    for (int i = 2; i < 11; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"クリオロ%df.png", i];
        img.image = [UIImage imageNamed:imagePath];
        [fimageArray addObject:img];
    }

}

-(void)monsterAnimation
{
    
    [monsterView removeFromSuperview];

    //AnimationCountが2〜8でループする仕組み
    if (AnimationCount == 8){
        countPlus = NO;
    }

    if (AnimationCount == 2) {
        countPlus = YES;
    }
    
    if (countPlus==YES && AnimationCount<=10){
        AnimationCount++;
    }
    if (countPlus==NO && AnimationCount>1){
        AnimationCount--;
    }
    
    //アニメーションループが0〜33でループする仕組み
    if (AnimationLoop == 33) {
        goRight = NO;
        AnimationLoop--;
    }
    if (AnimationLoop == 0) {
        goRight = YES;
    }
    
    if (AnimationLoop <34 && goRight == YES) {
        AnimationLoop++;
    }
    if (AnimationLoop >0 && goRight== NO) {
        AnimationLoop--;
    }


        positionX = 30+5*AnimationLoop;
    
    //When the monster is going LEFT
    if(goRight == NO){
        monsterView = imageArray[AnimationCount];
        NSString *name = [NSString stringWithFormat: @"クリオロ%d.png", AnimationCount];
        monsterView.image = [UIImage imageNamed:name];

    //When the moster is going RIGHT
    }else{
        monsterView = fimageArray[AnimationCount];
        NSString *name = [NSString stringWithFormat: @"クリオロ%df.png", AnimationCount];
        monsterView.image = [UIImage imageNamed:name];

    }
   // NSLog(@" AnimationCount = %d", AnimationCount);
   // NSLog(@"AnimationLoop = %d", AnimationLoop);
    monsterView.frame = CGRectMake(positionX, 97, 95, 95);
    [self.view addSubview:monsterView];
    [self.view bringSubviewToFront:monsterView];

}


-(void)saveMonsterLevel
{
    //モンスターレベル永続化
    NSUserDefaults *mLv = [NSUserDefaults standardUserDefaults];
    [mLv setInteger:monsterLevel forKey:@"モンスターレベル"];
    [mLv synchronize];
    
    //現在のスコアの永続化
    NSUserDefaults *cScore = [NSUserDefaults standardUserDefaults];
    [cScore setInteger:currentScore forKey:@"現在のスコア"];
    [cScore synchronize];
}


-(IBAction)moveToGame1:(id)sender
{
    [self performSegueWithIdentifier:@"BackToGame1" sender:self];
}

-(IBAction)moveToGame2:(id)sender
{
    [self performSegueWithIdentifier:@"BackToGame2" sender:self];
}

-(IBAction)moveToGame3:(id)sender
{
    [self performSegueWithIdentifier:@"BackToGame3" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
