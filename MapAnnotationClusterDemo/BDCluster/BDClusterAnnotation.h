//
//  BDClusterAnnotation.h
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/30.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface BDClusterAnnotation : BMKPointAnnotation

//所包含annotation个数
@property (nonatomic, assign) NSInteger size;

@end
