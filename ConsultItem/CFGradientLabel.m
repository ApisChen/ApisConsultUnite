//
//  TestLabel.m
//  38-文字渐变色-C
//
//  Created by 于 传峰 on 15/7/27.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import "CFGradientLabel.h"

@implementation CFGradientLabel

//- (void)setColors:(NSArray *)colors {
//    _colors = colors;
//    [self setNeedsDisplay];
//}

- (void)setProgress:(CGFloat)progress {
    if (progress>1) {
        _progress = 1;
    } else if (progress<0) {
        _progress = 0;
    } else {
        _progress = progress;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    CGRect textRect = (CGRect){0, 0, textSize.width, textSize.height};
   
    // 画文字(不做显示用 主要作用是设置layer的mask)
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.textColor set];
    [self.text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:NULL];
    
    // 坐标 (只对设置后的画到context起作用 之前画的文字不起作用)
    CGContextTranslateCTM(context, 0.0f, rect.size.height- (rect.size.height - textSize.height)*0.5);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGImageRef alphaMask = NULL;
    alphaMask = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, rect);// 清除之前画的文字

   
     // 设置mask
    CGContextClipToMask(context, rect, alphaMask);
    
    // 画渐变色
    CGColorRef mainColor = NULL;
    CGColorRef subColor = NULL;
    if (!_isMainLabel) {
        mainColor = [UIColor blueColor].CGColor;
        subColor = [UIColor grayColor].CGColor;
    } else {
        subColor = [UIColor blueColor].CGColor;
        mainColor = [UIColor grayColor].CGColor;
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (_progress>0) {
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(__bridge id)mainColor,(__bridge id)mainColor], NULL);
        CGPoint startPoint = CGPointMake(textRect.origin.x,
                                         0);
        CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width*_progress,
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
        CGPoint startPoint = CGPointMake(textRect.origin.x + textRect.size.width*_progress,
                                          0);
        CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width,
                                        0);
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    startPoint,
                                    endPoint,
                                    _progress==0?kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation : kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }

    // 释放内存
    CGColorSpaceRelease(colorSpace);
    CFRelease(alphaMask);
}

@end
