//
//  BDMapViewController.m
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/30.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "BDMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "AnnotationManager.h"
#import "DpPositionCourierModel.h"
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import "BDClusterAnnotation.h"
#import "BDClusterAnnotationView.h"
#import "BMKClusterManager.h"

@interface BDMapViewController ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

//点聚合管理类
@property (nonatomic, strong) BMKClusterManager *clusterManager;

//点聚合缓存标注
@property (nonatomic, strong) NSMutableArray *clusterCaches;

//聚合级别
@property (nonatomic, assign) NSInteger clusterZoom;

@end

@implementation BDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"百度地图点聚合";
    
    [self createMap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadAnnotations];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)createMap
{
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
}

// 获取坐标点
- (void)loadAnnotations
{
    NSArray *annotations = [AnnotationManager annotations];
    
    //点聚合管理类
    self.clusterManager = [[BMKClusterManager alloc] init];
    self.clusterCaches = [NSMutableArray array];
    
    // 快递员标注
    // 创建所有的标注
    NSMutableArray *locations = [NSMutableArray array];
    for (int j = 0; j < annotations.count; j++) {
        DpPositionCourierModel *cModel = annotations[j];
        
        if (cModel.latitude == 0 || cModel.longitude == 0) continue;
        
        BDClusterAnnotation *annotation = [[BDClusterAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(cModel.latitude, cModel.longitude);
        [locations addObject:annotation];
        
        BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
        clusterItem.coor = CLLocationCoordinate2DMake(cModel.latitude, cModel.longitude);
        [self.clusterManager addClusterItem:clusterItem];
        [self.clusterCaches addObject:[NSMutableArray array]];
    }
    
    [self.mapView addAnnotations:locations];
    
    DpPositionCourierModel *m = (DpPositionCourierModel *)annotations.firstObject;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(m.latitude, m.longitude)];
    self.mapView.zoomLevel = 13;
}

//更新聚合状态
- (void)updateClusters {
    __weak typeof(self) weakSelf = self;
    _clusterZoom = (NSInteger)_mapView.zoomLevel;
    @synchronized(_clusterCaches) {
        __block NSMutableArray *clusters = [_clusterCaches objectAtIndex:(_clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                ///获取聚合后的标注
                __block NSArray *array = [weakSelf.clusterManager getClusters:weakSelf.clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (BMKCluster *item in array) {
                        BDClusterAnnotation *annotation = [[BDClusterAnnotation alloc] init];
                        annotation.coordinate = item.coordinate;
                        annotation.size = item.size;
                        annotation.title = [NSString stringWithFormat:@"我是%ld个", item.size];
                        [clusters addObject:annotation];
                    }
                    [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
                    [weakSelf.mapView addAnnotations:clusters];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BDClusterAnnotation class]]) {
        BDClusterAnnotation *clusterAnnotation = (BDClusterAnnotation *)annotation;
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BDClusterAnnotationView *annotationView = (BDClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BDClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.count = clusterAnnotation.size;
        annotationView.annotation = clusterAnnotation;
        
        return annotationView;
    }
    
    return nil;
}

/**
 *地图初始化完毕时会调用此接口
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self updateClusters];
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_clusterZoom != 0 && _clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}

@end
