//
//  DpPositionCourierModel.h
//  Deppon
//
//  Created by MrChen on 2017/12/13.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 快递员信息模型
@interface DpPositionCourierModel : NSObject

// 是否上班
@property (nonatomic, assign) BOOL work;

// 名字
@property (nonatomic, copy) NSString *empName;

// 是否是低效
@property (nonatomic, assign) BOOL low30;

// 经度
@property (nonatomic, assign) CGFloat longitude;

// 维度
@property (nonatomic, assign) CGFloat latitude;

// gps是否开启
@property (nonatomic, assign) BOOL gpsOn;

// 工号
@property (nonatomic, copy) NSString *empCode;

// 是否pda在线
@property (nonatomic, assign) BOOL pdaOnline;

+ (instancetype)courierWithDic:(NSDictionary *)dic;

@end
