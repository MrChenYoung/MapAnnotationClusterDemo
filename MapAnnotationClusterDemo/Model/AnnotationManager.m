//
//  AnnotationManager.m
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/27.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "AnnotationManager.h"

@implementation AnnotationManager

+ (NSArray <DpPositionCourierModel *>*)annotations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Annotaions" ofType:@"data"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    NSMutableArray *cArrM = [NSMutableArray array];
    NSArray *cArr = json[@"courierList"];
    if (![cArr isEqual:[NSNull null]]) {
        for (int i = 0; i < cArr.count; i++) {
            NSDictionary *cDictionary = cArr[i];
            DpPositionCourierModel *cModel = [DpPositionCourierModel courierWithDic:cDictionary];
            [cArrM addObject:cModel];
        }
    }
    
    return [cArrM copy];
}

@end
