//
//  ViewController.m
//  TransitionAnimation
//
//  Created by 黄跃奇 on 16/10/27.
//  Copyright © 2016年 yueqi. All rights reserved.
//

#import "ViewController.h"
#import "QLCircleAnimator.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    QLCircleAnimator *_circleAnimator;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //1. 设置展现样式为自定义
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        //2. 设置转场动画代理 - 需要使用一个强引用的成员变量记录
        _circleAnimator = [QLCircleAnimator new];
        self.transitioningDelegate = _circleAnimator;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
