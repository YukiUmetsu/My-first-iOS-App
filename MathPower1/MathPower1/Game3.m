//
//  Game3.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/08/03.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "Game3.h"
#import "AppDelegate.h"
#import "SEManager.h"
#import "BackGroundImage.h"
#import "CollisionManager.h"

@interface Game3 ()
{
    NSTimer *mainTimer;
    NSTimer *subTimer;
    
    //kaisu とはボタンを押した回数
    //1回目はボタンの数をnum1にいれる。2回目はボタンの数をnum2に入れる。
    int kaisu;
    
    int time;
    int score;
    int kazu;
    int num1, num2, num3;
    int rand;
    int remainder;
    int btnNumber;
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *num1Label;
    IBOutlet UILabel *num2Label;
    IBOutlet UILabel *kigouLabel;
    IBOutlet UILabel *amariLabel;
    IBOutlet UILabel *remainderLabel;
    
    SEManager *koukaonKanri;
    
    IBOutlet  UIButton *clearButton;
    
    NSMutableArray *numArray;
    NSMutableArray *randArray;
    UIButton *numButton;
    
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

}
@end

@implementation Game3

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

    time = 34;
    score = 0;
    kaisu = 0;
    koukaonKanri = [SEManager new];
    
    num1Label.hidden = YES;
    num2Label.hidden = YES;
    kigouLabel.hidden = YES;
    amariLabel.hidden = YES;
    remainderLabel.hidden = YES;
    
   [self setRemainder];
    [self setArrays];
    
    [self displayArray];
    
    //初めのモンスタービューの表示
    monsterView = [UIImageView new];
    monsterView.image =[UIImage imageNamed:@"クリオロ2f.png"];
    positionY = 200;
    monsterView.frame = CGRectMake(10, positionY, 85, 85);
    [self.view addSubview:monsterView];
    [self.view bringSubviewToFront:monsterView];
    
    AnimationCount = 1;
    countPlus = YES;
    upwardAnimationIsON = NO;
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
        
        time--;
        if (time == 33){
            countDown3.frame = CGRectMake(70,110,180,180);
            countDown3.tag = 33;
            countDown3.image = [UIImage imageNamed:@"3.jpg"];
            [self.view addSubview:countDown3];
        }
        else if (time == 32){
            countDown2.frame = CGRectMake(70,110,180,180);
            countDown2.tag = 32;
            countDown2.image = [UIImage imageNamed:@"2.jpg"];
            [self.view addSubview:countDown2];
        }
        else if (time == 31){
            countDown1.frame = CGRectMake(70,110,180,180);
            countDown1.tag = 31;
            countDown1.image = [UIImage imageNamed:@"1.jpg"];
            [self.view addSubview:countDown1];
        }
        else if (time == 30){
            [[self.view viewWithTag:31] removeFromSuperview];
            [[self.view viewWithTag:32] removeFromSuperview];
            [[self.view viewWithTag:33] removeFromSuperview];
            num1Label.hidden = NO;
            num2Label.hidden = NO;
            kigouLabel.hidden = NO;
            amariLabel.hidden = NO;
            remainderLabel.hidden = NO;

            subTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                        target:self
                                                      selector:@selector(moveBGImage)
                                                      userInfo:nil
                                                       repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer: subTimer forMode:NSDefaultRunLoopMode];

        }
        else if (time <30) {
            timeLabel.text = [[NSString alloc] initWithFormat:@"%d s",time ];
        }
    }
    else if (time<=0) {
        [mainTimer invalidate];
        [subTimer invalidate];
        
        //スコアをDone画面へ受け渡し
        AppDelegate *aD3 = [UIApplication sharedApplication].delegate;
        aD3.savedScore3 = &(score);

        //画面切り替え
        [self performSegueWithIdentifier:@"ToDone" sender:self];
    }
}

-(void)setRemainder
{
    remainder = 1+arc4random()%5;
    remainderLabel.text = [[NSString alloc] initWithFormat:@"%d", remainder];

}


