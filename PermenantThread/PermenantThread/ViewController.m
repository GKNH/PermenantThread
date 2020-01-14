//
//  ViewController.m
//  PermenantThread
//
//  Created by Sun on 2020/1/14.
//  Copyright © 2020 sun. All rights reserved.
//

#import "ViewController.h"
#import "SPermenantThread.h"

@interface ViewController ()
@property (nonatomic, strong) SPermenantThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 线程创建好了，就一直是存活状态
    self.thread = [[SPermenantThread alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 在线程中执行代码
    [self.thread executeTask:^{
        NSLog(@"执行任务 - 在线程：%@", [NSThread currentThread]);
    }];
}

// 停止按钮的方法
- (IBAction)stop {
    [self.thread stop];
}

// 控制器直接销毁即可
// SPermenantThread也会被销毁，SPermenantThread 内部的线程也会销毁
- (void)dealloc {
    NSLog(@"控制器dealloc");
}


@end

