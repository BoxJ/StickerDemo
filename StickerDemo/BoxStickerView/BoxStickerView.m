//
//  BoxStickerView.m
//  StickerDemo
//
//  Created by jingliang on 2017/5/3.
//  Copyright © 2017年 井良. All rights reserved.
//

#import "BoxStickerView.h"

#import "UIImageView+WebCache.h"
#import "BoxStickerRecognizer.h"

@interface BoxStickerView () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *contentView;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *resizeControl;
@property (strong, nonatomic) UIImageView *rightTopControl;
@property (strong, nonatomic) UIImageView *leftBottomControl;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (assign, nonatomic) BOOL enableRightTopControl;
@property (assign, nonatomic) BOOL enableLeftBottomControl;

@end

@implementation BoxStickerView

#pragma mark - Initial

- (instancetype)initWithContentFrame:(CGRect)frame contentImage:(UIImage *)contentImage {
    self = [super initWithFrame:CGRectMake(frame.origin.x - BoxControlItemHalfWidth, frame.origin.y - BoxControlItemHalfWidth, frame.size.width + BoxControlItemWidth, frame.size.height + BoxControlItemWidth)];
    if (self) {
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(BoxControlItemHalfWidth, BoxControlItemHalfWidth, frame.size.width, frame.size.height)];
        self.contentImage = contentImage;
        [self addSubview:self.contentView];
        
        self.resizeControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y + self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.resizeControl.backgroundColor=[UIColor whiteColor];
        self.resizeControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.resizeControl.layer.masksToBounds=YES;
        self.resizeControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_resize.png"];
        self.resizeControl.layer.borderWidth=1.0;
        self.resizeControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.resizeControl];
        
        self.deleteControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y - self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.deleteControl.backgroundColor=[UIColor whiteColor];
        self.deleteControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.deleteControl.layer.masksToBounds=YES;
        self.deleteControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_delete.png"];
        self.deleteControl.layer.borderWidth=1.0;
        self.deleteControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.deleteControl];
        
        self.rightTopControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y - self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.rightTopControl.backgroundColor=[UIColor whiteColor];
        self.rightTopControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.rightTopControl.layer.masksToBounds=YES;
        self.rightTopControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_flip.png"];
        self.rightTopControl.layer.borderWidth=1.0;
        self.rightTopControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.rightTopControl];
        
        self.leftBottomControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y + self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.leftBottomControl.backgroundColor=[UIColor whiteColor];
        self.leftBottomControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.leftBottomControl.layer.masksToBounds=YES;
        self.leftBottomControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_resetCenter.png"];
        self.leftBottomControl.layer.borderWidth=1.0;
        self.leftBottomControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.leftBottomControl];
        
        [self initShapeLayer];
        [self setupConfig];
        [self attachGestures];
    }
    return self;
}

- (instancetype)initWithContentFrame:(CGRect)frame contentImageUrl:(NSString *)contentImageUrl
{
    self = [super initWithFrame:CGRectMake(frame.origin.x - BoxControlItemHalfWidth, frame.origin.y - BoxControlItemHalfWidth, frame.size.width + BoxControlItemWidth, frame.size.height + BoxControlItemWidth)];
    if (self) {
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(BoxControlItemHalfWidth, BoxControlItemHalfWidth, frame.size.width, frame.size.height)];
        [self.contentView sd_setImageWithURL:[NSURL URLWithString:contentImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _contentImage=image;
        }];
        [self addSubview:self.contentView];
        
        self.resizeControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y + self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.resizeControl.backgroundColor=[UIColor whiteColor];
        self.resizeControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.resizeControl.layer.masksToBounds=YES;
        self.resizeControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_resize.png"];
        self.resizeControl.layer.borderWidth=1.0;
        self.resizeControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.resizeControl];
        
        self.deleteControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y - self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.deleteControl.backgroundColor=[UIColor whiteColor];
        self.deleteControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.deleteControl.layer.masksToBounds=YES;
        self.deleteControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_delete.png"];
        self.deleteControl.layer.borderWidth=1.0;
        self.deleteControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.deleteControl];
        
        self.rightTopControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x + self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y - self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.rightTopControl.backgroundColor=[UIColor whiteColor];
        self.rightTopControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.rightTopControl.layer.masksToBounds=YES;
        self.rightTopControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_flip.png"];
        self.rightTopControl.layer.borderWidth=1.0;
        self.rightTopControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.rightTopControl];
        
        self.leftBottomControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.center.x - self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, self.contentView.center.y + self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, BoxControlItemWidth, BoxControlItemWidth)];
        self.leftBottomControl.backgroundColor=[UIColor whiteColor];
        self.leftBottomControl.layer.cornerRadius=BoxControlItemWidth/2.0;
        self.leftBottomControl.layer.masksToBounds=YES;
        self.leftBottomControl.image = [UIImage imageNamed:@"BoxStickerBundle.bundle/sticker_resetCenter.png"];
        self.leftBottomControl.layer.borderWidth=1.0;
        self.leftBottomControl.layer.borderColor=StickerHexRGB(0x1296db).CGColor;
        [self addSubview:self.leftBottomControl];
        
        [self initShapeLayer];
        [self setupConfig];
        [self attachGestures];
    }
    return self;
}

