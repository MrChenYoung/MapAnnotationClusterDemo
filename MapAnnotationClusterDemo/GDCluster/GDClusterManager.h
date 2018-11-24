//
//  GDClusterManager.h
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/30.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface GDClusterManager : NSObject

// 初始化
- (instancetype)initWithMapView:(MAMapView *)mapView;

// 添加标注
- (void)addAnnotations:(NSArray <CLLocation *>*)annotations;

// 更新annotations
- (void)updateAnnotations;

@end
