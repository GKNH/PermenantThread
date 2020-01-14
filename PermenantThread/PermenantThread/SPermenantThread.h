//
//  SPermenantThread.h
//  RunLoopTest
//
//  Created by Sun on 2020/1/14.
//  Copyright © 2020 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SPermenantThreadTask)(void);

@interface SPermenantThread : NSObject
/**
 当前子线程中执行任务
 */
- (void)executeTask:(SPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
