
//
//  Game1.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/08/02.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "Game1.h"
#import "SEManager.h"
#import "AppDelegate.h"
#import "BackGroundImage.h"
#import "CollisionManager.h"

@interface Game1 ()
{
    NSTimer *mainTimer;
    NSTimer *subTimer;
    
    int kaisu;
    int time;
    int score;
    int num1, num2, num3, num4;
    int rand;
    int kigou;
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *num1Label;
    IBOutlet UILabel *num2Label;
    IBOutlet UILabel *num3Label;
    IBOutlet UILabel *boxLabel;
    IBOutlet UILabel *equalLabel;
    
    
    SEManager *koukaonKanri;
    
    BackGroundImage *bgImage;
    BackGroundImage *bgImage2;
    
    UIImageView *fimg;
    int AnimationCount;
    int AnimationLoop;
    NSMutableArray *fimageArray;
    UIImageView *monsterView;
    bool goRight;
    bool countPlus;
    int positionY;
    int scorePlus;
    bool upwardAnimationIsON;
    
    //爆弾と衝突関係
    CollisionManager *cManager;
    BackGroundImage *bomb1;
    int bombNumber;

    //連続正解回数
    int renzoku;
    
    NSString *btnName;

    float scrnHeight;
}
@end

@implementation Game1

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
    
    //タイマー設定
   mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(timeCountDown)
                                                        userInfo:nil
                                                         repeats:YES];
    
    
    [[NSRunLoop currentRunLoop] addTimer: mainTimer forMode:NSDefaultRunLoopMode];
    
    
    time = 64;
    score = 0;
    
    koukaonKanri = [SEManager new];
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    scrnHeight = rect.size.height;
    
    //問題設定
    [self problemSetting];

    //選択肢ボタン設置
    [self setChoiceButtons];
    
    //カウントダウン中はラベルを隠す
    num1Label.hidden = YES;
    num2Label.hidden = YES;
    num3Label.hidden = YES;
    boxLabel.hidden = YES;
    equalLabel.hidden = YES;
    
    //初めのモンスタービューの表示
    monsterView = [UIImageView new];
    monsterView.image =[UIImage imageNamed:@"クリオロ2f.png"];
    positionY = 200;
    monsterView.frame = CGRectMake(10, positionY, 85, 85);
    [self.view addSubview:monsterView];
    [self.view bringSubviewToFront:monsterView];
    
    AnimationCount = 1;
    countPlus = YES;
    bombNumber = 0;
    cManager = [CollisionManager new];
    
    //背景を設置
    [self setBgImage];
    
    //モンスターを設置
    [self setPictures];
}




-(void)timeCountDown
{
    
    UIImageView *countDown3 = [UIImageView new];
    UIImageView *countDown2 = [UIImageView new];
    UIImageView *countDown1 = [UIImageView new];
    
    if (time >0) {
        
        //３〜０のカウントダウンを設定
        time--;
        if (time == 63){
            countDown3.frame = CGRectMake(70,110,180,180);
            countDown3.tag = 3;
            countDown3.image = [UIImage imageNamed:@"3.jpg"];
            [self.view addSubview:countDown3];
        }
        else if (time == 62){
            countDown2.frame = CGRectMake(70,110,180,180);
            countDown2.tag = 2;
            countDown2.image = [UIImage imageNamed:@"2.jpg"];
            [self.view addSubview:countDown2];
        }
        else if (time == 61){
            countDown1.frame = CGRectMake(70,110,180,180);
            countDown1.tag = 1;
            countDown1.image = [UIImage imageNamed:@"1.jpg"];
            [self.view addSubview:countDown1];
        }
        else if (time == 60){
            [[self.view viewWithTag:1] removeFromSuperview];
            [[self.view viewWithTag:2] removeFromSuperview];
            [[self.view viewWithTag:3] removeFromSuperview];
            num1Label.hidden = NO;
            num2Label.hidden = NO;
            num3Label.hidden = NO;
            boxLabel.hidden = NO;
            equalLabel.hidden = NO;
            
            subTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                        target:self
                                                      selector:@selector(moveBGImage)
                                                      userInfo:nil
                                                       repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer: subTimer forMode:NSDefaultRunLoopMode];

        }

        else if (time <60) {
            timeLabel.text = [[NSString alloc] initWithFormat:@"%d s",time ];
            
        }
    }
    //タイムアウトになったときの処理
    if (time<=0) {
        [subTimer invalidate];
        [mainTimer invalidate];
        
        //スコアをDone画面に受け渡し
        AppDelegate *aD1 = [UIApplication sharedApplication].delegate;
        aD1.savedScore1 = &(score);
        
        //画面切り替え
        [self performSegueWithIdentifier:@"ToDone" sender:self];
    }
}