- (void)initShapeLayer {
    _shapeLayer = [CAShapeLayer layer];
    CGRect shapeRect = self.contentView.frame;
    [_shapeLayer setBounds:shapeRect];
    [_shapeLayer setPosition:CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2)];
    [_shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_shapeLayer setStrokeColor:[StickerHexRGB(0x1296db) CGColor]];
    [_shapeLayer setLineWidth:1.0f];
    [_shapeLayer setLineJoin:kCALineJoinRound];
    _shapeLayer.allowsEdgeAntialiasing = YES;
    [_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, shapeRect);
    [_shapeLayer setPath:path];
    CGPathRelease(path);
}

- (void)setupConfig {
    self.exclusiveTouch = YES;
    
    self.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
    self.resizeControl.userInteractionEnabled = YES;
    self.deleteControl.userInteractionEnabled = YES;
    self.rightTopControl.userInteractionEnabled = YES;
    self.leftBottomControl.userInteractionEnabled = YES;
    
    _enableRightTopControl = YES;
    _enableLeftBottomControl = YES;
    
    self.enabledBorder = YES;
    self.enabledDeleteControl = YES;
    self.enabledControl = YES;
}

- (void)attachGestures {
    // ContentView
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotateGesture setDelegate:self];
    [self.contentView addGestureRecognizer:rotateGesture];
    
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScale:)];
    [pinGesture setDelegate:self];
    [self.contentView addGestureRecognizer:pinGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self.contentView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.contentView addGestureRecognizer:tapRecognizer];
    
    // ResizeControl
    BoxStickerRecognizer *singleHandGesture = [[BoxStickerRecognizer alloc] initWithTarget:self action:@selector(handleSingleHandAction:) anchorView:self.contentView];
    [self.resizeControl addGestureRecognizer:singleHandGesture];
    
    // DeleteControl
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    [self.deleteControl addGestureRecognizer:tapRecognizer2];
    
    // RightTopControl
    UITapGestureRecognizer *tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer3 setNumberOfTapsRequired:1];
    [tapRecognizer3 setDelegate:self];
    [self.rightTopControl addGestureRecognizer:tapRecognizer3];
    
    // LeftBottomControl
    UITapGestureRecognizer *tapRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer4 setNumberOfTapsRequired:1];
    [tapRecognizer4 setDelegate:self];
    [self.leftBottomControl addGestureRecognizer:tapRecognizer4];
}

#pragma mark - Handle Gestures

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (gesture.view == self.contentView) {
        [self handleTapContentView];
    } else if (gesture.view == self.deleteControl) {
        if (_enabledDeleteControl) {
            [self removeFromSuperview];
            if (_delegate && [_delegate respondsToSelector:@selector(stickerViewDidTapDeleteControl:)]) {
                [_delegate stickerViewDidTapDeleteControl:self];
            }
        }
    } else if (gesture.view == self.rightTopControl) {
        UIImageOrientation targetOrientation = (self.contentImage.imageOrientation == UIImageOrientationUp ? UIImageOrientationUpMirrored : UIImageOrientationUp);
        UIImage *invertImage =[UIImage imageWithCGImage:self.contentImage.CGImage scale:1.0 orientation:targetOrientation];
        self.contentImage = invertImage;
    } else if (gesture.view == self.leftBottomControl) {
        [UIView animateWithDuration:0.3 animations:^{
            self.center=self.superview.center;
        }];
    }
}

- (void)handleTapContentView {
    [self.superview bringSubviewToFront:self];
    if (_delegate && [_delegate respondsToSelector:@selector(stickerViewDidTapContentView:)]) {
        [_delegate stickerViewDidTapContentView:self];
    }
}

