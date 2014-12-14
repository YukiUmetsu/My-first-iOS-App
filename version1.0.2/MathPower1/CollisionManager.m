//
//  CollisionManager.m
//  GameWithClass
//
//  Created by Yukinaga Azuma on 2014/04/25.
//  Copyright (c) 2014年 Yukinaga Azuma. All rights reserved.
//

#import "CollisionManager.h"

@implementation CollisionManager

-(BOOL)isCollisionOfView:(UIView *)view1
                 andView:(UIView *)view2
{
    double xDistance = fabs(view1.center.x - view2.center.x);
    double yDistance = fabs(view1.center.y - view2.center.y);
    double radius2 = (view1.frame.size.width+
                      view1.frame.size.height+
                      view2.frame.size.width+
                      view2.frame.size.height)/4.0;

    if (xDistance>radius2 || yDistance >radius2) {
        return NO;
    }
    
    double distance = sqrt(xDistance*xDistance+yDistance*yDistance);
    if (distance<=radius2) {
        return YES;
    }else{
        return NO;
    }
}

@end
