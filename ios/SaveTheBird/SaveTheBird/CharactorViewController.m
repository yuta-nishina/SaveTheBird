//
//  CharactorViewController.m
//  SaveTheBird
//
//  Created by ATGS_Mac on 2016/05/17.
//  Copyright © 2016年 ATGS. All rights reserved.
//

#import "CharactorViewController.h"

@interface CharactorViewController ()

@end

@implementation CharactorViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _scrollView.delegate = self;
    
    NSInteger pageCount = 3; // ページ数
    
    CGRect scrollViewFrame = self.scrollView.bounds;
    CGFloat width = scrollViewFrame.size.width;
    CGFloat height = scrollViewFrame.size.height;
    
    // スクロールの範囲を設定
    [_scrollView setContentSize:CGSizeMake((pageCount * width), height)];
    
    // スクロールビューに画像を貼り付ける
    
    // 1つ目の画像
    NSInteger count = 0;
    
    UIImage * image1 = [UIImage imageNamed:@"chara01_front_stand"];
    CGRect rect1 = CGRectMake(width * count, 0, width, height);
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:rect1];
    
    imageView1.clipsToBounds = YES;
    imageView1.image = image1;
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    
    [_scrollView addSubview:imageView1];
    
    // 2つ目の画像
    count++;
    
    UIImage * image2 = [UIImage imageNamed:@"bird_maruitori"];
    CGRect rect2 = CGRectMake(width * count, 0, width, height);
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:rect2];
    
    imageView2.clipsToBounds = YES;
    imageView2.image = image2;
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    
    [_scrollView addSubview:imageView2];
    
    // 3つ目の画像
    count++;
    
    UIImage * image3 = [UIImage imageNamed:@"flame"];
    CGRect rect3 = CGRectMake(width * count, 0, width, height);
    UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:rect3];
    
    imageView3.clipsToBounds = YES;
    imageView3.image = image3;
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    
    [_scrollView addSubview:imageView3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// スクロールビューがスワイプされたとき
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    if ((NSInteger)fmod(scrollView.contentOffset.x, pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        _pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    }
}

// ページコントロールがタップされたとき
- (IBAction)pageControl_Tapped:(id)sender {
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
