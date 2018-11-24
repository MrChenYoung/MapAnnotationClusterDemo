//
//  BDClusterAnnotationView.m
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/30.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "BDClusterAnnotationView.h"
//#import "ClusterConst.h"

@interface BDClusterAnnotationView()

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation BDClusterAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:1];
    }

    return self;
}

#pragma mark Utility

- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor       = [UIColor whiteColor];
    _countLabel.textAlignment   = NSTextAlignmentCenter;
    _countLabel.shadowColor     = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset    = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 1)
    {
        UIView *subview = [subViews objectAtIndex:1];
        if ([subview pointInside:[self convertPoint:point toView:subview] withEvent:event])
        {
            return YES;
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height)
    {
        return YES;
    }
    return NO;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    /* 按count数目设置view的大小. */
    CGRect newBounds = CGRectMake(0, 0, roundf(44 * getScaledValueForValue(count)), roundf(44 * getScaledValueForValue(count)));
    self.frame = getCenterRect(newBounds, self.center);
    
    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    self.countLabel.frame = getCenterRect(newLabelBounds, getRectCenter(newBounds));
    self.countLabel.text = [@(_count) stringValue];
    
    [self setNeedsDisplay];
}

#pragma mark - annimation

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self addBounceAnnimation];
}

- (void)addBounceAnnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    bounceAnimation.duration = 0.6;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++)
    {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    
    bounceAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

#pragma mark draw rect

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    
    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
    UIColor *innerCircleStrokeColor = [UIColor whiteColor];
    UIColor *innerCircleFillColor = [UIColor colorWithRed:(255.0 / 255.0) green:(95 / 255.0) blue:(42 / 255.0) alpha:1.0];
    
    CGRect circleFrame = CGRectInset(rect, 4, 4);
    
    [outerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
}

/* 返回rect的中心. */
CGPoint getRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/* 返回中心为center，尺寸为rect.size的rect. */
CGRect getCenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

/* 根据count计算annotation的scale. */
CGFloat getScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * 0.3 * powf(value, 0.4)));
}


@end
