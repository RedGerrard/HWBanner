//
//  HWBanner.m
//  HWBanner_Example
//
//  Created by 袁海文 on 2019/4/2.
//  Copyright © 2019年 wozaizhelishua. All rights reserved.
//

#import "HWBanner.h"
#import <UIImageView+WebCache.h>

static int const kImageViewCount = 3;

@interface HWBanner()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation HWBanner



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
        
    }
    return self;
}

-(void)setupUI{
 
    _kInterval = 5;
    _isDirectionPortrait = NO;
    _pageControlPosition = PageControlPositionCenter;
    _pageControlIndicatorColor = [UIColor whiteColor];
    _pageControlCurrentColor = [UIColor redColor];
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建一个定时器（dispatch_source_t timer 本质是个oc对象）
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的各种属性 （几时开始任务，每隔多久执行一次）
    // GCD 的时间参数 ，一般是纳秒 （1秒 = 10的9次方纳秒）
    // dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)); 比当前时间晚 3 秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_kInterval * NSEC_PER_SEC)); // 现在 + 2 秒后
    dispatch_time_t interval = _kInterval * NSEC_PER_SEC;
    
    dispatch_source_set_timer(_timer, start, interval, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self next];
        });
    });
    // 启动定时器
    dispatch_resume(_timer);
    
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    
    for (int i = 0; i < kImageViewCount; i++) {
        UIImageView *imgView = [UIImageView new];
        if (i == 1) {
            //这里只给i=1的这个加手势是因为永远只有中间这张显示在屏幕上
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
        }
        [_scrollView addSubview:imgView];
    }
    _pageControl = [UIPageControl new];
    _pageControl.pageIndicatorTintColor = self.pageControlIndicatorColor;
    _pageControl.currentPageIndicatorTintColor = self.pageControlCurrentColor;
    [self addSubview:_pageControl];
   
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if (_isDirectionPortrait) {
        _scrollView.contentSize = CGSizeMake(0, kImageViewCount * height);
    } else {
        _scrollView.contentSize = CGSizeMake(kImageViewCount * width, 0);
    }
    
    for (int i = 0; i < _scrollView.subviews.count; i++) {
        UIImageView *imgView = _scrollView.subviews[i];
        if (_isDirectionPortrait) {
            imgView.frame = CGRectMake(0, i * height, width, height);
        } else {
            imgView.frame = CGRectMake(i * width, 0, width, height);
        }
    }
    CGFloat widthPageControl = 80;
    CGFloat heightPageControl = 20;
    
    if (_pageControlPosition == PageControlPositionLeft) {
        _pageControl.frame = CGRectMake(0, height - heightPageControl, widthPageControl, heightPageControl);
    }else if (_pageControlPosition == PageControlPositionCenter){
        _pageControl.frame = CGRectMake((width - widthPageControl) / 2, height - heightPageControl, widthPageControl, heightPageControl);
    }else if (_pageControlPosition == PageControlPositionRight) {
        _pageControl.frame = CGRectMake(width - widthPageControl, height - heightPageControl, widthPageControl, heightPageControl);
    }
}
-(void)setImgArray:(NSArray *)imgArray{
    
    _imgArray = imgArray;
    
    [self layoutIfNeeded];
    _pageControl.numberOfPages = imgArray.count;
    _pageControl.currentPage = 0;
    
    [self updateImgView];
    [self stopTimer];
    [self startTimer];
}
-(void)updateImgView{
    
    for (int i = 0; i < _scrollView.subviews.count; i++) {
        UIImageView *imgView = _scrollView.subviews[i];
        NSInteger index = _pageControl.currentPage;
        if (i == 0) {
            index--;
        }else if (i == 2){
            index++;
        }
        if (index < 0) {
            index = _imgArray.count - 1;
        }else if (index >= _imgArray.count){
            index = 0;
        }
        
        if (_imgArray.count == 0) {
            return;
        }
        
        imgView.tag = index;
        
        NSString *imgName = _imgArray[index];
        if ([self verifyURL:imgName]) {
            
            NSURL *url = [NSURL URLWithString:imgName];
            if (url) {
                [imgView sd_setImageWithURL:url placeholderImage:_placeholder_image];
            }
            
        } else {
            imgView.image = [UIImage imageNamed:imgName];
        }
    }
    if (_isDirectionPortrait) {
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.frame.size.height)];
    } else {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    
}

-(BOOL)verifyURL:(NSString *)url{
    NSString *pattern = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [pred evaluateWithObject:url];
}

-(void)startTimer{
    
    dispatch_resume(_timer);
}
-(void)stopTimer{
    
    dispatch_suspend(_timer);
}
-(void)next{
    if (_isDirectionPortrait) {
        //这里千万不能写成[_scrollView setContentOffset:CGPointMake(0, 2 * _scrollView.frame.size.height)];
        [_scrollView setContentOffset:CGPointMake(0, 2 * _scrollView.frame.size.height) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(2 * _scrollView.frame.size.width, 0) animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i < _scrollView.subviews.count; i++) {
        CGFloat distance = 0;
        UIImageView *imgView = _scrollView.subviews[i];
        if (_isDirectionPortrait) {
            distance = ABS(imgView.frame.origin.y - _scrollView.contentOffset.y);
        } else {
            distance = ABS(imgView.frame.origin.x - _scrollView.contentOffset.x);
        }
        if (distance < minDistance) {
            minDistance = distance;
            page = imgView.tag;
        }
    }
    _pageControl.currentPage = page;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self startTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self updateImgView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self updateImgView];
}
-(void)tap:(UITapGestureRecognizer*)tap{
    self.imgClick(tap.view.tag);
}

@end
