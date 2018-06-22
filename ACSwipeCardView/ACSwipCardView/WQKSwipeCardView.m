//
//  WQKSwipeCardView.m
//  OilReading
//
//  Created by AlexCorleone on 2018/6/19.
//  Copyright © 2018年 Magic. All rights reserved.
//

#import "WQKSwipeCardView.h"

@interface WQKSwipeCardView ()
<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isSwipeAction;

@end

@implementation WQKSwipeCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:UIColor.clearColor];
        [self configSwipCardSubviews];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
        [self addGestureRecognizer:tapGesture];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

#pragma mark - setter && getter

#pragma mark -Public Method
- (void)configSwipeCardSubviewsSizeWithViewSize:(CGSize)viewSize
{
    [_bgImageView setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [_indexLabel setFrame:CGRectMake(20, 30, viewSize.width - 20 * 2, 30)];
    [_centerView setFrame:CGRectMake((viewSize.width - 3) / 2., (viewSize.height - 3) / 2., 3, 3)];
}

#pragma mark - Private Method
- (void)configSwipCardSubviews
{
    self.bgImageView = [UIImageView new];
    [_bgImageView setImage:[UIImage imageNamed:@"资讯卡片背景"]];
    [self addSubview:_bgImageView];
    
    self.indexLabel = [UILabel new];
    [_indexLabel setTextColor:UIColor.purpleColor];
    [_indexLabel setFont:[UIFont systemFontOfSize:15]];
    [_indexLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_indexLabel];
    
    self.centerView = [UIView new];
    _centerView.backgroundColor = UIColor.brownColor;
    [self addSubview:_centerView];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)swipeGestureAction:(UIGestureRecognizer *)gesture
{
    CGPoint currentPoint = [gesture locationInView:self];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            {
                NSLog(@"滑动开始");
                self.isSwipeAction = YES;
                if (   self.swipeViewDelegate
                    && [self.swipeViewDelegate respondsToSelector:@selector(swipeCard:stateDidBeginWith:)])
                {
                    [self.swipeViewDelegate swipeCard:self stateDidBeginWith:currentPoint];
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
            {
                NSLog(@"滑动ing");
                if (   self.swipeViewDelegate
                    && [self.swipeViewDelegate respondsToSelector:@selector(swipeCard:stateDidChangeWith:)])
                {
                    [self.swipeViewDelegate swipeCard:self stateDidChangeWith:currentPoint];
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
            {
                NSLog(@"滑动结束");
                if (self.isSwipeAction)
                {
                    if (   self.swipeViewDelegate
                        && [self.swipeViewDelegate respondsToSelector:@selector(swipeCard:stateDidEndWith:)])
                    {
                        [self.swipeViewDelegate swipeCard:self stateDidEndWith:currentPoint];
                    }
                }else
                {
                    if (   self.swipeViewDelegate
                        && [self.swipeViewDelegate respondsToSelector:@selector(swipeCardDidClickCardView:)])
                    {
                        [self.swipeViewDelegate swipeCardDidClickCardView:self];
                        self.isSwipeAction = NO;
                    }

                }
            }
            break;
        case UIGestureRecognizerStatePossible:
            {
                NSLog(@"滑动未知");
            }
            break;
        case UIGestureRecognizerStateCancelled:
            {
                NSLog(@"滑动取消");
            }
            break;
        case UIGestureRecognizerStateFailed:
            {
                NSLog(@"滑动失败");
            }
            break;
    }
//    NSLog(@"---%@", NSStringFromCGPoint([gesture locationInView:self]));
}

@end
