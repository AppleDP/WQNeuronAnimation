//
//  WQDisplayView.m
//  UIViewAnimation
//
//  Created by iOS on 2018/8/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WQDisplayView.h"
#import <objc/runtime.h>


@interface UIView (WQNeuron)
/**
 * View Frame
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

/** 神经元移动速度 */
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;
@end


@interface WQNerve : CAShapeLayer
/** 神经线始端 */
@property (nonatomic, weak) UIView *startNeuron;
/** 神经线末端 */
@property (nonatomic, weak) UIView *finishNeuron;
@end


@interface WQDisplayView ()
/** 神经元数组 */
@property (nonatomic, copy) NSArray<UIView *> *neurons;
/** 神经线数组 */
@property (nonatomic, copy) NSArray<WQNerve *> *nerves;
/** 定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 * 取随机值
 *
 * @param min 最小值
 * @param max 最大值
 */
- (CGFloat)randomWithMin:(CGFloat)min max:(CGFloat)max;

/**
 * CADisplayLink 回调实现动画
 */
- (void)displayLinkHandle;
@end


@implementation UIView (WQExtension)
#pragma mark -- View Frame --
- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
-(CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height {
    return self.frame.size.height;
}


#pragma mark -- 神经元偏移速度 --
static const void *offsetXKey = &offsetXKey;
static const void *offsetYKey = &offsetYKey;

- (void)setOffsetX:(CGFloat)offsetX {
    objc_setAssociatedObject(self, offsetXKey, @(offsetX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)offsetX {
    NSNumber *num = objc_getAssociatedObject(self, offsetXKey);
    return [num floatValue];
}

- (void)setOffsetY:(CGFloat)offsetY {
    objc_setAssociatedObject(self, offsetYKey, @(offsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)offsetY {
    NSNumber *num = objc_getAssociatedObject(self, offsetYKey);
    return [num floatValue];
}
@end


@implementation WQNerve
@end


@implementation WQDisplayView
#pragma mark -- 系统方法 --
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandle)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.paused = YES;
    }
    return self;
}

- (void)dealloc {
    if (!self.displayLink.paused) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}


#pragma mark -- 公有方法 --
- (void)addNeurons:(NSArray<UIView *> *)neurons
        neverColor:(UIColor *)color {
    // 移除原神经元
    for (int index = 0; index < self.neurons.count; index ++) {
        UIView *neuron = self.neurons[index];
        [neuron removeFromSuperview];
    }
    // 移除原神经线
    for (int index = 0; self.nerves.count; index ++) {
        WQNerve *nerve = self.nerves[index];
        [nerve removeFromSuperlayer];
    }
    NSInteger neuronCount = neurons.count;
    NSMutableArray<CAShapeLayer *> *nerves = [[NSMutableArray alloc] init];
    for (int i = 0; i < neuronCount; i ++) {
        UIView *ni = neurons[i];
        
        // 初始位置
        ni.x = [self randomWithMin:0 max:self.width - ni.width];
        ni.y = [self randomWithMin:0 max:self.height - ni.height];
        [self addSubview:ni];
        for (int j = i + 1; j < neuronCount; j ++) {
            UIView *nj = neurons[j];
            WQNerve *layer = [WQNerve layer];
            layer.lineWidth = 1.0;
            layer.strokeColor = color.CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.startNeuron = ni;
            layer.finishNeuron = nj;
            [nerves addObject:layer];
            [self.layer addSublayer:layer];
        }
    }
    // 添加新神经元
    self.neurons = [neurons copy];
    
    // 添加新神经线
    self.nerves = [nerves copy];
    
    // 画神经线
    [self drawLine];
}

- (void)startAnimation {
    if (!_isAnimating) {
        _isAnimating = YES;
        for (int index = 0; index < self.neurons.count; index ++) {
            UIView *neuron = self.neurons[index];
            
            // 偏移速度
            neuron.offsetX = [self randomWithMin:-20 max:20]/40;
            neuron.offsetY = [self randomWithMin:-20 max:20]/40;
            [self addSubview:neuron];
        }
        self.displayLink.paused = NO;
    }
}

- (void)stopAnimation {
    if (_isAnimating) {
        _isAnimating = NO;
        self.displayLink.paused = YES;
    }
}


#pragma mark -- 私有方法 --
- (CGFloat)randomWithMin:(CGFloat)min max:(CGFloat)max {
    // 位数精度
    int precision = 100;
    
    // 取最大值与最小值的相差值，+1 是为了防止最大值与最小值相同时差为 0
    int subtraction = ABS(max - min) == 0 ? ABS(max - min)*precision : (ABS(max - min)*precision + 1);
    CGFloat random = arc4random()%subtraction + 1;
    return random/precision + (min < max ? min : max);
}

- (void)displayLinkHandle {
    // 移动动画
    for (int index = 0; index < self.neurons.count; index ++) {
        UIView *neuron = self.neurons[index];
        CGFloat x = neuron.x + neuron.offsetX;
        CGFloat y = neuron.y + neuron.offsetY;
        
        // 边缘碰撞
        if (x > self.width - neuron.width) {
            x = self.width - neuron.width;
            neuron.offsetX = -neuron.offsetX;
        }else if (x < 0) {
            x = 0;
            neuron.offsetX = -neuron.offsetX;
        }
        if (y > self.height - neuron.height) {
            y = self.height - neuron.height;
            neuron.offsetY = -neuron.offsetY;
        }else if (y < 0) {
            y = 0;
            neuron.offsetY = -neuron.offsetY;
        }
        neuron.x = x;
        neuron.y = y;
    }
    // 球体碰撞 (直径相加 < 圆心距离)
    for (int i = 0; i < self.neurons.count; i ++) {
        UIView *ni = self.neurons[i];
        for (int j = i + 1; j < self.neurons.count; j ++) {
            UIView *nj = self.neurons[j];
            CGFloat distance = hypot(fabs(nj.center.x - ni.center.x), fabs(nj.center.y - ni.center.y));
            CGFloat distanceR = ni.width/2.0 + nj.width/2.0;
            if (distance <= distanceR) {
                // 圆心距 < 直径和，两球碰撞
                if (ni.offsetX > 0 && nj.offsetX > 0) {
                    // X 轴正方向相同
                    if (ni.x < nj.x) {
                        // ni 在后，要变方向
                        ni.offsetX = -ni.offsetX;
                    }else {
                        // nj 在后，要变方向
                        nj.offsetX = -nj.offsetX;
                    }
                }else if (ni.offsetX < 0 && nj.offsetX < 0) {
                    // X 轴反方向相同
                    if (ni.x > nj.x) {
                        // ni 在后，要变方向
                        ni.offsetX = -ni.offsetX;
                    }else {
                        // nj 在后，要变方向
                        nj.offsetX = -nj.offsetX;
                    }
                }else {
                    // ni 与 nj 方向相对
                    ni.offsetX = -ni.offsetX;
                    nj.offsetX = -nj.offsetX;
                }
                if (ni.offsetY > 0 && nj.offsetY > 0) {
                    // Y 轴正方向相同
                    if (ni.y < nj.y) {
                        // ni 在后，要变方向
                        ni.offsetY = -ni.offsetY;
                    }else {
                        // nj 在后，要变方向
                        nj.offsetY = -nj.offsetY;
                    }
                }else if (ni.offsetY < 0 && nj.offsetY < 0) {
                    // Y 轴反方向相同
                    if (ni.y > nj.y) {
                        // ni 在后，要变方向
                        ni.offsetY = -ni.offsetY;
                    }else {
                        // nj 在后，要变方向
                        nj.offsetY = -nj.offsetY;
                    }
                }else {
                    // ni 与 nj 方向相对
                    ni.offsetY = -ni.offsetY;
                    nj.offsetY = -nj.offsetY;
                }
            }
        }
    }
    [self drawLine];
}

- (void)drawLine {
    // 画线
    for (int index = 0; index < self.nerves.count; index ++) {
        @autoreleasepool {
            WQNerve *nerve = self.nerves[index];
            UIView *startNeuron = nerve.startNeuron;
            UIView *finishNeuron = nerve.finishNeuron;
            CGPoint startPoint = startNeuron.center;
            CGPoint finishPoint = finishNeuron.center;
            CGMutablePathRef nervePath =  CGPathCreateMutable();
            CGPathMoveToPoint(nervePath, NULL, startPoint.x, startPoint.y);
            CGPathAddLineToPoint(nervePath, NULL, finishPoint.x,finishPoint.y);
            [nerve setPath:nervePath];
            CGPathRelease(nervePath);
        }
    }
}
@end
