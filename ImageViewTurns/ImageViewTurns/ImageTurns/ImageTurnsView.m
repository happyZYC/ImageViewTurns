//
//  ImageTurnsView.m
//  图片轮播
//
//  Created by gmtx on 15/4/7.
//  Copyright (c) 2015年 gmtx. All rights reserved.
//

#import "ImageTurnsView.h"
#import "JQPageControl.h"

@interface ImageTurnsView()<UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;       //
@property(nonatomic, strong)NSMutableArray *imageViewArray; //存储显示图片的imageView
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)BOOL inTimer;                   //定时器动画滚动时不触发scroll事件
@property(nonatomic, strong)NSArray *result;                //banner图请求结果
@property(nonatomic, assign)NSInteger currentPage;
@end

@implementation ImageTurnsView
#pragma mark 加载pageControl
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];;
        self.layer.masksToBounds = YES;
        //图片切换时间
        self.timeInterval = 4;
        //图片切换速度
        self.speed = 1;
        
        //页数控制器的位置
        self.pageLocate = InCenter;
        //页数控制器每个点占据的大小
        self.pageNodeSpace = 20;
        //页数控制器底部距当前view底部的距离
        self.pageToBottom = 12;
        
        self.imageViewArray = [NSMutableArray array];
        
        self.currentPage = 1;
        //添加scrollView
        CGRect frame = self.bounds;
        //        frame.size.height -= 20;
        self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:self.scrollView];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        //添加页数控制
        [self addSubview:self.pageControl];
        //添加点击手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame customPageControl:(BOOL)customPageControl
{
    if (customPageControl) {
        _pageControl = [[JQPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(72/255.0) green:(203/255.0) blue:(139/255.0) alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(72/255.0) green:(203/255.0) blue:(139/255.0) alpha:1.0];
    }
    return [self initWithFrame:frame];
}

+(ImageTurnsView *)turnsViewWithImages:(NSArray *)images andFrame:(CGRect)frame
{
    ImageTurnsView *view = [[ImageTurnsView alloc]initWithFrame:frame customPageControl:NO];
    //添加图片
    [view addImages:[images mutableCopy]];
    return view;
}

+(ImageTurnsView *)turnsViewWithImages:(NSArray *)images andFrame:(CGRect)frame customPageControl:(BOOL)customPageControl
{
    ImageTurnsView *view = [[ImageTurnsView alloc]initWithFrame:frame customPageControl:customPageControl];
    //添加图片
    [view addImages:[images mutableCopy]];
    return view;
}

#pragma mark layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    //计算页数控制的位置
    CGRect frame = self.pageControl.frame;
    if (self.pageLocate == InCenter) {
        frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
    }
    else if (self.pageLocate == InLeft) {
        frame.origin.x = 0;
    }
    else
    {
        frame.origin.x = self.bounds.size.width - frame.size.width;
    }
    frame.origin.y = self.bounds.size.height - self.pageToBottom - self.pageControl.bounds.size.height;
    self.pageControl.frame = frame;

    if (!self.timer) {
        //开启定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark 定时器方法
-(void)changeImage
{
    float offsetX = self.scrollView.contentOffset.x;
    float width = self.scrollView.frame.size.width;
    [UIView animateWithDuration:self.speed animations:^{
        self.inTimer = YES;
        [self.scrollView setContentOffset:CGPointMake(offsetX + width, 0)];
    } completion:^(BOOL finished) {
        self.inTimer = NO;
        //滑到最后一页时跳到第二页
        if (self.scrollView.contentOffset.x + 1 >= self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            [self.scrollView setContentOffset:CGPointMake(width, 0)];
        }
        //滑到第一页时跳到倒数第二页
        else if (self.scrollView.contentOffset.x <= 1)
        {
            [self.scrollView setContentOffset:CGPointMake(width * (self.imageViewArray.count - 2), 0)];
        }
    }];
}
#pragma mark 添加imageView
-(void)addImages:(NSMutableArray *)images
{
    //设置pageControl
    self.pageControl.numberOfPages = images.count;
    //计算pageControl的宽
    CGRect frame = self.pageControl.frame;
    frame.size.width = images.count * self.pageNodeSpace;
    self.pageControl.frame = frame;
    
    float width = self.scrollView.frame.size.width;
    float height = self.scrollView.frame.size.height;
    //在数组的尾部添加第一张图，在数组的头添加最后一张图
    [images insertObject:[images lastObject] atIndex:0];
    [images addObject:images[1]];
    
    
    [images enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(idx * width, 0, width, height);
        [self.scrollView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }];
    //设置scrollView的内容大小
    self.scrollView.contentSize = CGSizeMake(width * self.imageViewArray.count, height);
    [self.scrollView setContentOffset:CGPointMake(width, 0)];
}
#pragma mark 设置图片
-(void)setImages:(NSArray *)images withNetRequest:(BOOL)netRequest
{
    if (images.count !=0) {
        float width = self.scrollView.frame.size.width;
        float height = self.scrollView.frame.size.height;
        
        NSMutableArray *newImages = [images mutableCopy];
        [newImages insertObject:[newImages lastObject] atIndex:0];
        [newImages addObject:newImages[1]];
        
        NSArray *currentImageViews = [NSArray arrayWithArray:self.imageViewArray];
        if (self.imageViewArray.count < newImages.count) {
            for (int i = 0; i < newImages.count - currentImageViews.count; i++) {
                UIImageView *currentImageView = currentImageViews[i % currentImageViews.count];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:currentImageView.image];
                imageView.frame = CGRectMake((currentImageViews.count + i) * width, 0, width, height);
                [self.scrollView addSubview:imageView];
                [self.imageViewArray addObject:imageView];
            }
        }
        else if (self.imageViewArray.count > newImages.count) {
            for (int i = 0; i < currentImageViews.count - newImages.count; i++) {
                UIImageView *imageView = [self.imageViewArray lastObject];
                [imageView removeFromSuperview];
                [self.imageViewArray removeObject:imageView];
            }
        }
        //设置pageControl
        self.pageControl.numberOfPages = self.imageViewArray.count -2;
        //计算pageControl的宽
        CGRect frame = self.pageControl.frame;
        frame.size.width = (self.imageViewArray.count -2) * self.pageNodeSpace;
        self.pageControl.frame = frame;
        if ([self.pageControl isKindOfClass:[JQPageControl class]]) {
            [(JQPageControl *)self.pageControl resetDotFrame];
        }
        //设置scrollView的内容大小
        self.scrollView.contentSize = CGSizeMake(width * self.imageViewArray.count, height);
        if (netRequest) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(setUpImageView:withImageUrlStr:)]) {
                [self.imageViewArray enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
                    [self.delegate setUpImageView:obj withImageUrlStr:newImages[idx]];
                }];
            }
        }
        else
        {
            [self.imageViewArray enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
                obj.image = [UIImage imageNamed:newImages[idx]];
            }];
        }
    }
    
}
#pragma mark scroll view
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = scrollView.frame.size.width;
    if (!self.inTimer) {
        //滑到最后一页时跳到第二页
        if (scrollView.contentOffset.x + 0.5 >= scrollView.contentSize.width - scrollView.frame.size.width) {
            [scrollView setContentOffset:CGPointMake(width, 0)];
        }
        //滑到第一页时跳到倒数第二页
        else if (scrollView.contentOffset.x <= 1)
        {
            [scrollView setContentOffset:CGPointMake(width * (self.imageViewArray.count - 2), 0)];
        }
    }
    //滑动到第一页和最后一页时控制pageControl的显示
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x < self.bounds.size.width / 2) {
        self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
    }
    else if (scrollView.contentOffset.x >= scrollView.contentSize.width - self.bounds.size.width * 3 / 2)
    {
        self.pageControl.currentPage = 0;
    }
    //不是第一页和最后一页的页数
    else
    {
        self.pageControl.currentPage = (scrollView.contentOffset.x - self.bounds.size.width / 2) / self.bounds.size.width;
    }
    if (self.pageControl.currentPage != self.currentPage) {
        self.currentPage = self.pageControl.currentPage;
        if ([self.delegate respondsToSelector:@selector(turnsView:currentIndex:)]) {
            [self.delegate turnsView:self currentIndex:self.pageControl.currentPage];
        }
    }
}
#pragma mark 手动滑动开始关闭定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark 手动滑动结束开启定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self beginTimer];
}
#pragma mark 点击手势
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSString *str;
    if (self.result && self.result.count != 0) {
        if (self.result[self.pageControl.currentPage][@"detailurl"]) {
            str = self.result[self.pageControl.currentPage][@"detailurl"];
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectImageInView:atIndex:andObj:)]) {
        [self.delegate selectImageInView:self atIndex:self.pageControl.currentPage andObj:str];
    }
}
#pragma mark 开启定时器
-(void)beginTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma mark 关闭定时器
-(void)invalidateTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark 暂停定时器
-(void)pauseTimer
{
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark 开始定时器
-(void)startTimer
{
    [self.timer setFireDate:[NSDate distantPast]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
