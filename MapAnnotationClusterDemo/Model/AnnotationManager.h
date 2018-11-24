//
//  AnnotationManager.h
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/27.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DpPositionCourierModel.h"

@interface AnnotationManager : NSObject

+ (NSArray <DpPositionCourierModel *>*)annotations;

@end
