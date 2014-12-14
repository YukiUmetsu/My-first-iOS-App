//
//  SecondViewController.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/08/03.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()
{
    int monsterLevel;
    int currentScore;
    
    IBOutlet UILabel *monsterLevelLabel;
    IBOutlet UILabel *currentScoreLabel;
    
    GADBannerView *bannerView_;
    
    UIImageView *bombpic;
    UIButton *btnToExplanation;
    int scrnHeight;
}

@end

@implementation SecondViewController

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
    
    //画面取得
    UIScreen *sc = [UIScreen mainScreen];
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    scrnHeight = rect.size.height;
    
    [self setPicAndBtn];
    
    [self loadMonsterLevel];
    
    monsterLevelLabel.text = [NSString stringWithFormat:@"モンスターレベル: %d", monsterLevel];
    currentScoreLabel.text = [NSString stringWithFormat:@"スコア: %d", currentScore];
    
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



-(IBAction)buttonTappedA:(id)sender
{
   
}

-(IBAction)buttonTappedB:(id)sender
{

}

-(IBAction)buttonTappedC:(id)sender
{

}

-(void)loadMonsterLevel
{
    //モンスターレベルと現在のスコア保存
    NSUserDefaults *mLv = [NSUserDefaults standardUserDefaults];
    //integerForKeyはLongを返すので、(int)で強制的にint型に直す
    monsterLevel = (int)[mLv integerForKey:@"モンスターレベル"];
    
    NSUserDefaults *cScore = [NSUserDefaults standardUserDefaults];
    currentScore = (int)[cScore integerForKey:@"現在のスコア"];
    
}


-(void)setPicAndBtn
{
    //爆弾の絵を設定
    bombpic = [UIImageView new];
    bombpic.image = [UIImage imageNamed:@"bomb.png"];
    if (scrnHeight < 500){
        bombpic.frame = CGRectMake(33, 373, 49, 42);
    } else {
        bombpic.frame = CGRectMake(33, 435, 49, 42);
    }
    [self.view addSubview:bombpic];
    [self.view bringSubviewToFront:bombpic];
    
    //説明ページへ飛ばすボタンを設置
    btnToExplanation = [UIButton new];
    btnToExplanation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (scrnHeight < 500){
            btnToExplanation.frame = CGRectMake(90, 385, 183, 30);
        } else {
            btnToExplanation.frame = CGRectMake(90, 447, 183, 30);
        }
    [btnToExplanation setTitle:@"説明のページをみる！" forState:UIControlStateNormal];
    [btnToExplanation.titleLabel setFont:[UIFont systemFontOfSize:16]];
    btnToExplanation.backgroundColor = [UIColor purpleColor];
    [btnToExplanation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnToExplanation addTarget:self action:@selector(goToExplanationPage)
            forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnToExplanation];

}

-(void)goToExplanationPage
{
    [self performSegueWithIdentifier:@"toExplanation" sender:self];
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
