//
//  HWViewController.m
//  HWBanner
//
//  Created by wozaizhelishua on 04/02/2019.
//  Copyright (c) 2019 wozaizhelishua. All rights reserved.
//

#import "HWViewController.h"
#import "HWBanner.h"
#import <UIImageView+WebCache.h>

@interface HWViewController ()

@end

@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    HWBanner *banner = [[HWBanner alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    //设置图片数据源(图片的名字或者下载地址)
    //banner.imgArray = @[@"pic0",@"pic1",@"pic2",@"pic3"];
    banner.imgArray = @[@"http://images.drztc.com/upload/banner/2019/03/21/2a86d6f9d8e43888fe13a90d5d4deedc.jpg",
                        @"http://images.drztc.com/upload/banner/2019/03/25/e01ba649170f70b833af37708aaf8b53.jpg",
                        @"http://images.drztc.com/upload/banner/2018/11/07/c3be84a6f19d56934a773c5225ddaac2.jpg",
                        @"http://images.drztc.com/upload/banner/2018/05/23/58de5f57f239588284c42931dc53e93f.jpg"];
    //设置图片的加载事件
    banner.loadBlock = ^(UIImageView *imageView, NSString *source) {
        //imageView.image = [UIImage imageNamed:source];
        NSURL *url = [NSURL URLWithString:source];
        if (url) {
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"xxxxx"]];
        }
    };
    
    //设置点击事件
    banner.imgClick = ^(NSInteger tag) {
        NSLog(@"%ld",(long)tag);
    };
    [self.view addSubview:banner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
