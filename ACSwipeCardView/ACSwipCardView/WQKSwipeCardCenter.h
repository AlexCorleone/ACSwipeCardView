//
//  WQKSwipeCardCenter.h
//  OilReading
//
//  Created by AlexCorleone on 2018/6/19.
//  Copyright © 2018年 Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

/*滑动消失的系数
 */
static CGFloat const fadeCoefficient = 40;

@class WQKSwipeCardView, WQKSwipeCardCenter;

typedef NS_ENUM(NSUInteger, WQKSwipeCardCenterDirection) {
    WQKSwipeCardCenterDirectionLeft = 1 << 0,
    WQKSwipeCardCenterDirectionRight = 1 << 1,
    WQKSwipeCardCenterDirectionTop = 1 << 2,
    WQKSwipeCardCenterDirectionBottom = 1 << 3
};

@protocol WQKSwipeCardCenterDataSource <NSObject>
/*返回一个自定义的 view
 * return WQKSwipeCardView 或者 WQKSwipeCardView 的子类
 */
- (WQKSwipeCardView *)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewForCenderAtIndex:(NSInteger)index;

@end

@protocol WQKSwipeCardCenterDelegate <NSObject>

@optional
/*滑动视图将要消失*/
- (void)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewWillDisappear:(WQKSwipeCardView *)cardView atIndex:(NSInteger)index;
/*滑动视图已经消失*/
- (void)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewDidDisappear:(WQKSwipeCardView *)cardView atIndex:(NSInteger)index;
/*点击了视图回调*/
- (void)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter didClickCardView:(WQKSwipeCardView *)cardView atIndex:(NSInteger)index;

@end

@interface WQKSwipeCardCenter : UIView

@property (nonatomic, copy) NSArray *swipeDataArray;
/*滑动支持的方向 default Left & Right
 * 目前支持 左右、上下、和上下左右三种情况。
 */
@property (nonatomic, assign) WQKSwipeCardCenterDirection direction;
@property (nonatomic, weak) id <WQKSwipeCardCenterDataSource> swipeCenterDataSource;
@property (nonatomic, weak) id <WQKSwipeCardCenterDelegate> swipeCenterDelegate;

/*左右两边的间距
 */
@property (nonatomic, assign) CGFloat widthMargin;
/*顶部和底部的间距*/
@property (nonatomic, assign) CGFloat heightMargin;

@end
