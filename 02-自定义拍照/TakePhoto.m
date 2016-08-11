//
//  TakePhoto.m
//  02-自定义拍照
//
//  Created by MS on 15/10/6.
//  Copyright (c) 2015年 GaoPanpan. All rights reserved.
//

#import "TakePhoto.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotographerManager.h"
#define kTakePhotoBtnWidth 100
#define kTakePhotoBtnHeight kTakePhotoBtnWidth
@interface TakePhoto ()
{
    TakePhotoHandle _handle;
}
//切换设备的按钮
@property (nonatomic,weak)UIButton * switchBtn;
//手电筒
@property (nonatomic,weak)UIButton * torchBtn;

@property (nonatomic,weak)UIButton * takePhotoBtn;
//显示拍摄画面的图层
@property (nonatomic,weak)AVCaptureVideoPreviewLayer * videoLayer;

@end

@implementation TakePhoto
- (AVCaptureVideoPreviewLayer *)videoLayer
{
    if (!_videoLayer) {
        AVCaptureVideoPreviewLayer * layer= [AVCaptureVideoPreviewLayer layerWithSession:[PhotographerManager photographerManager].session];
        [self.layer insertSublayer:layer atIndex:0];
        _videoLayer = layer;
    }
    return _videoLayer;
}
//拍摄
- (UIButton *)takePhotoBtn
{
    if (!_takePhotoBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_image_close@3x"] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
        _takePhotoBtn = btn;
    }
    return _takePhotoBtn;
}
//前后转换
- (UIButton *)switchBtn
{
    if (!_switchBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"add_button_item"] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(switchDevice:) forControlEvents:UIControlEventTouchUpInside];
        _switchBtn = btn;
    }
    return _switchBtn;
}
//手电筒
- (UIButton *)torchBtn
{
    if (!_torchBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"add_button_item"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"add_button_item"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(turnOn:) forControlEvents:UIControlEventTouchUpInside];
        _torchBtn = btn;
    }
    return _torchBtn;
}
#pragma mark - 闪关灯
- (void)turnOn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[PhotographerManager photographerManager] turnOnTheTurch:TorchStatusOpen];
    }else
    {
        [[PhotographerManager photographerManager] turnOnTheTurch:TorchStatusClose];
    }
}
#pragma mark - 前后摄像头
- (void)switchDevice:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[PhotographerManager photographerManager] switchCameraDevic:CameraDevicePositionFront];
    }else
        [[PhotographerManager photographerManager] switchCameraDevic:CameraDevicePositionBack];
}
#pragma mark - 照相
- (void)getPhoto
{
    [[PhotographerManager photographerManager] takePhotoWithCameraFinishHandle:^(NSData *imageData) {
        if (_handle) {
            _handle(imageData);
        }
    }];
}

- (void)layoutSubviews
{
    //拍摄按钮的大小
    self.takePhotoBtn.frame = CGRectMake((self.frame.size.width - kTakePhotoBtnWidth)/2, (self.frame.size.height - kTakePhotoBtnHeight)-20, kTakePhotoBtnWidth, kTakePhotoBtnHeight);
    //设置拍摄画面图层的大小
    self.videoLayer.frame = self.bounds;
    //设置转化设备按钮的大小
    self.switchBtn.frame = CGRectMake(self.frame.size.width - 60, 30, 40, 40);
    //手电筒的大小
    self.torchBtn.frame = CGRectMake(20, 30, 40, 40);
}


#pragma mark - setter
- (void)setTakePhotoHandle:(TakePhotoHandle)handle
{
    _handle = handle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
