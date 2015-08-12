//
//  ViewController.m
//  拼图
//
//  Created by qianfeng on 15/7/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
#define ImageW 100
#define ImageH 100
@property (strong,nonatomic) UIView *moveView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat paddingTop = 50;
    CGFloat imgW = ImageW;
    CGFloat imgH = ImageH;
    CGFloat moveX = 0;
    CGFloat moveY = 0;
    CGFloat clipsBouldWidth = (self.view.frame.size.width-3*imgW)*0.5;
   
    UIImage *bgImage = [UIImage imageNamed:@"king"];
    NSLog(@"%.2f %.2f",bgImage.size.width,bgImage.size.height);
    for (int i=0; i<9; i++) {
        int row = i/3;
        int col = i%3;
        //NSString *imgName = [NSString stringWithFormat:@"pingtu%d",i+1];
        //剪裁图片
        CGFloat imageW = bgImage.size.width/3;
        CGFloat imageH = bgImage.size.height/3;
        CGRect rect = CGRectMake(col*ImageW, row*imageH, imageW, imageH);
        NSLog(@"x= %.2f y=%.2f w=%.2f h = %.2f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        CGImageRef cgimageRef = CGImageCreateWithImageInRect(bgImage.CGImage, rect);
        //UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:cgimageRef]];
        
        CGFloat imgX = clipsBouldWidth + col*imgW;
        CGFloat imgY = paddingTop + row*imgH;
        imageView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        imageView.layer.borderWidth = 2;  //设置layer的border的宽度
        imageView.layer.borderColor = [[UIColor yellowColor] CGColor];
        [self.view addSubview:imageView];
        if (i==8) {
            moveY = CGRectGetMaxY(imageView.frame);
            moveX = imgX;
        }
        //给移动块添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 1;//设置点击次数
        tap.numberOfTouchesRequired = 1;//设置触摸点个数
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
    }
    //添加移动块
    UIView *moveView = [[UIView alloc]initWithFrame:CGRectMake(moveX, moveY, imgW, imgH)];
    moveView.backgroundColor = [UIColor cyanColor];
    
    self.moveView = moveView;
    [self.view addSubview: moveView];
    
    //添加原图
    UIImageView *originImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-200, 150, 150)];
    originImgView.image = [UIImage imageNamed:@"king"];
    [self.view addSubview:originImgView];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;//得到手势的父视图
    //动画交换2块视图的位置
    CGFloat viewX = view.frame.origin.x;
    CGFloat viewY = view.frame.origin.y;
    CGFloat moveViewX = self.moveView.frame.origin.x;
    CGFloat moveViewY = self.moveView.frame.origin.y;
    
    int flag1  = abs((int)((moveViewX - viewX)/100));
    int flag2  = abs((int)((moveViewY - viewY)/100));
    
    if ((viewX == moveViewX && flag2 == 1) ||
        (viewY == moveViewY && flag1 == 1)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint tempCenter = self.moveView.center;
            self.moveView.center = view.center;
            view.center = tempCenter;
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
