# WQNeuronAnimation
立体几何不规则运动动画<br/>

<p align="center">
  <img src="https://raw.githubusercontent.com/AppleDP/WQNeuronAnimation/master/WQNeuronAnimation/Gif/%E5%87%A0%E4%BD%95%E4%B8%8D%E8%A7%84%E5%88%99%E5%8A%A8%E7%94%BB.gif">
</p>

# Usage
## 简单调用
```objective-c
    // displayV
    WQDisplayView *displayV = [[WQDisplayView alloc] initWithFrame:CGRectMake(0, 88, 200, 200)];
    displayV.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1.0];
    displayV.center = CGPointMake(self.view.center.x, displayV.center.y);
    [self.view addSubview:displayV];
    self.displayV = displayV;
    
    // 定义小球大小
    NSMutableArray<__kindof UIView *> *neurons = [[NSMutableArray alloc] initWithCapacity:10];
    for (int index = 0; index < 5; index ++) {
        CGFloat width = arc4random()%10 + 10;
        UIView *neuron = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        neuron.layer.cornerRadius = width/2.0;
        neuron.backgroundColor = [UIColor lightGrayColor];
        [neurons addObject:neuron];
    }
    // 添加小球到视图并定义连线颜色
    [displayV addNeurons:neurons neverColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]];
```
