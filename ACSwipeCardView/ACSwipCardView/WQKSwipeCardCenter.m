//
//  WQKSwipeCardCenter.m
//  OilReading
//
//  Created by AlexCorleone on 2018/6/19.
//  Copyright © 2018年 Magic. All rights reserved.
//

#import "WQKSwipeCardCenter.h"
#import "WQKSwipeCardView.h"

//#define kSwipScreenHeight [UIApplication sharedApplication].keyWindow.bounds.size.height
static NSUInteger cardViewBaseTag = 100010;
@interface WQKSwipeCardCenter ()
<WQKSwipeCardViewDelegate>

@property (nonatomic, strong) NSMutableArray *cardViewArray;

@property (nonatomic, assign) CGPoint originCenter;
@property (nonatomic, assign) CGPoint beginTouchPoint;

@end

@implementation WQKSwipeCardCenter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.widthMargin = 20;
        self.heightMargin = 30;
        self.direction = WQKSwipeCardCenterDirectionLeft | WQKSwipeCardCenterDirectionRight;
        [self setBackgroundColor:UIColor.clearColor];
        [self.layer setCornerRadius:10.];
        [self configSwipeCardSubviews];
    }
    return self;
}

#pragma mark - setter && getter
- (NSMutableArray *)cardViewArray
{
    if (!_cardViewArray)
    {
        self.cardViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cardViewArray;
}

- (void)setSwipeDataArray:(NSArray *)swipeDataArray
{
    _swipeDataArray = swipeDataArray.copy;
    if (self.cardViewArray.count == 0)
    {
        [self initCardViews];
    }
}

#pragma mark - Private Method
- (void)configSwipeCardSubviews
{
    if (self.cardViewArray.count == 0)
    {
        [self initCardViews];
    }
}

- (void)initCardViews
{
    if (self.swipeDataArray.count == 0)
    {
        NSLog(@"数据源为空");
        return ;
    }
    if (!(   self.swipeCenterDataSource
        && [self.swipeCenterDataSource respondsToSelector:@selector(swipeCardCenter:cardViewForCenderAtIndex:)]))
    {
        NSLog(@"未实现dataSource %@方法", NSStringFromSelector(@selector(swipeCardCenter:cardViewForCenderAtIndex:)));
        return;
    }
    for (NSInteger i = _swipeDataArray.count - 1; i >= 0; i--)
    {
        WQKSwipeCardView *cardView = [self.swipeCenterDataSource swipeCardCenter:self cardViewForCenderAtIndex:i];
        cardView.swipeViewDelegate = self;
        [self addSubview:cardView];
        CGFloat centerX = self.frame.size.width / 2.;
        CGFloat centerY = self.frame.size.height / 2.;
        CGFloat cardViewHeight = self.bounds.size.height - self.heightMargin * 2.;
        CGFloat selfWidth = self.bounds.size.width;
        if (i >= 2)
        {
            cardView.bounds = CGRectMake(0, 0, selfWidth - self.widthMargin * 2. - 20 * 2, cardViewHeight);
            cardView.center = CGPointMake(centerX, centerY + 20);
        }else if(i == 1)
        {
            cardView.bounds = CGRectMake(0, 0, selfWidth - self.widthMargin * 2. - 20, cardViewHeight);
            cardView.center = CGPointMake(centerX, centerY + 10);
        }else if(i == 0)
        {
            cardView.bounds = CGRectMake(0, 0, selfWidth - self.widthMargin * 2. , cardViewHeight);
            cardView.center = CGPointMake(centerX, centerY);
        }
        cardView.tag = cardViewBaseTag + i;
        [cardView configSwipeCardSubviewsSizeWithViewSize:cardView.bounds.size];
        [self.cardViewArray addObject:cardView];
        [self addSubview:cardView];
    }
}

- (void)dealSwipCardDidEndWithCardView:(WQKSwipeCardView *)cardView beginPoint:(CGPoint)beginPoint EndPoint:(CGPoint)statueEndPoint
{
    CGFloat Xdistance = statueEndPoint.x - beginPoint.x;
    CGFloat Ydistance = statueEndPoint.y - beginPoint.y;
    if (self.direction == (WQKSwipeCardCenterDirectionLeft | WQKSwipeCardCenterDirectionRight))
    {//支持左右
        Xdistance = Xdistance > 0 ? Xdistance : -1 * Xdistance;
        [self isShouldFadeWithFadeFlag:(Xdistance > fadeCoefficient) widthCardView:cardView];
    }else if (self.direction
              == (  WQKSwipeCardCenterDirectionTop
                 | WQKSwipeCardCenterDirectionBottom))
    {//支持上下
        Ydistance = Ydistance > 0 ? Ydistance : -1 * Ydistance;
        [self isShouldFadeWithFadeFlag:(Ydistance > fadeCoefficient) widthCardView:cardView];
    }else if (self.direction
              == (  WQKSwipeCardCenterDirectionTop
                  | WQKSwipeCardCenterDirectionBottom
                  | WQKSwipeCardCenterDirectionLeft
                  | WQKSwipeCardCenterDirectionRight))
    {//支持上下左右
        Xdistance = Xdistance > 0 ? Xdistance : -1 * Xdistance;
        Ydistance = Ydistance > 0 ? Ydistance : -1 * Ydistance;
        [self isShouldFadeWithFadeFlag:(Ydistance > fadeCoefficient || Xdistance > fadeCoefficient) widthCardView:cardView];
    }else if (self.direction == WQKSwipeCardCenterDirectionTop)
    {//支持上
        [self isShouldFadeWithFadeFlag:(Ydistance < fadeCoefficient * -1) widthCardView:cardView];
    }else if (self.direction == WQKSwipeCardCenterDirectionBottom)
    {//支持下
        [self isShouldFadeWithFadeFlag:(Ydistance > fadeCoefficient) widthCardView:cardView];
    }else if (self.direction == WQKSwipeCardCenterDirectionLeft)
    {//支持左
        [self isShouldFadeWithFadeFlag:(Xdistance < fadeCoefficient * -1) widthCardView:cardView];
    }else if (self.direction == WQKSwipeCardCenterDirectionRight)
    {//支持右
        [self isShouldFadeWithFadeFlag:(Xdistance > fadeCoefficient) widthCardView:cardView];
    }else
    {
        [self fadeBackWithCardView:cardView];
    }
}

- (void)isShouldFadeWithFadeFlag:(BOOL)isShouldFade widthCardView:(WQKSwipeCardView *)cardView
{
    if (isShouldFade)
    {
        if (   self.swipeCenterDelegate
            && [self.swipeCenterDelegate respondsToSelector:@selector(swipeCardCenter:cardViewWillDisappear:atIndex:)])
        {//cardView将要消失
            [self.swipeCenterDelegate swipeCardCenter:self cardViewWillDisappear:cardView atIndex:cardView.tag - cardViewBaseTag];
        }
        [self fadeDisappeareWith:cardView];
    }else
    {
        [self fadeBackWithCardView:cardView];
    }
}
/*滑动距离小于 fadeCoefficient 返回到起始位置*/
- (void)fadeBackWithCardView:(WQKSwipeCardView *)cardView
{
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cardView.center = self.originCenter;
    } completion:^(BOOL finished) {
        
    }];
}

