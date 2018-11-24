//
//  DpAnnotationImageView.m
//  Deppon
//
//  Created by MrChen on 2017/12/9.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import "DpAnnotationImageView.h"
#import "DpPositionCourierModel.h"

@interface DpAnnotationImageView ()

// 中心图片
@property (nonatomic, weak) UIImageView *midleImageView;

// 右上角图片
@property (nonatomic, weak) UIImageView *badgeImageView;
@end

@implementation DpAnnotationImageView
/**
 * 初始化
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setModel:(DpPositionCourierModel *)model
{
    _model = model;
    
    NSString *badgeImgName = @"";
    NSString *centerImgName = @"person_on.png";
    
    // 快递员
    DpPositionCourierModel *mod = (DpPositionCourierModel *)model;
    
    // 是否高效
    badgeImgName = mod.low30 ? @"ovalRed.png" :  @"ovalGreen.png";
    
    self.badgeImageName = badgeImgName;
    self.midlImageName = centerImgName;
    
    CGSize siz = CGSizeMake(45.8, 50.6);
    self.frame = CGRectMake(0, 0, siz.width, siz.height);
    self.image = [UIImage imageNamed:@"bgImg.png"];
    self.superview.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self updateSubviews];
}

#pragma mark - 创建子试图
- (void)createSubViews
{
    // 中间图片
    UIImageView *midleImgV = [[UIImageView alloc]init];
    midleImgV.clipsToBounds = YES;
    midleImgV.image = [UIImage imageNamed:@"male.png"];
    [self addSubview:midleImgV];
    self.midleImageView = midleImgV;
    
    // 右上角标注
    UIImageView *badgeImageV = [[UIImageView alloc]init];
    [self addSubview:badgeImageV];
    self.badgeImageView = badgeImageV;
}

- (void)updateSubviews
{
    CGFloat midlX = 10;
    CGFloat midlY = 5;
    CGFloat midlW = self.bounds.size.width - midlX * 2;
    CGFloat midlH = midlW;
    self.midleImageView.frame = CGRectMake(midlX, midlY, midlW, midlH);
    self.midleImageView.layer.cornerRadius = self.midleImageView.bounds.size.width * 0.5;
    
    CGFloat badgW = 12.1;
    CGFloat badgH = badgW;
    CGFloat badgX = 30.4;
    CGFloat badgY = self.bounds.size.height - 40.6 - badgH;
    self.badgeImageView.frame = CGRectMake(badgX, badgY, badgW, badgH);
    
}

#pragma mark - 设置图片
// 中间
- (void)setMidlImageName:(NSString *)midlImageName
{
    _midlImageName = midlImageName;
    self.midleImageView.image = [UIImage imageNamed:midlImageName];
}

// 右上角
- (void)setBadgeImageName:(NSString *)badgeImageName
{
    _badgeImageName = badgeImageName;
    self.badgeImageView.image = [UIImage imageNamed:badgeImageName];
}

@end
