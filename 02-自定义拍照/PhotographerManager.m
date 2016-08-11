//
//  PhotographerManager.m
//  02-自定义拍照
//
//  Created by MS on 15/10/6.
//  Copyright (c) 2015年 GaoPanpan. All rights reserved.
//

#import "PhotographerManager.h"

@interface PhotographerManager ()
//设备：摄像头
@property (nonatomic,strong)AVCaptureDevice * device;
//输入对象
@property (nonatomic,strong)AVCaptureDeviceInput * input;
//图片输出对象
@property (nonatomic,strong)AVCaptureStillImageOutput * output;

@end

@implementation PhotographerManager

+ (instancetype)photographerManager
{
    static PhotographerManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PhotographerManager alloc] init];
    });
    return manager;
}

#pragma mark - getter
//设备
- (AVCaptureDevice *)device
{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
//输入
- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    }
    return _input;
}
//输出
- (AVCaptureStillImageOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureStillImageOutput alloc]init];
        //设置输出图片的类型
        _output.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    }
    return _output;
}
//桥梁
- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        //添加输入和输出设备
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    return _session;
}
#pragma mark - 拍摄方法
//开始
- (void)startTakePhoto
{
    [self.session startRunning];
}
//停止
- (void)stopTakePhoto
{
    [self.session stopRunning];
}
#pragma mark - 获取照片
//获取照片
- (void)takePhotoWithCameraFinishHandle:(TakePhotoFinished)handle
{
    //连接对象和输出设备
    AVCaptureConnection * connection = [self.output connectionWithMediaType:AVMediaTypeVideo];
    [self.output captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        //获取图片完成回调
        //保存媒体样本
        //获取图片的二进制
        NSData * data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        if (handle) {
            handle(data);
        }
    }];
}
#pragma mark - 切换摄像头位置
- (void)switchCameraDevic:(CameraDevicePosition)position
{
    //定义前置和后置摄像头设备
    AVCaptureDevice * fontDevice;
    AVCaptureDevice * backDevice;
    
   //获取系统所有的设备(支持拍摄的)
   NSArray * devices = [AVCaptureDevice devices];
    for (AVCaptureDevice * device in devices) {
        //前置
        if (device.position == AVCaptureDevicePositionFront) {
            fontDevice = device;
        }
        //后置
        if (device.position == AVCaptureDevicePositionBack) {
            backDevice = device;
        }
    }
    
    //判断前后
    if (position == CameraDevicePositionFront) {
        //开始配置
        [self.session beginConfiguration];
        //移除输入设备
        [self.session removeInput:self.input];
        //初始化新的输入设备
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:fontDevice error:nil];
        //提交
        [self.session commitConfiguration];
        //保存,替换输入设备
        self.input = input;
    }else
    {
        //开始配置
        [self.session beginConfiguration];
        //移除输入设备
        [self.session removeInput:self.input];
        //初始化新的输入设备
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:backDevice error:nil];
        //提交
        [self.session commitConfiguration];
        self.input = input;
    }
    
}
#pragma mark - 打开手电筒

- (void)turnOnTheTurch:(TorchStatus)status
{
    //手电筒模式
    AVCaptureTorchMode tormode;
    if (status == TorchStatusOpen) {
        tormode = AVCaptureTorchModeOn;
    }
    else if (status == TorchStatusClose){
        tormode = AVCaptureTorchModeOff;
    }
    else if (status == TorchStatusAuto){
        tormode = AVCaptureTorchModeAuto;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取当前的设备对象
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        [device setTorchMode:tormode];
        
        [device unlockForConfiguration];
    });
}

@end
