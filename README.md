# ImageViewTurns
图片轮播的demo
1.如果需要自定义pageControl,则调用如下方法
+(ImageTurnsView *)turnsViewWithImages:(NSArray *)images andFrame:(CGRect)frame customPageControl:(BOOL)customPageControl

2.如果用系统的pagecontrol,则调用如下方法
+(ImageTurnsView *)turnsViewWithImages:(NSArray *)images andFrame:(CGRect)frame

3./*
 用于获得点击那张图片
 turnsView：返回self
 index：从0开始
 */
-(void)selectImageInView:(ImageTurnsView *)turnsView atIndex:(NSInteger)index andObj:(id)obj;

4. 当前显示索引
-(void)turnsView:(ImageTurnsView *)turnsView currentIndex:(NSInteger)index;

5.不通过网络请求时images为本地图片地址 需要网络请求时images中的值通过代理返回
 （ 代理方法：-(void)setUpImageView:(UIImageView *)imageView withImageUrlStr:(NSString *)urlStr;中urlStr是images中的值 ）
-(void)setImages:(NSArray *)images withNetRequest:(BOOL)netRequest;


注: 
如果加载本地图片 : images 数组为图片的名称
如果加载网络图片 : images 为url
