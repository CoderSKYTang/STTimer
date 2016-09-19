//
//  ViewController.m
//  STTimer
//
//  Created by 研发部 on 16/9/19.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *beforeDate; // 上次进入后台时间
@property (nonatomic, assign) int countDown;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotification];
    [self startCountDown];
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)startCountDown {
    _countDown = 100;
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerfired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)enterBG {
    NSLog(@"进入后台");
    _beforeDate = [NSDate date];
    [self stopTimer];
}

- (void)enterFG {
    NSLog(@"进入前台");
    NSDate *nowDate = [NSDate date];
    int Interval = (int)ceil([nowDate timeIntervalSinceDate:_beforeDate]);
    int val = _countDown - Interval;
    if (val > 1) {
        _countDown -= Interval;
    } else {
        _countDown = 1;
    }
    [self startTimer];
}

- (void)timerfired:(NSTimer *)timer {
    if (_countDown == 0) {
        [self stopTimer];
        NSLog(@"倒计时完毕!");
    } else {
        _countDown -= 1;
        NSLog(@"正在倒计时: %d", _countDown);
    }
}

- (void)startTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [_timer invalidate];
    _timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
