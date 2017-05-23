//
//  ImageTurnsView.h
//  图片轮播
//
//  Created by gmtx on 15/4/7.
//  Copyright (c) 2015年 gmtx. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置页数控制器的位置（左，中，右）
typedef enum{
    InLeft,
    InCenter,
    InRight
}PageControlLocation;

@class ImageTurnsView;
@protocol ImageTurnsViewDelegate <NSObject>
@optional
/*
 图片需要网络请求时通过代理设置图片
 本类不从网络请求图片
 */
-(void)setUpImageView:(UIImageView *)imageView withImageUrlStr:(NSString *)urlStr;

/*
 用于获得点击那张图片
 turnsView：返回self
 index：从0开始
 */
-(void)selectImageInView:(ImageTurnsView *)turnsView atIndex:(NSInteger)index andObj:(id)obj;

/*
 当前显示索引
 */
-(void)turnsView:(ImageTurnsView *)turnsView currentIndex:(NSInteger)index;
@end

@interface ImageTurnsView : UIView
//images：本地图片名称
+(ImageTurnsView *)turnsViewWithImages:(NSArray *)images andFrame:(CGRect)frame;

+(ImageTurnsView *)turnsViewWithImages:(NSArray *)images andFrame:(CGRect)frame customPageControl:(BOOL)customPageControl;

/*
 
 不通过网络请求时images为本地图片地址
 需要网络请求时images中的值通过代理返回
 （ 代理方法：-(void)setUpImageView:(UIImageView *)imageView withImageUrlStr:(NSString *)urlStr;中urlStr是images中的值 ）
 
 */
-(void)setImages:(NSArray *)images withNetRequest:(BOOL)netRequest;

//销毁定时器
-(void)invalidateTimer;
//暂停定时器
-(void)pauseTimer;
//开启定时器
-(void)startTimer;

@property(nonatomic, weak)id<ImageTurnsViewDelegate> delegate;

@property(nonatomic, strong)UIPageControl *pageControl;
//设置图片切换时间 默认3秒
@property(nonatomic, assign)CGFloat timeInterval;
//图片切换速度 默认1秒
@property(nonatomic, assign)CGFloat speed;
//页数控制器的位置 默认居中
@property(nonatomic, assign)PageControlLocation pageLocate;
//页数控制器中每页点之间的距离 默认20px
@property(nonatomic, assign)CGFloat pageNodeSpace;
//页数控制器底部距当前view的底部的距离 默认20px
@property(nonatomic, assign)CGFloat pageToBottom;

@end
