//
//  WTRoundView.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/12/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTRoundView.h"

@implementation WTRoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//drow View with round corner
    CGContextRef contextBg = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextBg,[UIColor whiteColor].CGColor);
    [self drawRectWithRoundCorners:contextBg rect:rect];
    CGContextFillPath(contextBg);
    
//drow gray stroke with round corner
    CGContextRef contextStroke = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextStroke, [UIColor darkGrayColor].CGColor);
    [self drawRectWithRoundCorners:contextStroke rect:rect];
    CGContextStrokePath(contextStroke);
}


- (void)drawRectWithRoundCorners:(CGContextRef)context rect:(CGRect)rect
{
    float radius = 10;
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
}


@end