- (void)handleMove:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:[self superview]];
    // Boundary detection
    CGPoint targetPoint = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    targetPoint.x = MAX(0, targetPoint.x);
    targetPoint.y = MAX(0, targetPoint.y);
    targetPoint.x = MIN(self.superview.bounds.size.width, targetPoint.x);
    targetPoint.y = MIN(self.superview.bounds.size.height, targetPoint.y);
    
    [self setCenter:targetPoint];
    [gesture setTranslation:CGPointZero inView:[self superview]];
}

- (void)handleScale:(UIPinchGestureRecognizer *)gesture {
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.contentView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= BoxMinScale) {
        scale = BoxMinScale / currentScale;
    } else if (scale * currentScale >= BoxMaxScale) {
        scale = BoxMaxScale / currentScale;
    }
    
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
    gesture.scale = 1;
    
    [self relocalControlView];
}

- (void)handleRotate:(UIRotationGestureRecognizer *)gesture {
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation);
    gesture.rotation = 0;
    
    [self relocalControlView];
}

- (void)handleSingleHandAction:(BoxStickerRecognizer *)gesture {
    CGFloat scale = gesture.scale;
    // Scale limit
    CGFloat currentScale = [[self.contentView.layer valueForKeyPath:@"transform.scale"] floatValue];
    if (scale * currentScale <= BoxMinScale) {
        scale = BoxMinScale / currentScale;
    } else if (scale * currentScale >= BoxMaxScale) {
        scale = BoxMaxScale / currentScale;
    }
    
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale);
    self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation);
    [gesture reset];
    
    [self relocalControlView];
}

- (void)relocalControlView {
    CGPoint originalCenter = CGPointApplyAffineTransform(self.contentView.center, CGAffineTransformInvert(self.contentView.transform));
    self.resizeControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.contentView.bounds.size.width / 2.0f, originalCenter.y + self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
    self.deleteControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.contentView.bounds.size.width / 2.0f, originalCenter.y - self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
    self.rightTopControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x + self.contentView.bounds.size.width / 2.0f, originalCenter.y - self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
    self.leftBottomControl.center = CGPointApplyAffineTransform(CGPointMake(originalCenter.x - self.contentView.bounds.size.width / 2.0f, originalCenter.y + self.contentView.bounds.size.height / 2.0f), self.contentView.transform);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Hit Test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || !self.userInteractionEnabled || self.alpha < 0.01) {
        return nil;
    }
    if (_enabledControl) {
        if ([self.resizeControl pointInside:[self convertPoint:point toView:self.resizeControl] withEvent:event]) {
            return self.resizeControl;
        }
        if (_enabledDeleteControl && [self.deleteControl pointInside:[self convertPoint:point toView:self.deleteControl] withEvent:event]) {
            return self.deleteControl;
        }
        if (_enableRightTopControl && [self.rightTopControl pointInside:[self convertPoint:point toView:self.rightTopControl] withEvent:event]) {
            return self.rightTopControl;
        }
        if (_enableLeftBottomControl && [self.leftBottomControl pointInside:[self convertPoint:point toView:self.leftBottomControl] withEvent:event]) {
            return self.leftBottomControl;
        }
    }
    if ([self.contentView pointInside:[self convertPoint:point toView:self.contentView] withEvent:event]) {
        return self.contentView;
    }
    // return nil for other area.
    return nil;
}

#pragma mark - Other

- (void)setEnabledDeleteControl:(BOOL)enabledDeleteControl {
    _enabledDeleteControl = enabledDeleteControl;
    if (_enabledControl && _enabledDeleteControl) {
        self.deleteControl.hidden = NO;
    } else {
        self.deleteControl.hidden = YES;
    }
}

- (void)setEnabledControl:(BOOL)enabledControl {
    _enabledControl = enabledControl;
    self.deleteControl.hidden = _enabledControl ? !_enabledDeleteControl : YES;
    self.resizeControl.hidden = !_enabledControl;
    self.rightTopControl.hidden = !_enabledControl;
    self.leftBottomControl.hidden = !_enabledControl;
}

- (void)setEnabledBorder:(BOOL)enabledBorder {
    _enabledBorder = enabledBorder;
    if (_enabledBorder) {
        [self.contentView.layer addSublayer:self.shapeLayer];
    } else {
        [self.shapeLayer removeFromSuperlayer];
    }
}

- (void)setContentImage:(UIImage *)contentImage {
    _contentImage = contentImage;
    self.contentView.image = _contentImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
