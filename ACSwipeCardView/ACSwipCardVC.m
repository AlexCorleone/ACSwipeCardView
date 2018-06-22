//
//  ViewController.m
//  ACSwipeCardView
//
//  Created by AlexCorleone on 2018/6/22.
//  Copyright © 2018年 AlexCorleone. All rights reserved.
//

#import "ACSwipCardVC.h"
#import "WQKSwipeCardCenter.h"
#import "WQKSwipeCardView.h"

@interface ACSwipCardVC ()
<WQKSwipeCardCenterDataSource,
WQKSwipeCardCenterDelegate>

@property (nonatomic, strong) WQKSwipeCardCenter *swipeCardCenter;

@end

@implementation ACSwipCardVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%lf -- %lf", kSwipeScreenHeight, kSwipeScreenWidth);
    
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.swipeCardCenter];

}

#pragma mark - setter && getter
- (WQKSwipeCardCenter *)swipeCardCenter
{
    if (!_swipeCardCenter)
    {
        self.swipeCardCenter = [[WQKSwipeCardCenter alloc] initWithFrame:CGRectZero];
        _swipeCardCenter.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        CGFloat swipeWidth = kSwipeScreenWidth * 0.9;
        _swipeCardCenter.bounds = CGRectMake(0, 0, swipeWidth, swipeWidth * 1.5);
        //        _swipeCardCenter.direction =  WQKSwipeCardCenterDirectionLeft;
        //                                    | WQKSwipeCardCenterDirectionRight
        //                                    | WQKSwipeCardCenterDirectionBottom
        //                                    | WQKSwipeCardCenterDirectionTop;
        _swipeCardCenter.swipeCenterDataSource = self;
        _swipeCardCenter.swipeCenterDelegate = self;
        _swipeCardCenter.widthMargin = 10;
        _swipeCardCenter.swipeDataArray = @[@"1", @"2", @"3", @"4", @"5", @"6",
                                            @"7", @"8", @"9", @"10", @"11", @"12"];
    }
    return _swipeCardCenter;
}

#pragma mark - WQKSwipeCardCenterDataSource
- (WQKSwipeCardView *)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewForCenderAtIndex:(NSInteger)index
{
    WQKSwipeCardView *cardView = [WQKSwipeCardView new];
    [cardView.indexLabel setText:_swipeCardCenter.swipeDataArray[index]];
    return cardView;
}

#pragma mark - WQKSwipeCardCenterDelegate
- (void)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewWillDisappear:(WQKSwipeCardView *)cardView atIndex:(NSInteger)index
{
    NSLog(@"----%ld视图将要消失", index);
}

- (void)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewDidDisappear:(WQKSwipeCardView *)cardView atIndex:(NSInteger)index
{
    NSLog(@"----%ld视图已经消失", index);
}
- (void)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter didClickCardView:(WQKSwipeCardView *)cardView atIndex:(NSInteger)index
{
    NSLog(@"%@", swipeCenter.swipeDataArray[index]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
