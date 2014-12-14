//
//  BackGroundImage.m
//  MathPower1
//
//  Created by 梅津優樹 on 2014/09/12.
//  Copyright (c) 2014年 梅津優樹. All rights reserved.
//

#import "BackGroundImage.h"
#import "Game1.h"

@implementation BackGroundImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)moveLeft
{
    if (self.center.x > -1120){
        self.center = CGPointMake(self.center.x-4,self.center.y);
    }
    if (self.center.x <= -1120){
        self.center = CGPointMake(800, self.center.y);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
