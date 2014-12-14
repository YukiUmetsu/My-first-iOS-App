//
//  CollisionManager.h
//  GameWithClass
//
//  Created by Yukinaga Azuma on 2014/04/25.
//  Copyright (c) 2014年 Yukinaga Azuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollisionManager : NSObject

-(BOOL)isCollisionOfView:(UIView *)view1
                 andView:(UIView *)view2;

@end
