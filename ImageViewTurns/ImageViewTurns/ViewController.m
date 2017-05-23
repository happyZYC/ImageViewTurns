//
//  ViewController.m
//  ImageViewTurns
//
//  Created by 赵永昌 on 2017/5/23.
//  Copyright © 2017年 chengzhen. All rights reserved.
//

#import "ViewController.h"
#import "ImageTurnsView.h"
@interface ViewController ()<ImageTurnsViewDelegate>

@property (nonatomic, strong) ImageTurnsView *turnsImageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ImageTurnsView *turns = [ImageTurnsView turnsViewWithImages:@[@"test1",@"test2",@"test3",@"test4"] andFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    turns.center = self.view.center;
    [self.view addSubview:turns];
}

- (void)setUpImageView:(UIImageView *)imageView withImageUrlStr:(NSString *)urlStr
{
    NSLog(@"加载网路图片");
}
- (void)selectImageInView:(ImageTurnsView *)turnsView atIndex:(NSInteger)index andObj:(id)obj
{
    
}
- (void)turnsView:(ImageTurnsView *)turnsView currentIndex:(NSInteger)index
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
