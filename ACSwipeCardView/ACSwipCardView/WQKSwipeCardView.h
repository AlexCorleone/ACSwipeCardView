//
//  WQKSwipeCardView.h
//  OilReading
//
//  Created by AlexCorleone on 2018/6/19.
//  Copyright © 2018年 Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSwipeScreenWidth [UIScreen mainScreen].bounds.size.width
#define kSwipeScreenHeight [UIScreen mainScreen].bounds.size.height

@class WQKSwipeCardView;
@protocol WQKSwipeCardViewDelegate <NSObject>

- (void)swipeCard:(WQKSwipeCardView *)cardView stateDidBeginWith:(CGPoint)touchPoint;
- (void)swipeCard:(WQKSwipeCardView *)cardView stateDidChangeWith:(CGPoint)changePoint;
- (void)swipeCard:(WQKSwipeCardView *)cardView stateDidEndWith:(CGPoint)endPoint;
- (void)swipeCardDidClickCardView:(WQKSwipeCardView *)cardView;

@end

@interface WQKSwipeCardView : UIView

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, weak) id <WQKSwipeCardViewDelegate> swipeViewDelegate;

- (void)configSwipeCardSubviewsSizeWithViewSize:(CGSize)viewSize;

@end