/*滑动距离大于 fadeCoefficient 先做移除动画 后坐数据更新*/
- (void)fadeDisappeareWith:(WQKSwipeCardView *)cardView
{
    CGPoint beginCenter = [self convertPoint:self.originCenter toView:[UIApplication sharedApplication].keyWindow];
    CGPoint endCenter   = [self convertPoint:cardView.center toView:[UIApplication sharedApplication].keyWindow];
//    NSLog(@"%@== %@",NSStringFromCGPoint(beginCenter), NSStringFromCGPoint(endCenter));
//    NSLog(@"%lf -- %lf", kScreenWidth, kScreenHeight);
    CGFloat animationEndX = 0, animationEndY = 0;
    CGFloat ratio = (endCenter.y - beginCenter.y) / (endCenter.x - beginCenter.x);
    NSLog(@"ratio: %lf", ratio);
    if (endCenter.x - beginCenter.x == 0)
    {
        return;
    }
    if (ratio > 1 || ratio < -1)
    {/*Y固定计算X*/
        if (beginCenter.x < endCenter.x && beginCenter.y > endCenter.y)
        {//右上方
            CGFloat tempHeight = (kSwipeScreenHeight + cardView.bounds.size.height) / 2.;
            animationEndY = -1 * (tempHeight);
            animationEndX = (-1 * tempHeight / ratio + beginCenter.x);
            
        }else if (beginCenter.x < endCenter.x && beginCenter.y < endCenter.y)
        {//右下方
            CGFloat tempHeight = (kSwipeScreenHeight + cardView.bounds.size.height) / 2.;
            animationEndY = (tempHeight + beginCenter.y);
            animationEndX = (animationEndY / ratio);
        }else if (beginCenter.x > endCenter.x && beginCenter.y > endCenter.y)
        {//左上方
            CGFloat tempHeight = (kSwipeScreenHeight + cardView.bounds.size.height) / 2.;
            animationEndY = -1 * (tempHeight);
            animationEndX = -1 * (tempHeight / ratio + beginCenter.x);
        }else  if (beginCenter.x > endCenter.x && beginCenter.y < endCenter.y)
        {//左下方
            CGFloat tempHeight = (kSwipeScreenHeight + cardView.bounds.size.height) / 2.;
            animationEndY = (tempHeight + beginCenter.y);
            animationEndX = (animationEndY / ratio);
        }
    }else
    {/*X固定计算Y*/
        if (beginCenter.x < endCenter.x && beginCenter.y > endCenter.y)
        {//右上方
            CGFloat tempHeight = (kSwipeScreenHeight + cardView.bounds.size.width) / 2.;
            animationEndX = tempHeight + beginCenter.x;
            animationEndY = -1 * (animationEndX * -1 * ratio) + beginCenter.x;
        }else if (beginCenter.x < endCenter.x && beginCenter.y < endCenter.y)
        {//右下方
            animationEndX = (kSwipeScreenHeight + cardView.bounds.size.width) / 2. + beginCenter.x;
            animationEndY = animationEndX * ratio;
        }else if (beginCenter.x > endCenter.x && beginCenter.y > endCenter.y)
        {//左上方
            animationEndX = -1 * (cardView.bounds.size.width + 0);
            animationEndY = (-1 * animationEndX + beginCenter.x) * ratio;
        }else  if (beginCenter.x > endCenter.x && beginCenter.y < endCenter.y)
        {//左下方
            animationEndX = -1 * (cardView.bounds.size.width + 0);
            animationEndY = -1 * (-1 * animationEndX + beginCenter.x) * ratio;
        }
    }
    NSLog(@"%lf==%lf", animationEndX, animationEndY);
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cardView.center = CGPointMake(animationEndX, animationEndY);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [self dealCardFadeAnimationCompleteWithCardView:cardView];
    }];
}

