//
//  DpPositionAnnotationView.h
//  Deppon
//
//  Created by MrChen on 2018/1/4.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DpPositionAnnotation.h"
#import "DpAnnotationImageView.h"

@interface DpPositionAnnotationView : MAAnnotationView

// mainView
@property (nonatomic, weak) DpAnnotationImageView *mainView;

// 点击回调
@property (nonatomic, copy) void (^didTaped)(DpPositionAnnotationView *annotationView);

// 气泡view
@property (nonatomic, strong) UIView *paopaoView;

@end
