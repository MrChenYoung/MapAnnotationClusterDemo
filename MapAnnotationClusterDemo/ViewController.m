//
//  ViewController.m
//  MapAnnotationClusterDemo
//
//  Created by MrChen on 2018/7/27.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "ViewController.h"
#import "CreateSubViewHandler.h"
#import "GDMapViewController.h"
#import "BDMapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图点聚合";
    
    NSArray *titles = @[@"高德地图点聚合",@"百度地图点聚合"];
    [CreateSubViewHandler createBtn:titles fontSize:16 target:self sel:@selector(click:) superView:self.view baseTag:1000];
}

- (void)click:(UIButton *)btn
{
    UIViewController *vc = nil;
    
    switch (btn.tag - 1000) {
        case 0:
            // 高德地图点聚合
            vc = [[GDMapViewController alloc]init];
            break;
        case 1:
            // 百度地图点聚合
            vc = [[BDMapViewController alloc]init];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
