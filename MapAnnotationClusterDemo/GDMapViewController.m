//
//  GDMapViewController.m
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/27.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "GDMapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "AnnotationManager.h"
#import "DpPositionAnnotationView.h"
#import "CoordinateQuadTree.h"
#import "ClusterAnnotation.h"
#import "ClusterAnnotationView.h"
#import "GDClusterManager.h"

@interface GDMapViewController ()<MAMapViewDelegate>

// mapview
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, copy) NSArray <CLLocation *>*locaiotns;

@property (nonatomic, strong) GDClusterManager *clusterManager;
@end

@implementation GDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"高德地图点聚合";
    
    [self createMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.clusterManager = [[GDClusterManager alloc]initWithMapView:self.mapView];
    [self loadAnnotations];
}

- (void)createMapView
{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds]
    ;
    
    // 不可旋转
    mapView.rotateEnabled = NO;
    // 不可以相机角度看地图
    mapView.rotateCameraEnabled = NO;
    // 隐藏指南针
    mapView.showsCompass = NO;
    
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    self.mapView = mapView;
}

// 获取坐标点
- (void)loadAnnotations
{
    NSArray *annotations = [AnnotationManager annotations];
    
    // 快递员标注
    // 创建所有的标注
    NSMutableArray *locations = [NSMutableArray array];
    for (int j = 0; j < annotations.count; j++) {
        DpPositionCourierModel *cModel = annotations[j];
        
        if (cModel.latitude == 0 || cModel.longitude == 0) continue;
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:cModel.latitude longitude:cModel.longitude];
        [locations addObject:location];
    }
    
    DpPositionCourierModel *m = (DpPositionCourierModel *)annotations.firstObject;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(m.latitude, m.longitude)];
    self.mapView.zoomLevel = 13;
    
    // 添加标注
    [self.clusterManager addAnnotations:locations];
}

#pragma mark - MAMapViewDelegate
// 添加annotation
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[DpPositionAnnotation class]]){
//        static NSString *pointReuseIndentifier = @"positionReuseIndentifier";
//
//        id model = [(DpPositionAnnotation *)annotation model];
//
//        DpPositionAnnotationView *annotationView = (DpPositionAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil){
//            annotationView = [[DpPositionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//            annotationView.canShowCallout = NO;
//        }
//
//        annotationView.mainView.model = model;
//
//        // 标注向上偏移
//        annotationView.centerOffset = CGPointMake(0, -annotationView.frame.size.height * 0.5);
//
//        return annotationView;
//    }
//    return nil;
    
    if ([annotation isKindOfClass:[ClusterAnnotation class]])
    {
        /* dequeue重用annotationView. */
        static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
        
        ClusterAnnotationView *annotationView = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
        
        if (!annotationView)
        {
            annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:AnnotatioViewReuseID];
        }
        
        /* 设置annotationView的属性. */
        annotationView.annotation = annotation;
        annotationView.count = [(ClusterAnnotation *)annotation count];
        
        /* 不弹出原生annotation */
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.clusterManager updateAnnotations];
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{
    [self.clusterManager updateAnnotations];
}

@end
