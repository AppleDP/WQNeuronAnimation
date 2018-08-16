//
//  ViewController.m
//  WQNeuronAnimation
//
//  Created by iOS on 2018/8/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "WQDisplayView.h"
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) WQDisplayView *displayV;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // displayV
    WQDisplayView *displayV = [[WQDisplayView alloc] initWithFrame:CGRectMake(0, 88, 200, 200)];
    displayV.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1.0];
    displayV.center = CGPointMake(self.view.center.x, displayV.center.y);
    [self.view addSubview:displayV];
    self.displayV = displayV;
    
    // neurons
    NSMutableArray<__kindof UIView *> *neurons = [[NSMutableArray alloc] initWithCapacity:10];
    for (int index = 0; index < 5; index ++) {
        CGFloat width = arc4random()%10 + 10;
        UIView *neuron = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        neuron.layer.cornerRadius = width/2.0;
        neuron.backgroundColor = [UIColor lightGrayColor];
        [neurons addObject:neuron];
    }
    [displayV addNeurons:neurons neverColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]];
    
    // startBtn
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake(0, CGRectGetMaxY(displayV.frame) + 10, self.view.frame.size.width, 50);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:141.0/255.0 blue:233.0/255.0 alpha:1.0];
    [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    // stopBtn
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopBtn.frame = CGRectMake(0, CGRectGetMaxY(startBtn.frame) + 10, self.view.frame.size.width, 50);
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    stopBtn.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:31.0/255.0 blue:1.0/255.0 alpha:1.0];
    [stopBtn addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}

- (void)startClick:(UIButton *)sender {
    [self.displayV startAnimation];
}

- (void)stopClick:(UIButton *)sender {
    [self.displayV stopAnimation];
}
@end
