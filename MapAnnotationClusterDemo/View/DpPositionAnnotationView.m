//
//  DpPositionAnnotationView.m
//  Deppon
//
//  Created by MrChen on 2018/1/4.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "DpPositionAnnotationView.h"
#import "DpPositionCourierModel.h"


@interface DpPositionAnnotationView ()


@end

@implementation DpPositionAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        DpAnnotationImageView *imageV = [[DpAnnotationImageView alloc]init];
        imageV.userInteractionEnabled = NO;
        [self addSubview:imageV];
        self.mainView = imageV;
    }
    
    return self;
}

@end
