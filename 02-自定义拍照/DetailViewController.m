//
//  DetailViewController.m
//  02-自定义拍照
//
//  Created by MS on 15/10/6.
//  Copyright (c) 2015年 GaoPanpan. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIActionSheetDelegate>

@property (nonatomic,weak)UIImageView * imageView;

@end

@implementation DetailViewController

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航条
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = [[UIImage alloc] initWithData:self.iamgeData];
    [self longPressGesture];
}
//添加长按手势
- (void)longPressGesture
{
    self.imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [self.imageView addGestureRecognizer:longPress];
}

- (void)saveImage:(UILongPressGestureRecognizer * )sender
{
//如果不判断的话，actionsheet会出现两遍。。。
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        [sheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //保存到相册
        /**
         *
         *  参数一   要传入的照片>
         *  参数三   方法
         *
         *  @return <#return value description#>
         */
       
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:self.iamgeData], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}
//保存完成的回调
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        [alter show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
