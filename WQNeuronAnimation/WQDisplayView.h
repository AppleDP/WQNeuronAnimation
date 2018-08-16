//
//  WQDisplayView.h
//  WQNeuronAnimation
//
//  Created by iOS on 2018/8/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface WQDisplayView : UIView
/** 动画状态 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

/**
 * 初始化显示图
 *
 * @param frame View 位置
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 添加神经元
 *
 * @param neurons 神经元数组
 * @param color 神经线颜色
 */
- (void)addNeurons:(NSArray<UIView *> *)neurons
        neverColor:(UIColor *)color;
/**
 * 开始动画
 */
- (void)startAnimation;

/**
 * 关闭动画
 */
- (void)stopAnimation;
@end
NS_ASSUME_NONNULL_END
