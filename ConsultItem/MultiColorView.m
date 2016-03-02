//
//  MultiColorView.m
//  XHXCStudent
//
//  Created by 陈峰 on 16/3/1.
//  Copyright © 2016年 liuleting. All rights reserved.
//

#import "MultiColorView.h"

@implementation MultiColorView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setIsMainView:(CGFloat)isMainView {
    _isMainView = isMainView;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, 0);
    CGColorRef mainColor = NULL;
    CGColorRef subColor = NULL;
    if (!_isMainView) {
        mainColor = [UIColor blueColor].CGColor;
        subColor = [UIColor clearColor].CGColor;
    } else {
        subColor = [UIColor blueColor].CGColor;
        mainColor = [UIColor clearColor].CGColor;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (_progress>0) {
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(__bridge id)mainColor,(__bridge id)mainColor], NULL);
        CGPoint startPoint = CGPointMake(rect.origin.x,
                                         0);
        CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width*_progress,
                                       0);
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    startPoint,
                                    endPoint,
                                    _progress==1?kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation : kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(gradient);
    }
    
    if (_progress < 1) {
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(__bridge id)subColor,(__bridge id)subColor], NULL);
        CGPoint startPoint = CGPointMake(rect.origin.x + rect.size.width*_progress,
                                         0);
        CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width,
                                       0);
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    startPoint,
                                    endPoint,
                                    _progress==0?kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation : kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
    
    CGColorSpaceRelease(colorSpace);

}


@end
