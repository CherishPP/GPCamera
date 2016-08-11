//
//  ViewController.m
//  02-自定义拍照
//
//  Created by MS on 15/10/6.
//  Copyright (c) 2015年 GaoPanpan. All rights reserved.
//

#import "ViewController.h"
#import "TakePhoto.h"
#import "PhotographerManager.h"
#import "DetailViewController.h"
@interface ViewController ()
@property (nonatomic,weak)TakePhoto * takePhoto;
@end

@implementation ViewController
- (TakePhoto *)takePhoto
{
    if (!_takePhoto) {
        TakePhoto * takePhoto = [[TakePhoto alloc] init];
        takePhoto.frame = self.view.bounds;
        [self.view addSubview:takePhoto];
        _takePhoto = takePhoto;
    }
    return _takePhoto;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self takePhoto];
    self.takePhoto.backgroundColor = [UIColor blackColor];
    //设置拍照完成的回调
    [self.takePhoto setTakePhotoHandle:^(NSData *iamgeData) {
        DetailViewController * detail = [[DetailViewController alloc] init];
        detail.iamgeData =iamgeData;
        [self.navigationController pushViewController:detail animated:YES];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //拍照
    [[PhotographerManager photographerManager] startTakePhoto];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[PhotographerManager photographerManager] stopTakePhoto];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
