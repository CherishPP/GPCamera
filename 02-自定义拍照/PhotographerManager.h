//
//  PhotographerManager.h
//  02-自定义拍照
//
//  Created by MS on 15/10/6.
//  Copyright (c) 2015年 GaoPanpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, CameraDevicePosition)
{
    CameraDevicePositionFront,//前置
    CameraDevicePositionBack//后置
};
typedef NS_ENUM(NSInteger, TorchStatus)
{
    TorchStatusOpen,//打开
    TorchStatusClose,//关闭
    TorchStatusAuto//自动
};

//拍照完成的回调
typedef void(^TakePhotoFinished)(NSData * imageData);

@interface PhotographerManager : NSObject
//输入和输出设备的桥梁
@property (nonatomic,strong)AVCaptureSession * session;
//真正的input和output的连接对象
//@property (nonatomic,strong)AVCaptureConnection * connection;

+ (instancetype)photographerManager;
//开始
- (void)startTakePhoto;
//停止
- (void)stopTakePhoto;
//获取照片
- (void)takePhotoWithCameraFinishHandle:(TakePhotoFinished)handle;
//切换摄像头
- (void)switchCameraDevic:(CameraDevicePosition)position;
//打开手电筒
- (void)turnOnTheTurch:(TorchStatus)status;
@end