-(IBAction)clearButtonTapped:(id)sender
{
    [self clearKaisu];
}


-(void)setArrays
{
    numArray = [NSMutableArray new];
    randArray = [NSMutableArray new];
    
    for (int j = 0; j < 12; j++) {

        
    //1~12の数字をnumArrayに入れる
    for (int i=1; i < 13 ; i++) {
        [numArray addObject:[NSNumber numberWithInt:i]];
    }
    //randArrayのすべての要素に"A"を入れる
    for (int i=0; i<12; i++) {
        [randArray addObject:@"A"];
    }

    rand = arc4random()%12;
    
    //"A"のところだけを交換する
    //もしrandArrayのランダムな要素が”A”のときは
    if(([[randArray objectAtIndex:rand]  isEqual: @"A"])){
        
        //randArrayのランダムに選ばれた要素とnumArrayの要素（1-12）を交換
        [randArray replaceObjectAtIndex:rand withObject:numArray[j]];
        NSLog(@"replace %d to %@", rand, numArray[j]);
    
    }else{
        //j-1してループ回数を+1して、ループを抜ける
        NSLog(@"continue");
        j--;
        continue;
    }
        //numButtonの設定
//        btnNumber = [[randArray objectAtIndex:j] intValue];
//        NSLog(@"btnNumber = %d", btnNumber);
//        NSString *numButtonTitle = [NSString stringWithFormat: @"%d", btnNumber];
        
        
        
//        btnNumber = [[randArray objectAtIndex:j] intValue];
//        [numButton setTitle:[randArray objectAtIndex:j] forState:UIControlStateNormal];
//        numButton.tag = btnNumber;
//       NSLog(@"%@", randArray[j]);
//        [numButton setFrame:CGRectMake(40+60*(j%4), 295+60*(j/3), 55, 55)];
//        [numButton setTintColor:[UIColor greenColor]];
//        [numButton addTarget:self
//                      action:@selector(buttonTapped)
//                       forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:numButton];
        [self setButton];
    }
}