- (void)dealCardFadeAnimationCompleteWithCardView:(WQKSwipeCardView *)cardView
{
    [self sendSubviewToBack:cardView];
    CGFloat centerX = self.frame.size.width / 2.;
    CGFloat centerY = self.frame.size.height / 2.;
    CGFloat cardViewHeight = self.bounds.size.height - self.heightMargin * 2.;
    CGFloat selfWidth = self.bounds.size.width;
    
    cardView.bounds = CGRectMake(0, 0, selfWidth - self.widthMargin * 2 - 20 * 2., cardViewHeight);
    cardView.center = CGPointMake(centerX, centerY + 20);
    [cardView configSwipeCardSubviewsSizeWithViewSize:cardView.bounds.size];
    
    if (   self.swipeCenterDelegate
        && [self.swipeCenterDelegate respondsToSelector:@selector(swipeCardCenter:cardViewDidDisappear:atIndex:)])
    {//cardView视图已经消失
        [self.swipeCenterDelegate swipeCardCenter:self cardViewDidDisappear:cardView atIndex:cardView.tag - cardViewBaseTag];
    }

    NSInteger sycleTag = (cardView.tag - cardViewBaseTag);
    NSUInteger secondTag = (self.cardViewArray.count - 1) - (sycleTag + 1) % self.cardViewArray.count;
    NSUInteger thirdTag = (self.cardViewArray.count - 1) - (sycleTag + 2) % self.cardViewArray.count;
    NSAssert(!((secondTag) > self.cardViewArray.count) , @"视图准备做动画但是出现异常,可能是娶不到视图");
    NSAssert(!((thirdTag) > self.cardViewArray.count) ,  @"视图准备做动画但是出现异常,可能是娶不到视图");
    NSLog(@"%ld -- %ld", secondTag, thirdTag);
    WQKSwipeCardView *secondCardView = self.cardViewArray[secondTag];
    WQKSwipeCardView *thirdCardView = self.cardViewArray[thirdTag];
    NSLog(@"%ld -- %ld", (secondCardView.tag - cardViewBaseTag), (thirdCardView.tag - cardViewBaseTag));
    secondCardView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        secondCardView.center = CGPointMake(centerX, centerY);
        thirdCardView.center = CGPointMake(centerX, centerY + 10);
    }];
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:20 options:UIViewAnimationOptionCurveLinear animations:^{
        secondCardView.bounds = CGRectMake(0, 0, selfWidth - self.widthMargin * 2, cardViewHeight);
        thirdCardView.bounds = CGRectMake(0, 0, selfWidth - self.widthMargin * 2 - 20 , cardViewHeight);
        [secondCardView configSwipeCardSubviewsSizeWithViewSize:secondCardView.bounds.size];
        [thirdCardView configSwipeCardSubviewsSizeWithViewSize:thirdCardView.bounds.size];
    } completion:^(BOOL finished) {
        secondCardView.userInteractionEnabled = YES;
    }];
}