-(void)problemSetting
{
    kigou = arc4random()%3;
    
    //ランダムに問題をセットする
    switch (kigou) {
        case 0:
            num1 = arc4random()%12;
            num2 = arc4random()%13;
            num3 = num1 + num2;
            break;
            
        case 1:
            num1 = arc4random()%12;
            num2 = arc4random()%13;
            num3 = num1 * num2;
            break;
            
        case 2:
            num3 = 1+arc4random()%8;
            rand = 2+arc4random()%3;
            num1 = num3*rand;
            num2 = rand;
            break;
            
        default:
            num1 = arc4random()%12;
            num2 = arc4random()%13;
            num3 = num1 - num2;
            break;
    }
    //ラベルのセット
    [self setLabel];
    
    //爆弾のセット
    [self setBomb];
}

-(void)setLabel
{
    //ラベルの設置
    num1Label.text = [[NSString alloc] initWithFormat:@"%d", num1];
    num2Label.text = [[NSString alloc] initWithFormat:@"%d", num2];
    num3Label.text = [[NSString alloc] initWithFormat:@"%d", num3];
    scoreLabel.text = [[NSString alloc] initWithFormat:@"%d", score];
}

-(void)wrongAnswer
{
    //間違ったときの処理
    [koukaonKanri playSound:@"wrongAnswer.mp3"];
    renzoku = 0;
    scorePlus = -2;
    score = score + scorePlus;
    time -=2;
    scoreLabel.text = [[NSString alloc] initWithFormat:@"%d", score];
    timeLabel.text = [[NSString alloc] initWithFormat:@"%d s",time ];
    [self showAddScore];
    
}

-(void)correctAnswer
{
    NSLog(@"Correct Answer");
    [bomb1 removeFromSuperview];
    
    [koukaonKanri playSound:@"correct.mp3"];
    
    if (renzoku >= 5) {
    scorePlus = 10;
    }else{
        scorePlus = 5;
    }
    score = score + scorePlus;
    
    //もし爆弾が存在すればビューから取り除く
    if (bombNumber >= 1) {
        [bomb1 removeFromSuperview];
        NSLog(@"Remove Bomb");
        bombNumber = 0;
    }
    
    //次の問題の表示
    [self problemSetting];
    
    //モンスタージャンプ
    [self monsterMoveUpwards];
    
    //得点スコアの表示
    [self showAddScore];
    
    renzoku++;
    
}

