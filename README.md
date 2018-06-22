# ACSwipeCardView
类似中信书院、探探、实现的滑动卡片效果
使用方法：
   初始化WQKSwipeCardCenter类,指定delegate和datasource,指定支持的滑动方向，设置数据源，
                                                                                                                                                                                      
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
                                            
   准守 WQKSwipeCardCenterDataSource, WQKSwipeCardCenterDelegate协议；实现协议相关的方法。
         
         #pragma mark - WQKSwipeCardCenterDataSource
        - (WQKSwipeCardView *)swipeCardCenter:(WQKSwipeCardCenter *)swipeCenter cardViewForCenderAtIndex:(NSInteger)index
        {//这里返回滑动卡片View可以继承WQKSwipeCardView实现自定义的UI效果
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
        {//视图点击的回调
            NSLog(@"%@", swipeCenter.swipeDataArray[index]);
        }
                                            
                                            
                                            