-(void)setButton
{
    for (int j=0; j<12; j++) {
    numButton = [UIButton new];
    numButton.tag = [[randArray objectAtIndex:j] intValue];
    [numButton setFrame:CGRectMake(34+50*(j%4), 325+50*(j/4), 45, 45)];
    [numButton setTitle:[NSString stringWithFormat:@"%@", randArray[j]] forState:UIControlStateNormal];
    [numButton setBackgroundColor:[UIColor greenColor]];
    [numButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        switch (numButton.tag) {
            case 1:
                [numButton addTarget:self action:@selector(getbtnNumber1) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 2:
                [numButton addTarget:self action:@selector(getbtnNumber2) forControlEvents:UIControlEventTouchUpInside];
                break;
            
            case 3:
                [numButton addTarget:self action:@selector(getbtnNumber3) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 4:
                [numButton addTarget:self action:@selector(getbtnNumber4) forControlEvents:UIControlEventTouchUpInside];
                break;
            
            case 5:
                [numButton addTarget:self action:@selector(getbtnNumber5) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 6:
                [numButton addTarget:self action:@selector(getbtnNumber6) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 7:
                [numButton addTarget:self action:@selector(getbtnNumber7) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 8:
                [numButton addTarget:self action:@selector(getbtnNumber8) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 9:
                [numButton addTarget:self action:@selector(getbtnNumber9) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 10:
                [numButton addTarget:self action:@selector(getbtnNumber10) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            case 11:
                [numButton addTarget:self action:@selector(getbtnNumber11) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                [numButton addTarget:self action:@selector(getbtnNumber12) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
    [self.view addSubview:numButton];
    }
    
    //爆弾のセット
    [self setBomb];
}

//タグ（ボタンに表示する数字）に応じてラベルに
-(void)getbtnNumber1
{
    btnNumber = 1; [self setLabels];
}
-(void)getbtnNumber2
{
    btnNumber = 2; [self setLabels];
}
-(void)getbtnNumber3
{
    btnNumber = 3; [self setLabels];
}
-(void)getbtnNumber4
{
    btnNumber = 4; [self setLabels];
}
-(void)getbtnNumber5
{
    btnNumber = 5; [self setLabels];
}
-(void)getbtnNumber6
{
    btnNumber = 6; [self setLabels];
}
-(void)getbtnNumber7
{
    btnNumber = 7; [self setLabels];
}
-(void)getbtnNumber8
{
    btnNumber = 8; [self setLabels];
}
-(void)getbtnNumber9
{
    btnNumber = 9; [self setLabels];
}
-(void)getbtnNumber10
{
    btnNumber = 10; [self setLabels];
}
-(void)getbtnNumber11
{
    btnNumber = 11; [self setLabels];
}
-(void)getbtnNumber12
{
    btnNumber = 12; [self setLabels];
}


-(void)setLabels
{
    if (kaisu == 0) {
            num1 = btnNumber;
            num1Label.text = [NSString stringWithFormat:@"%d", num1];
          //  num2Label.text = [NSString stringWithFormat:@"%d", 0];
            kaisu++;
        
    }else{
            num2 = btnNumber;
            num2Label.text = [NSString stringWithFormat:@"%d", num2];
        
        //num3（計算結果）をセット
        if (num2 != 0) {
            num3 = num1%num2;
        }else{num3=0;}
        
            if (num3 == remainder){
                [self correctAnswer];
            }else{
                [self wrongAnswer];
            }
    }
    }


-(void)clearKaisu
{
    kaisu = 0;
    num1 = 0;
    num2 = 0;
    num1Label.text = [[NSString alloc] initWithFormat:@"%d", num1];
    num2Label.text = [[NSString alloc] initWithFormat:@"%d", num2];
}

-(void)wrongAnswer
{
    [koukaonKanri playSound:@"wrongAnswer.mp3"];
    renzoku = 0;
    scorePlus = -2;
    score = score + scorePlus;
    time --;
    scoreLabel.text = [[NSString alloc] initWithFormat:@"%d", score];
    timeLabel.text = [[NSString alloc] initWithFormat:@"%d s",time ];
    
    [self showAddScore];
}

-(void)correctAnswer
{
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

    //モンスタージャンプ
    [self monsterMoveUpwards];
    //得点をラベルに表示
    [self showAddScore];
    //連続正解回数を+1
    renzoku++;

    
    [UIView animateWithDuration:1.0
                     animations:^{}
                     completion:^(BOOL finished) {
                         kaisu = 0;
                         num1 = 0;
                         num2 = 0;
                         num1Label.text = [[NSString alloc] initWithFormat:@"%d", num1];
                         num2Label.text = [[NSString alloc] initWithFormat:@"%d", num2];
                         scoreLabel.text = [[NSString alloc] initWithFormat:@"%d", score];
                         [self setRemainder];
                         [self setArrays];
                     }
     ];

    }

-(void)displayArray
{
       NSLog(@"Display randArray");
    for (int i=0; i<12; i++) {
        NSLog(@"randArrayの要素%dのなかみは%@", i,[randArray objectAtIndex:i]);
    }
}

-(void)buttonTapped
{
    NSLog(@"buttonTapped");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    scoorePlusLabel.frame = CGRectMake(275, 64, 30, 30);
    
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
    
    upwardAnimationIsON = YES;
    
    if (upwardAnimationIsON) {
        
        for (int i=0 ; i< 20 ; i++) {
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
        bomb1.frame = CGRectMake(600, 250, 30, 30);
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
    [self performSegueWithIdentifier:@"yarinaoshi3" sender:self];
}
-(void)toDone
{
    //最後の画面に遷移
    [self performSegueWithIdentifier:@"ToDone" sender:self];
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
