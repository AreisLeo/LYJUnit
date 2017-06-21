//
//  LYJRadarIndicatorView.m
//  LYJUnitPublic
//
//  Created by yuwang on 2017/6/21.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "LYJRadarIndicatorView.h"

@implementation LYJRadarIndicatorView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
    UIColor *aColor = self.startColor;
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetLineWidth(context, 0);//线的宽度
    //以self.radius为半径围绕圆心画指定角度扇形
    
    CGFloat m_pi = M_PI;
    CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc(context, self.center.x, self.center.y, self.radius, (self.clockwise ? self.angle : 0) * m_pi / 180 -  m_pi, (self.clockwise ? (self.angle - 1) : 1) * m_pi / 180 -  m_pi, self.clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    const CGFloat *startColorComponents = CGColorGetComponents(self.startColor.CGColor); //RGB components
    const CGFloat *endColorComponents = CGColorGetComponents(self.endColor.CGColor); //RGB components
    
    CGFloat R, G, B, A;
    //多个小扇形构造渐变的大扇形
    for (int i = 0; i <= self.angle; i++)
    {
        CGFloat ratio = (self.clockwise ? (self.angle - i) : i) / self.angle;
        R = startColorComponents[0] - (startColorComponents[0] - endColorComponents[0]) * ratio;
        G = startColorComponents[1] - (startColorComponents[1] - endColorComponents[1]) * ratio;
        B = startColorComponents[2] - (startColorComponents[2] - endColorComponents[2]) * ratio;
        A = startColorComponents[3] - (startColorComponents[3] - endColorComponents[3]) * ratio;
        //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
        UIColor *aColor = [UIColor colorWithRed:R green:G blue:B alpha:A];
        
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, 0);//线的宽度
        //以self.radius为半径围绕圆心画指定角度扇形
        CGContextMoveToPoint(context, self.center.x, self.center.y);
        CGContextAddArc(context, self.center.x, self.center.y, self.radius,  i * m_pi / 180 -  m_pi, (i + (self.clockwise ? -1 : 1)) * m_pi / 180 -  m_pi, self.clockwise);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    }
}

@end
