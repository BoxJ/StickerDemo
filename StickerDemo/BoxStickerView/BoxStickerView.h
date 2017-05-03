//
//  BoxStickerView.h
//  StickerDemo
//
//  Created by jingliang on 2017/5/3.
//  Copyright © 2017年 井良. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StickerHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BoxControlItemWidth 25.0
#define BoxControlItemHalfWidth 12.5

#define BoxMinScale 0.5f
#define BoxMaxScale 3.0f

@protocol BoxStickerViewDelegate;

@interface BoxStickerView : UIView
@property (assign, nonatomic) BOOL enabledControl;
@property (assign, nonatomic) BOOL enabledDeleteControl;
@property (assign, nonatomic) BOOL enabledBorder;
@property (strong, nonatomic) UIImage *contentImage;
@property (assign, nonatomic) id<BoxStickerViewDelegate> delegate;

- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage;
- (instancetype)initWithContentFrame:(CGRect)frame contentImageUrl:(NSString *)contentImageUrl;
@end

@protocol BoxStickerViewDelegate <NSObject>
@optional
- (void)stickerViewDidTapContentView:(BoxStickerView *)stickerView;
- (void)stickerViewDidTapDeleteControl:(BoxStickerView *)stickerView;
@end
