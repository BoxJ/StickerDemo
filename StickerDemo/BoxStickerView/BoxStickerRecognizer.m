//
//  BoxStickerRecognizer.m
//  StickerDemo
//
//  Created by jingliang on 2017/5/3.
//  Copyright © 2017年 井良. All rights reserved.
//

#import "BoxStickerRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
@interface BoxStickerRecognizer ()

@property (strong, nonatomic) UIView *anchorView;

@end

@implementation BoxStickerRecognizer

- (nonnull instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action anchorView:(nonnull UIView *)anchorView {
    BoxStickerRecognizer *gesture = [[BoxStickerRecognizer alloc] initWithTarget:target action:action];
    gesture.anchorView = anchorView;
    return gesture;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateChanged;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint anchorViewCenter = self.anchorView.center;
    CGPoint currentPoint = [touch locationInView:self.anchorView.superview];
    CGPoint previousPoint = [touch previousLocationInView:self.anchorView.superview];
    
    CGFloat currentRotation = atan2f((currentPoint.y - anchorViewCenter.y), (currentPoint.x - anchorViewCenter.x));
    CGFloat previousRotation = atan2f((previousPoint.y - anchorViewCenter.y), (previousPoint.x - anchorViewCenter.x));
    
    CGFloat currentRadius = [self distanceBetweenFirstPoint:currentPoint secondPoint:anchorViewCenter];
    CGFloat previousRadius = [self distanceBetweenFirstPoint:previousPoint secondPoint:anchorViewCenter];
    CGFloat scale = currentRadius / previousRadius;
    [self setRotation:(currentRotation - previousRotation)];
    [self setScale:scale];
}

- (CGFloat)distanceBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    self.rotation = 0;
    self.scale = 1;
}
@end