#pragma mark - WQKSwipeCardViewDelegate
- (void)swipeCard:(WQKSwipeCardView *)cardView stateDidBeginWith:(CGPoint)touchPoint
{
    self.originCenter = cardView.center;
    self.beginTouchPoint = [cardView convertPoint:touchPoint toView:self];//这里特别奇怪的是要进行两次坐标转换
}

- (void)swipeCard:(WQKSwipeCardView *)cardView stateDidChangeWith:(CGPoint)changePoint
{
    CGPoint statuePoint = [cardView convertPoint:changePoint toView:self];
    CGPoint beginPoint  = [cardView convertPoint:self.beginTouchPoint toView:self];
    CGPoint centerPoint = [cardView convertPoint:self.originCenter toView:self];
    CGFloat newX = statuePoint.x - beginPoint.x + centerPoint.x;
    CGFloat newY = statuePoint.y - beginPoint.y + centerPoint.y;
    CGPoint newCenter   = CGPointMake(newX , newY);
    [UIView animateWithDuration:0.1 animations:^{
        cardView.center = newCenter;
    }];
}

- (void)swipeCard:(WQKSwipeCardView *)cardView stateDidEndWith:(CGPoint)endPoint
{
    CGPoint tempEndPoint = [cardView convertPoint:endPoint toView:self];
    CGPoint statueEndPoint = [self convertPoint:tempEndPoint toView:[UIApplication sharedApplication].keyWindow];
    CGPoint beginPoint = [self convertPoint:self.beginTouchPoint toView:[UIApplication sharedApplication].keyWindow];
    [self dealSwipCardDidEndWithCardView:cardView beginPoint:beginPoint EndPoint:statueEndPoint];
}

- (void)swipeCardDidClickCardView:(WQKSwipeCardView *)cardView
{
    if (self.swipeCenterDelegate
        && [self.swipeCenterDelegate respondsToSelector:@selector(swipeCardCenter:didClickCardView:atIndex:)])
    {
        [self.swipeCenterDelegate swipeCardCenter:self didClickCardView:cardView atIndex:cardView.tag - cardViewBaseTag];
    }
}

@end
