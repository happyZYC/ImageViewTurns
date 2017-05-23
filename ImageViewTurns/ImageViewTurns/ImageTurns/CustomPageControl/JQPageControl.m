//
//  JQPageControl.m
//  TestPageControl
//
//  Created by gmtx on 16/10/10.
//  Copyright © 2016年 JQKJ. All rights reserved.
//

#import "JQPageControl.h"

@interface JQPageControl()
@property(nonatomic, assign)NSInteger currentDot;
//每个点的大小
@property(nonatomic, assign)CGSize dotSize;
//当前点的大小
@property(nonatomic, assign)CGSize currentDotSize;
//点之间的间隔
@property(nonatomic, assign)CGFloat dotSpace;
@property(nonatomic, assign)CGFloat sysFirOriginX;
@property(nonatomic, assign)CGFloat sysDotOriginY;

@property(nonatomic, strong)UIView *currentDotView;
@end

@implementation JQPageControl

-(CGSize)dotSize
{
    return CGSizeMake(10, 10);
}

-(CGSize)currentDotSize
{
    return CGSizeMake(14, 14);
}

-(CGFloat)dotSpace
{
    return 1;
}

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void)setCurrentPage:(NSInteger)currentPage
{
    if (self.currentDot == currentPage) {
        return;
    }
    [self currentDotViewScrollToDot:currentPage];
    self.currentDot = currentPage;
}

- (NSInteger)currentPage
{
    return self.currentDot;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setPerDotSize:self.dotSize];
    [self currentDotViewScrollToDot:self.currentDot];
}
#pragma mark 设置长条位置
- (void)currentDotViewScrollToDot:(NSInteger)dot
{
    if (dot < 0 || self.currentDot < 0) {
        return;
    }
    //
    CGFloat bigScale = [self currentDotSize].width / [self dotSize].width;
    if (self.currentDot == dot) {
        if (self.currentDot > self.numberOfPages - 1) {
            self.currentDot = 0;
        }
        UIView *currentView = [self viewWithTag:self.currentDot + 1];
        currentView.layer.transform = CATransform3DMakeScale(bigScale, bigScale, 1.0);
        return;
    }
    //
    UIView *view = [self viewWithTag:dot + 1];
    UIView *currentView = [self viewWithTag:self.currentDot + 1];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.duration = 0.38;
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(bigScale, bigScale, 1)];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    //
    CABasicAnimation *smallAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    smallAnimation.duration = 0.38;
    smallAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    smallAnimation.fillMode = kCAFillModeForwards;
    smallAnimation.removedOnCompletion = NO;
    [currentView.layer addAnimation:smallAnimation forKey:@"smallKeyPath"];
}
#pragma mark 设置每个点的大小
-(void)setPerDotSize:(CGSize)size
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.transform = CATransform3DIdentity;
    }];
    //获得系统设置点的大小和点之间的距离
    UIView *view0 = self.subviews[0];
    if (self.numberOfPages < 2) {
        view0.tag = 1;
        return;
    }
    UIView *view1 = view1 = self.subviews[1];
    view0.backgroundColor = view1.backgroundColor;
    CGSize systemDotSize = view0.frame.size;
    CGFloat systemSpace = view1.frame.origin.x - view0.frame.origin.x - systemDotSize.width;
    //计算第一个点的位置
    CGFloat originX = view0.frame.origin.x - (self.currentDotSize.width - systemDotSize.width + self.dotSpace - systemSpace) * self.numberOfPages * 0.5;
    self.sysFirOriginX = originX;
    //点的y坐标
    CGFloat dotOriginY = view0.frame.origin.y;
    self.sysDotOriginY = dotOriginY;
    
    for (NSInteger dotIndex = 0; dotIndex < self.subviews.count; dotIndex++) {
        UIView *view = self.subviews[dotIndex];
        view.tag = dotIndex + 1;
        view.frame = CGRectMake(originX + (self.currentDotSize.width + self.dotSpace) * dotIndex, dotOriginY, size.width, size.height);
        view.layer.cornerRadius = view.bounds.size.height * 0.5;
        view.layer.masksToBounds = YES;
    }
}

- (UIView *)currentDotView
{
    if (!_currentDotView) {
        UIView *currentDotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 3)];
        currentDotView.backgroundColor = [UIColor whiteColor];
        currentDotView.layer.cornerRadius = [self dotSize].height * 0.5;
        currentDotView.layer.masksToBounds = YES;
        _currentDotView = currentDotView;
    }
    return _currentDotView;
}

- (void)resetDotFrame
{
    if (self.numberOfPages > 1) {
        CGSize size = [self dotSize];
        for (int i = 1; i <= self.numberOfPages; i++) {
            UIView *view = [self viewWithTag:i];
            view.frame = CGRectMake(self.sysFirOriginX + (self.currentDotSize.width + self.dotSpace) * i, self.sysDotOriginY, size.width, size.height);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
