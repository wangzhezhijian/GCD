//
//  AppDelegate.h
//  GCD
//
//  Created by qianfeng on 15-3-4.
//  Copyright (c) 2015年 史晓义. All rights reserved.
//

//GCD grand central dispatch
//iOS4.0后产生的技术
//iOS多线程的三种方式
//1.NSThread 2.NSOperationQueue 3.GCD
//GCD 具有串行队列（单线程）和并行队列 （多线程）
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    //声明两个队列的成员变量
    dispatch_queue_t _mainQueue;
    dispatch_queue_t _queue;
    dispatch_queue_t _queue2;
}

@property (strong, nonatomic) UIWindow *window;

@end
