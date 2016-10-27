//
//  ViewController.m
//  TransitionAnimation
//
//  Created by 黄跃奇 on 16/10/27.
//  Copyright © 2016年 yueqi. All rights reserved.
//

#import "QLCircleAnimator.h"

@interface QLCircleAnimator() <UIViewControllerAnimatedTransitioning, CAAnimationDelegate>

@end

@implementation QLCircleAnimator {
    //是否展现标记
    BOOL _isPresented;
    
    __weak id <UIViewControllerContextTransitioning> _transitionContext;
}

/**
 告诉控制器谁来提供展现转场动画
 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    _isPresented = YES;
    return self;
}

/**
 告诉控制器谁来解除转场动画
 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    _isPresented = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
/**
 返回动画时长

 @param transitionContext 转场上下文

 @return 动画时长
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.25;
}


/**
 是转场动画最核心的代码 - 由程序员提供自己的动画实现

 @param transitionContext 转场上下文 - 提供转场动画的所有细节
 
 *容器视图
 *转场动画会对展现的控制器‘强’引用
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // 1. 容器视图
    UIView *containerView = [transitionContext containerView];
    
    // 2. 获取目标视图
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *view = _isPresented ? toView : fromView;
    
    // 3. 添加目标视图到容器视图
    if (_isPresented) {
        [containerView addSubview:view];
    }
    
    // 4. 针对view执行动画
    [self circleAnimationWithView:view];
    
    _transitionContext = transitionContext;
}

#pragma mark - CAAnimationDelegate

/**
 监听动画完成

 @param anim 动画
 @param flag 完成
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [_transitionContext completeTransition:YES];
}

#pragma mark - 动画方法
- (void)circleAnimationWithView:(UIView *)view {
    
    // 1. 实例化图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 2. 设置图层属性
    // 路径
    CGFloat redius = 50;
    CGFloat margin = 20;
    CGFloat viewWidth = view.bounds.size.width;
    CGFloat viewHeight = view.bounds.size.height;
    
    // 初始位置
    CGRect rect = CGRectMake(viewWidth - redius - margin, margin, redius, redius);
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    layer.path = beginPath.CGPath;
    
    // 计算对角线
    CGFloat maxRadius = sqrt(viewWidth * viewWidth + viewHeight * viewHeight);
    
    // 结束位置
    CGRect endRect = CGRectInset(rect, -maxRadius, -maxRadius);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    // 3. 设置图层的遮罩
    view.layer.mask = layer;
    
    // 4. 动画
    // 1> 实例化动画对象
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    // 2> 设置动画属性
    anim.duration = [self transitionDuration:_transitionContext];
    if (_isPresented) {
        anim.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
        anim.toValue = (__bridge id _Nullable)(endPath.CGPath);
    } else {
        anim.fromValue = (__bridge id _Nullable)(endPath.CGPath);
        anim.toValue = (__bridge id _Nullable)(beginPath.CGPath);
    }
    
    // 设置向前填充模式
    anim.fillMode = kCAFillModeForwards;
    
    // 完成之后不删除
    anim.removedOnCompletion = NO;
    
    // 设置动画代理
    anim.delegate = self;
    
    // 3> 将动画添加到图层
    [layer addAnimation:anim forKey:nil];
}

@end

