//
//  BoxStickerRecognizer.h
//  StickerDemo
//
//  Created by jingliang on 2017/5/3.
//  Copyright © 2017年 井良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxStickerRecognizer : UIGestureRecognizer

@property (assign, nonatomic) CGFloat scale;
@property (assign, nonatomic) CGFloat rotation;
- (nonnull instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action anchorView:(nonnull UIView *)anchorView;
- (void)reset;
@end
