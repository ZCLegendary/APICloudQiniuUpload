//
//  ZCTest.m
//  UZApp
//
//  Created by 张闯 on 16/1/28.
//  Copyright © 2016年 APICloud. All rights reserved.
//

#import "ZCTest.h"
#import "UZAppDelegate.h"
#import "NSDictionaryUtils.h"
#import "QiniuSDK.h"

@interface ZCTest ()
{
    NSInteger _cbId;
}


@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic, strong) NSDictionary *messageDict;

@end

@implementation ZCTest

+ (void)launch {
    //在module.json里面配置的launchClassMethod，必须为类方法，引擎会在应用启动时调用配置的方法，模块可以在其中做一些初始化操作
}

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        
    }
    return self;
}

- (void)dispose {
    //do clean
}

//- (void)upLoadPicture:(NSString *)file token:(NSString *)token key:(NSString *)key

- (void)upload:(NSDictionary *)paramsDict
{
    _cbId = [paramsDict integerValueForKey:@"cbId" defaultValue:-1];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    [upManager putFile:paramsDict[@"file"] key:paramsDict[@"key"] token:paramsDict[@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        NSLog(@"info:%@", info);
        NSLog(@"resp:%@", resp);
        NSLog(@"key:%@", key);
        
        if (info.error) {
            [self falseMessagesWithKey:key];
        } else {
            [self successMessagesWithKey:key];
        }
    } option:nil];
}
//回调方法
- (void)successMessagesWithKey:(NSString *)key
{
    NSDictionary *ret = @{@"status": @true, @"oper": @"complete", @"key": key};
    if (_cbId > 0) {
        [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:nil doDelete:YES];
    }
}

- (void)falseMessagesWithKey:(NSString *)key
{
    NSDictionary *ret = @{@"status": @false, @"msg": @"合规校验失败，文件、key、token不能为空"};
    if (_cbId > 0) {
        [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:nil doDelete:YES];
    }
}

@end
