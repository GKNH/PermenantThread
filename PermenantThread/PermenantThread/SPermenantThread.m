//
//  SPermenantThread.m
//  RunLoopTest
//
//  Created by Sun on 2020/1/14.
//  Copyright © 2020 sun. All rights reserved.
//

#import "SPermenantThread.h"

@interface SThread : NSThread

@end

@implementation SThread

- (void)dealloc {
    NSLog(@"线程结束");
}

@end

@interface SPermenantThread()
// 内部的线程
@property (nonatomic, strong) SThread *innerThread;
// 是否要停止RunLoop的标记
@property (nonatomic, assign) BOOL stopped;

@end

@implementation SPermenantThread

#pragma mark - public methods

- (instancetype)init {
    if (self = [super init]) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        // 创建线程，保活线程
        self.innerThread = [[SThread alloc] initWithBlock:^{
            NSLog(@"RunLoop开始");
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            // self 没有被销毁 并且 标记为NO（不停止RunLoop）
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"RunLoop结束");
        }];
        [self.innerThread start];
    }
    
    return self;
}

// 外界使用这个方法来执行任务
- (void)executeTask:(SPermenantThreadTask)task {
    // 线程不存在或者任务是空的，直接结束
    if (!self.innerThread || !task) return;
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

// 给外界调用，用于销毁线程
- (void)stop {
    // 线程不存在直接结束
    if (!self.innerThread) return;
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

/**
 在SPermenantThread被销毁之前，先销毁线程
 SPermenantThread要被销毁了，所以对于 innerThread 的引用也没有了，按理说innerThread应该被销毁了
 但是因为RunLoop还在存活，所以线程并不会被销毁
 */
- (void)dealloc {
    NSLog(@"SPermenantThread销毁 - %s", __func__);
    [self stop];
}

#pragma mark - private methods

// 内部方法，销毁线程
- (void)__stop {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(SPermenantThreadTask)task {
    task();
}

@end
