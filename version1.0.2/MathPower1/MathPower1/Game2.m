//
//  Game2.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/08/03.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "Game2.h"
#import "AppDelegate.h"
#import "SEManager.h"
#import "BackGroundImage.h"
#import "CollisionManager.h"

@interface Game2 ()
{
    NSTimer *mainTimer;
    NSTimer *subTimer;
    
    int kaisu;
    int time;
    int score;
    int num1, num2, num3, num4;
    int a, b, c, j, yakusuu;
    int rand, rand2, rand3, rand4, rand5;
    int scorePlus;
    
    NSString *kigou;

    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *num1Label;
    IBOutlet UILabel *num2Label;
    IBOutlet UILabel *kigouLabel;
    
    SEManager *koukaonKanri;
    
    UIButton *choiceButton;
    UIButton *answerButton;
    
    NSMutableArray *primeArray;
    NSMutableArray *divideArray;
    
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
    bool upwardAnimationIsON;

    
    //爆弾と衝突関係
    CollisionManager *cManager;
    BackGroundImage *bomb1;
    int bombNumber;
    
    //連続正解回数
    int renzoku;
    
    int scrnHeight;
}
@end

@implementation Game2

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
    
    
    //答えであるnum3をセット
    [self setNum3];
    //問題を用意
    [self problemSetting];
    //選択肢を用意
    [self setChoices];
    
    //ラベルを隠す
    num1Label.hidden = YES;
    num2Label.hidden = YES;
    kigouLabel.hidden = YES;
    
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
            kigouLabel.hidden = NO;
            
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
    if (time<=0) {
        [mainTimer invalidate];
        [subTimer invalidate];
        
        //スコアをDone画面に受け渡し
        AppDelegate *aD2 = [UIApplication sharedApplication].delegate;
        aD2.savedScore2 = &(score);

        //画面切り替え
        [self performSegueWithIdentifier:@"ToDone" sender:self];
    }
}

-(void)problemSetting
{
    [self setValuables];
    [self setLabel];
    
    //爆弾のセット
    [self setBomb];
}

-(void)setLabel
{
    num1Label.text = [[NSString alloc] initWithFormat:@"%d", num1];
    num2Label.text = [[NSString alloc] initWithFormat:@"%d", num2];
    scoreLabel.text = [[NSString alloc] initWithFormat:@"%d", score];
    kigouLabel.text = kigou;
    NSLog(@"問題表示 %d %@ %d", num1, kigou, num2);
}

