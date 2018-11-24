//
//  DpAnnotationImageView.h
//  Deppon
//
//  Created by MrChen on 2017/12/9.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DpAnnotationImageView : UIImageView

// 中间图片名字
@property (nonatomic, copy) NSString *midlImageName;

// 右上角图片名
@property (nonatomic, copy) NSString *badgeImageName;

// 快递员数据模型
@property (nonatomic, strong) id model;

@end
