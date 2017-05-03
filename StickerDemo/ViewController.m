//
//  ViewController.m
//  StickerDemo
//
//  Created by jingliang on 2017/5/3.
//  Copyright © 2017年 井良. All rights reserved.
//

#import "ViewController.h"
#import "BoxStickerView.h"

@interface ViewController ()<BoxStickerViewDelegate>
@property (strong, nonatomic) BoxStickerView *selectedSticker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor grayColor];
    
    UIImage *image1=[UIImage imageNamed:@"syed.png"];
    BoxStickerView *sticker1 = [[BoxStickerView alloc] initWithContentFrame:CGRectMake(0, 0,image1.size.width/[UIScreen mainScreen].scale, image1.size.height/[UIScreen mainScreen].scale) contentImage:image1];
    sticker1.center = self.view.center;
    sticker1.enabledControl = NO;
    sticker1.enabledBorder = NO;
    sticker1.delegate = self;
    sticker1.tag = 1;
    [self.view addSubview:sticker1];
    
    UIImage *image2=[UIImage imageNamed:@"yiqu.png"];
    
    BoxStickerView *sticker2 = [[BoxStickerView alloc] initWithContentFrame:CGRectMake(0, 0,image2.size.width/[UIScreen mainScreen].scale, image2.size.height/[UIScreen mainScreen].scale) contentImage:image2];
    sticker2.center = self.view.center;
    sticker2.enabledControl = NO;
    sticker2.enabledBorder = NO;
    sticker2.delegate = self;
    sticker2.tag = 2;
    [self.view addSubview:sticker2];

    BoxStickerView *sticker3 = [[BoxStickerView alloc] initWithContentFrame:CGRectMake(0, 0,350.0/[UIScreen mainScreen].scale, 350.0/[UIScreen mainScreen].scale) contentImageUrl:@"http://cache.fotoplace.cc/161220/admin/206F4B0BB1168786078DA6C72CE27351.png"];
    sticker3.center = self.view.center;
    sticker3.enabledControl = NO;
    sticker3.enabledBorder = NO;
    sticker3.delegate = self;
    sticker3.tag = 3;
    [self.view addSubview:sticker3];
    
    BoxStickerView *sticker4 = [[BoxStickerView alloc] initWithContentFrame:CGRectMake(0, 0,450.0/[UIScreen mainScreen].scale, 280.0/[UIScreen mainScreen].scale) contentImageUrl:@"http://cache.fotoplace.cc/170502/admin/511E0CC656E5D6F105B8B01B369651A1.png"];
    sticker4.center = self.view.center;
    sticker4.enabledControl = NO;
    sticker4.enabledBorder = NO;
    sticker4.delegate = self;
    sticker4.tag=4;
    [self.view addSubview:sticker4];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapGesture
{
    if (self.selectedSticker) {
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker.enabledControl = NO;
        self.selectedSticker=nil;
    }
}
#pragma mark - StickerViewDelegate
- (void)stickerViewDidTapContentView:(BoxStickerView *)stickerView {
    if (self.selectedSticker) {
        self.selectedSticker.enabledBorder = NO;
        self.selectedSticker.enabledControl = NO;
    }
    self.selectedSticker = stickerView;
    self.selectedSticker.enabledBorder = YES;
    self.selectedSticker.enabledControl = YES;
}

- (void)stickerViewDidTapDeleteControl:(BoxStickerView *)stickerView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
