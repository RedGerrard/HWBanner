 <h1 align="center"> HWBanner</h1>轻量级的无限轮播图（HWCyclePics的oc版）
 
 ## How To Use
 * 代码加载
 ```
 #import <HWBanner.h>
 ...
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
 ```
 * Nib加载
 ```
 #import <HWBanner.h>
 ...
 @property (weak, nonatomic) IBOutlet HWBanner *banner;
 ...
 //设置图片数据源
 banner.imgArray = @[@"abc",@"def",@"ghi",@"ojk"];
 //设置点击事件
 banner.imgClick = ^(NSInteger tag) {
 NSLog(@"%ld",(long)tag);
 };
 ```
 
 ## Installation
 
 HWCyclePics is available through [CocoaPods](https://cocoapods.org). To install
 it, simply add the following line to your Podfile:
 
 ```ruby
 pod 'HWBanner'
 ```
 
 ## Author
 本人小菜鸟一枚，欢迎各位同仁和大神指教
 <br>我的简书是：https://www.jianshu.com/u/cdd48b9d36e0
 <br>我的邮箱是：417705652@qq.com
 
 ## Licenses
 
 All source code is licensed under the [MIT License](https://raw.github.com/SDWebImage/SDWebImage/master/LICENSE).
 

