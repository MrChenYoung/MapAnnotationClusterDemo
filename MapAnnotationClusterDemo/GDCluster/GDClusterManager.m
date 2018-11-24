//
//  GDClusterManager.m
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/30.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "GDClusterManager.h"
#import "CoordinateQuadTree.h"

@interface GDClusterManager()

@property (nonatomic, strong) CoordinateQuadTree* coordinateQuadTree;

@property (nonatomic, weak) MAMapView *mapView;

@end

@implementation GDClusterManager

// 初始化
- (instancetype)initWithMapView:(MAMapView *)mapView
{
    self = [super init];
    if (self) {
        
        self.mapView = mapView;
        
        self.coordinateQuadTree = [[CoordinateQuadTree alloc]init];
    }
    return self;
}

// 添加标注
- (void)addAnnotations:(NSArray <CLLocation *>*)annotations
{
    // 首先移除地图上所有的标注
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 建立四叉树. */
        [self.coordinateQuadTree buildTreeWithLocations:annotations];
        
        [self updateAnnotations];
    });
}

// 更新annotations
- (void)updateAnnotations
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 根据当前zoomLevel和zoomScale 进行annotation聚合. */
        double zoomScale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:self.mapView.visibleMapRect
                                                                            withZoomScale:zoomScale
                                                                             andZoomLevel:self.mapView.zoomLevel];
        /* 更新annotation. */
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    });
}

/* 更新annotation. */
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    /* 保留仍然位于屏幕内的annotation. */
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    /* 需要添加的annotation. */
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    /* 删除位于屏幕外的annotation. */
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    /* 更新. */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
    });
}

@end
