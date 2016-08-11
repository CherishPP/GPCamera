//
//  TakePhoto.h
//  02-自定义拍照
//
//  Created by MS on 15/10/6.
//  Copyright (c) 2015年 GaoPanpan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakePhotoHandle)(NSData * iamgeData);

@interface TakePhoto : UIView

- (void)setTakePhotoHandle:(TakePhotoHandle)handle;

@end
