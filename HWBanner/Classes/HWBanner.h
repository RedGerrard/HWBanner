//
//  HWBanner.h
//  HWBanner_Example
//
//  Created by 袁海文 on 2019/4/2.
//  Copyright © 2019年 wozaizhelishua. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * pageControl的位置
 */
typedef enum : NSUInteger{
    PageControlPositionLeft,
    PageControlPositionCenter,
    PageControlPositionRight,
}PageControlPosition;

typedef void(^LoadImageBlock)(UIImageView *imageView, NSString *source);

typedef void(^imgClick)(NSInteger);

@interface HWBanner : UIView

/**
 轮播间隔时间，默认5秒
 */
@property (nonatomic, assign) double kInterval;

/**
 图片数据源，本地时为图片名字，接口时为图片的下载地址
 */
@property(nonatomic, copy)NSArray *imgArray;

/**
 * 轮播图的方向，默认水平
 */
@property(nonatomic, assign)BOOL isDirectionPortrait;

/**
 * UIPageControl的位置，默认在中间
 */
@property(nonatomic, assign)PageControlPosition pageControlPosition;

/**
 * 图片的加载事件
 */
@property(nonatomic, copy)LoadImageBlock loadBlock;

/**
 * 图片的点击事件
 */
@property(nonatomic, copy)imgClick imgClick;

/**
 pageControl小圆点背景颜色，默认白色
 */
@property (nonatomic, strong) UIColor *pageControlIndicatorColor;

/**
 pageControl小圆点选中颜色，默认红色
 */
@property (nonatomic, strong) UIColor *pageControlCurrentColor;

@end