-(void)setChoices
{
    rand3 = arc4random()%4;
    
    for (int q = 0; q<4; q++){
        
        rand4 =arc4random()%13;
        rand5 =arc4random()%12 + 1;
        
        if ([kigou  isEqual: @"-"]) {
            num4 = rand4 - rand5;
        }
        else if ([kigou  isEqual: @"+"]){
            num4 = rand4 + rand5;
        }
        else if ([kigou  isEqual: @"÷"]){
            num4 = rand4 / rand5;
        }
        else{
            num4 = rand4 * rand5;
        }
        
        //外れになるべきnum4が正解のnum3と同じになるのを防ぐ
        if (num3 == num4) {
            rand4 =arc4random()%13;
            rand5 =arc4random()%12+1;
        }
        
        int previousNum1 = num1;
        int previousNum2 = num2;
        
        //num3(答え)を変えずにnum1&num2を変更するために
         [self setValuables];
        
        //変更後も前のnum1とnum2が変更されない場合は再度[setValuebles]を呼び出す
    
        if(previousNum1 == num1 && previousNum2 == num2){
            [self setValuables];
            NSLog(@"In if setValuables1");
        }
        if(previousNum1 == num1 && previousNum2 == num2){
            [self setValuables];
            NSLog(@"In if setValuables2");
        }
        if(previousNum1 == num1 && previousNum2 == num2){
            [self setValuables];
            NSLog(@"In if setValuables3");
        }
        if(previousNum1 == num1 && previousNum2 == num2){
            [self setValuables];
            NSLog(@"In if setValuables4");
        }
        
        NSString *btnName = [NSString stringWithFormat:@"%d %@ %d", num1,kigou,num2];
        NSString *wrngBtnName = [NSString stringWithFormat:@"%d %@ %d", rand4, kigou, rand5];
        
        if (q == rand3){
            answerButton = [UIButton new];
            if(scrnHeight < 500){
                answerButton.frame = CGRectMake(15+150*(q%2), 320+ 70*(q/2), 140, 58);
            }else{
                answerButton.frame = CGRectMake(15+150*(q%2), 350+ 70*(q/2), 140, 58);
            }
            [answerButton setTitle:btnName  forState:UIControlStateNormal];
            [answerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [answerButton setBackgroundColor:[UIColor greenColor]];
            [answerButton addTarget:self action:@selector(correctAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:answerButton];
          //  NSLog(@"%@",btnName);
            
        }else{
            choiceButton = [UIButton new];
            if(scrnHeight < 500){
                choiceButton.frame = CGRectMake(15+150*(q%2), 320+70*(q/2), 140, 58);
            }else{
                choiceButton.frame = CGRectMake(15+150*(q%2), 350+70*(q/2), 140, 58);
            }
            choiceButton.tag = q+10;
            [choiceButton setTitle:wrngBtnName  forState:UIControlStateNormal];
            [choiceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [choiceButton setBackgroundColor:[UIColor greenColor]];
            [choiceButton addTarget:self action:@selector(wrongAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:choiceButton];
           //  NSLog(@"wrongChoice %@", wrngBtnName);
            NSLog(@"ChoiceButton Name: %ld", (long)choiceButton.tag);
        }
    }
}

-(void)wrongAnswer
{
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
    [bomb1 removeFromSuperview];
    [answerButton removeFromSuperview];
    [choiceButton removeFromSuperview];
    
    //もし爆弾が存在すればビューから取り除く
    if (bombNumber >= 1) {
        [bomb1 removeFromSuperview];
        NSLog(@"Remove Bomb");
        bombNumber = 0;
    }

    
    [koukaonKanri playSound:@"correct.mp3"];
    if (renzoku >= 5) {
        scorePlus = 16;
    }else{
        scorePlus = 8;
    }
    score = score + scorePlus;
    
    //num3(答え)を用意
    [self setNum3];
    //問題を用意
    [self problemSetting];
    //選択肢を用意
    [self setChoices];
    
    //モンスタージャンプ
    [self monsterMoveUpwards];
    //得点スコアの表示
    [self showAddScore];
    //連続回数を+1
    renzoku++;

}

-(void)setNum3
{
    num3 = 6+arc4random()%44;
    divideArray = [[NSMutableArray alloc] init];
    
    NSLog(@"num3 = %d",num3);
    yakusuu = 0;
    for(j=1;j<=num3;j++){
        if(num3%j==0){
            yakusuu++;
            NSLog(@"約数 = %d",j);
            [divideArray addObject:[NSNumber numberWithInt:j]];
        }
    }

}

-(void)setValuables
{
    rand = arc4random()%2;
    rand2 = arc4random()%4;
    a = arc4random()%num3;
    b = 2 + arc4random()%4;
    
    if (yakusuu<=2){
        switch (rand) {
            case 0:
                num1 = num3+a;
                num2 = a;
                kigou = @"-";
                break;
                
            default:
                num1 = num3-a;
                num2 = a;
                kigou = @"+";
                break;
        }
    }else{
        switch (rand2) {
            case 0:
                num1 = num3+a;
                num2 = a;
                kigou = @"-";
                break;
                
            case 1:
                num1 = num3-a;
                num2 = a;
                kigou = @"+";
                break;
                
            case 2:
                num1 = num3*b;
                num2 = b;
                kigou = @"÷";
                break;
                
            default:
                num1 = [[divideArray objectAtIndex:2] intValue];
                num2 = num3/num1;
                kigou = @"×";
                break;
        }
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
    
    if (scorePlus == 8){
        scoorePlusLabel.text = @"+8";
        scoorePlusLabel.textColor = [UIColor redColor];
    }
    else if (scorePlus == -2){
        scoorePlusLabel.text = @"-2";
        scoorePlusLabel.textColor = [UIColor blueColor];
    }
    else if (scorePlus == 16){
        scoorePlusLabel.text = @"+16";
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
        bomb1.frame = CGRectMake(800, 250, 30, 30);
        [self.view addSubview:bomb1];
        [self.view bringSubviewToFront:bomb1];
        bombNumber++;
    }
}

-(void)moveBomb
{
    //爆弾を左に動かす
    [bomb1 moveLeft];
    
    //爆弾が画面外、もしくはモンスターと衝突した場合は削除
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
                         
                         //選択肢ボタン無効化
                         [[self.view viewWithTag:10] setUserInteractionEnabled:NO];
                         [[self.view viewWithTag:11] setUserInteractionEnabled:NO];
                         [[self.view viewWithTag:12] setUserInteractionEnabled:NO];
                         [[self.view viewWithTag:13] setUserInteractionEnabled:NO];
                         [answerButton setEnabled:NO];
                         
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
    [self performSegueWithIdentifier:@"yarinaoshi2" sender:self];
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