-(void)setChoiceButtons
{
    for (int q = 0; q < 4; q++) {
    
        switch (q) {
            
            case 0:
                btnName = @"÷";
                break;
            
            case 1:
                btnName = @"×";
                break;
                
            case 2:
                btnName = @"＋";
                break;
            
            default:
                btnName = @"-";
                break;
        }


    UIButton *choiceButton;
    choiceButton = [UIButton new];
        if (scrnHeight < 500) {
            choiceButton.frame = CGRectMake(69+105*(q%2), 327+72*(q/2), 78, 60);
        } else {
            choiceButton.frame = CGRectMake(55+120*(q%2), 350+95*(q/2), 90, 70);
        }
    choiceButton.tag = q+4;
    [choiceButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [choiceButton setTitle:btnName  forState:UIControlStateNormal];
    [choiceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [choiceButton setBackgroundColor:[UIColor greenColor]];
    
        switch (q) {
            case 0:
                [choiceButton addTarget:self action:@selector(buttonTappedA:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [choiceButton addTarget:self action:@selector(buttonTappedB:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [choiceButton addTarget:self action:@selector(buttonTappedC:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                [choiceButton addTarget:self action:@selector(buttonTappedD:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        [self.view addSubview:choiceButton];
    }
}

-(void)buttonTappedA:(id)sender
{
    if (num2 ==0)
    {
        [self wrongAnswer];
    }else{
    num4 = num1/num2;
    }
    
    if (num4 == num3){
        [self correctAnswer];
    }else{
        [self wrongAnswer];
    }
}

-(void)buttonTappedB:(id)sender
{
    num4 = num1*num2;
    if (num4 == num3){
        [self correctAnswer];
    }else{
        [self wrongAnswer];
    }
}

-(void)buttonTappedC:(id)sender
{
    num4 = num1+num2;
    if (num4 == num3){
        [self correctAnswer];
    }else{
        [self wrongAnswer];
    }
}

-(void)buttonTappedD:(id)sender
{
    num4 = num1-num2;
    if (num4 == num3){
        [self correctAnswer];
    }else{
        [self wrongAnswer];
    }
}

-(void)setBgImage
{
    bgImage = [BackGroundImage new];
    bgImage.image = [UIImage imageNamed:@"bgimage.png"];
    bgImage.frame = CGRectMake(0, 0, 960, 300);
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    
    bgImage2 = [BackGroundImage new];
    bgImage2.image = [UIImage imageNamed:@"bgimage.png"];
    bgImage2.frame = CGRectMake(960, 0, 960, 300);
    [self.view addSubview:bgImage2];
    [self.view sendSubviewToBack:bgImage2];
    
}

-(void)moveBGImage
{
    //背景の移動 BackGroundImageクラス参照
    [bgImage moveLeft];
    [bgImage2 moveLeft];
    
    //モンスターのアニメーション
    [self monsterAnimation];
    
    [self moveBomb];
    
}

-(void)setPictures
{
    // モンスターアニメーション用画像を配列にセット
    fimageArray = [NSMutableArray new];

    fimg = [UIImageView new];
    

    for (int i = 2; i < 11; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"クリオロ%df.png", i];
        fimg.image = [UIImage imageNamed:imagePath];
        [fimageArray addObject:fimg];
    }
    
}

-(void)monsterAnimation
{
    if (upwardAnimationIsON == NO) {
        
    
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
        
        monsterView = fimageArray[AnimationCount];
        NSString *name = [NSString stringWithFormat: @"クリオロ%df.png", AnimationCount];
        monsterView.image = [UIImage imageNamed:name];
        
    monsterView.frame = CGRectMake(10, positionY, 85, 85);
    [self.view addSubview:monsterView];
    [self.view bringSubviewToFront:monsterView];
    }
}

-(void)showAddScore
{
    //スコア加算時の得点を表示するラベル
    UILabel *scoorePlusLabel = [UILabel new];
    scoorePlusLabel.frame = CGRectMake(265, 64, 30, 30);
    
    if (scorePlus == 5){
        scoorePlusLabel.text = @"+5";
        scoorePlusLabel.textColor = [UIColor redColor];
    }
    else if (scorePlus == -2){
        scoorePlusLabel.text = @"-2";
        scoorePlusLabel.textColor = [UIColor blueColor];
    }
    else if (scorePlus == 10){
        scoorePlusLabel.text = @"+10";
        scoorePlusLabel.textColor = [UIColor yellowColor];
    }
        
    [self.view addSubview:scoorePlusLabel];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         scoorePlusLabel.transform = CGAffineTransformMakeTranslation(0, -15);
                     }
                     completion:^(BOOL finished) {
                         [scoorePlusLabel removeFromSuperview];
                                             }
     ];
}

-(void)monsterMoveUpwards
{
    //モンスターがジャンプするアニメーション
        
    for (int i=0 ; i< 20 ; i++) {
        upwardAnimationIsON = YES;
        
        if (upwardAnimationIsON) {
            
    [UIView animateWithDuration:1.0
                     animations:^{
                         [monsterView removeFromSuperview];
                         positionY = 200 + i*2;
                         monsterView.frame = CGRectMake(10, positionY, 85, 85);
                         [self.view addSubview:monsterView];
                         [self.view bringSubviewToFront:monsterView];
                }
     ];
        if (i == 19) {
            positionY = 200;
            monsterView.frame = CGRectMake(10, positionY, 85, 85);
            [self.view addSubview:monsterView];
            [self.view bringSubviewToFront:monsterView];
        }
    }
    }
    upwardAnimationIsON = NO;
}
-(void)setBomb
{
    //もし爆弾が存在しない場合は爆弾を設置する
    
    if (bombNumber == 0){
    
    bomb1 = [BackGroundImage new];
    bomb1.image = [UIImage imageNamed:@"bomb.png"];
        if (score < 250){
            bomb1.frame = CGRectMake(380, 250, 30, 30);
        }else{
            bomb1.frame = CGRectMake(380 - (score - 250), 250, 30, 30);
        }
    [self.view addSubview:bomb1];
    [self.view bringSubviewToFront:bomb1];
    bombNumber++;
        NSLog(@"Set Bomb");
}
}

-(void)moveBomb
{
    //爆弾を左に動かす
    [bomb1 moveLeft];
    
    //モンスターと衝突した場合は削除
    BOOL isCollision = [cManager isCollisionOfView:bomb1
                                           andView:monsterView];
    
    //爆弾とモンスターが衝突した場合は点数を引いて、爆発を起こす
    if (isCollision){
        [self wrongAnswer];
        [self makeExplosion];
    }

}

-(void)makeExplosion
{
    //サブタイマー停止
    [subTimer invalidate];
    
    UIImageView *explosionImage = [UIImageView new];
    explosionImage.frame = CGRectMake(bomb1.center.x, bomb1.center.y - 20, 60, 60);
    explosionImage.image = [UIImage imageNamed:@"explosion.png"];
    [self.view addSubview:explosionImage];
    [self.view bringSubviewToFront:explosionImage];
    
    //爆発の絵が拡大
    [UIView animateWithDuration:1.0
                     animations:^{
                         explosionImage.transform = CGAffineTransformMakeScale(2.7, 2.7);
                         [koukaonKanri playSound:@"Bomb.mp3"];
                     }
                     completion:^(BOOL finished) {
                         
                         //メインタイマー停止
                         [mainTimer invalidate];
                         
                         //選択しボタン無効
                         [[self.view viewWithTag:4] setUserInteractionEnabled:NO];
                         [[self.view viewWithTag:5] setUserInteractionEnabled:NO];
                         [[self.view viewWithTag:6] setUserInteractionEnabled:NO];
                         [[self.view viewWithTag:7] setUserInteractionEnabled:NO];
                         
                         //スコアをDone画面に受け渡し
                         AppDelegate *aD1 = [UIApplication sharedApplication].delegate;
                         aD1.savedScore1 = &(score);
                         
                         //ボタンを設置
                         [self setDoneButton];
                     }
     ];
}

-(void)setDoneButton
{
    //やり直しボタンが出る
    UIButton *yarinaoshiBtn = [UIButton new];
    yarinaoshiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    yarinaoshiBtn.frame = CGRectMake(115, 130, 100, 30);
    [yarinaoshiBtn setTitle:@"やりなおし" forState:UIControlStateNormal];
    yarinaoshiBtn.backgroundColor = [UIColor blackColor];
    [yarinaoshiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yarinaoshiBtn addTarget:self action:@selector(yarinaoshi)
            forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:yarinaoshiBtn];
    
    //終了ボタンが出る
    UIButton *doneButton = [UIButton new];
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(115, 165, 100, 30);
    [doneButton setTitle:@"終了する" forState:UIControlStateNormal];
    doneButton.backgroundColor = [UIColor blackColor];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(toDone)
            forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:doneButton];
    
}

-(void)yarinaoshi
{
    //前の画面に戻る
    [self performSegueWithIdentifier:@"yarinaoshi" sender:self];
}
-(void)toDone
{
    //最後の画面に遷移
    [self performSegueWithIdentifier:@"ToDone" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
