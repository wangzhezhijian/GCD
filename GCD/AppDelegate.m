//
//  AppDelegate.m
//  GCD
//
//  Created by qianfeng on 15-3-4.
//  Copyright (c) 2015年 史晓义. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    /*UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.window addSubview:imgView];
    //初始化主线程队列，操作页面UI控件，串行队列
    _mainQueue = dispatch_get_main_queue();
    //初始化子线程队列,操作网络数据访问，并行队列
    //第一个参数为设置该子线程的优先级
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //调用子线程
    NSURL *url = [NSURL URLWithString:@"http://img.app.d1cm.com/news/img/201312021610065708.jpg"];
    dispatch_async(_queue, ^{
        //编写_queue子线程中需要实现的代码
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        //调用主线程
        dispatch_async(_mainQueue, ^{
            //编写操作UI控件的代码
            imgView.image = image;
            
        });
        
    });*/
    
    _mainQueue = dispatch_get_main_queue();
    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //优先级为设置子线程抢占速度快慢的参数
    _queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    //[self funcOne];
    //[self funcTwo];
    //[self funcThree];
    //[self funcFour];
    //[self funcFive];
    [self funcSix];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)funcSix
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self doStomeThing:@"A"];
    });
}


//在程序的生命周期中，只会运行一次
- (void)funcFive
{
    //对象从创建到销毁叫做一生命周期
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"once");
    });
    //下边的这段代码将无法运行
    dispatch_once(&onceToken, ^{
        NSLog(@"twice");
    });
}

//并发执行队列

//1.创建组 2.设置执行的方法 3.运行组
- (void)funcFour
{
    dispatch_group_t _group = dispatch_group_create();
    //第一个参数为组对象，第二个参数是准备执行方法的对象（子线程），第三个参数为准备执行方法线程的代码段
    dispatch_group_async(_group, _queue, ^{
        [self doStomeThing:@"A"];
    });
    dispatch_group_async(_group, _queue2, ^{
        [self doStomeThing:@"B"];
    });
    //最后执行的方法
    dispatch_group_notify(_group, _queue, ^{
        [self doStomeThing:@"C"];
    });
}

//自定义的队列
- (void)funcThree
{
    //DISPATCH_QUEUE_SERIAL          串行队列
    //DISPATCH_QUEUE_CONCURRENT      并行队列
    dispatch_queue_t _q1 = dispatch_queue_create("q1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(_q1, ^{
        [self doStomeThing:@"A"];
    });
    dispatch_async(_q1, ^{
        [self doStomeThing:@"B"];
    });
    //程序中的分割线
    dispatch_barrier_async(_q1, ^{
        [self doStomeThing:@"barrier"];
    });
    dispatch_async(_q1, ^{
        [self doStomeThing:@"C"];
    });
    dispatch_async(_q1, ^{
        [self doStomeThing:@"D"];
    });
}

//测试串行执行,所以执行的时间为3S
- (void)funcTwo
{
    dispatch_async(_mainQueue, ^{
        [self doStomeThing:@"A"];
    });
    dispatch_async(_mainQueue, ^{
        [self doStomeThing:@"B"];
    });
    dispatch_async(_mainQueue, ^{
        [self doStomeThing:@"C"];
    });
}



//测试子线程并行执行，子线程为抢占模式，因为并行执行所以运行时间为1秒
- (void)funcOne
{
    //调用子线程
    dispatch_async(_queue, ^{
        [self doStomeThing:@"A"];
    });
    dispatch_async(_queue, ^{
        [self doStomeThing:@"B"];
    });
    dispatch_async(_queue, ^{
        [self doStomeThing:@"C"];
    });
}

- (void)doStomeThing:(NSString *)str
{
    [NSThread sleepForTimeInterval:1.0f];
    NSLog(@"%@",str);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
