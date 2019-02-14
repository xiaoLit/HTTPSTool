//
//  HTTPSTool.h
//  HTTPSDemo
//
//  Created by light on 2019/2/12.
//  Copyright © 2019 Lit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPSTool : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>

    

/**
 AFN验证证书
 使用方式:
 在AFN请求发送前 使用 传入AFHTTPSessionManager实例
 [YKSecurityAuthenticationTool setSecurityPolicyAFN:mgr];
 */
+ (void)setSecurityPolicyAFN:(AFHTTPSessionManager *)manager;


/**
 NSURLSession验证证书
 使用方式:
 将原有创建session方式替换成此方法
 NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[YKSecurityAuthenticationTool setSecurityPolicyNSURLSession] delegateQueue:[[NSOperationQueue alloc] init]];
 */
+ (instancetype )setSecurityPolicyNSURLSession;


/**
 淘汰NSURLConnection --> 替换为NSURLSession
 使用方式:
 
 源代码为
 //NSData* responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
 用以下代码替换
 
 NSData* responseData ;
 NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[YKSecurityAuthenticationTool setSecurityPolicyNSURLSession] delegateQueue:[[NSOperationQueue alloc] init]];
 dispatch_semaphore_t disp = dispatch_semaphore_create(0);
 __block  NSMutableData* mutData = [NSMutableData data];
 NSLog(@"urlRequest>>>>>>>>>>%@",urlRequest);
 NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 [mutData resetBytesInRange:NSMakeRange(0, [mutData length])];
 [mutData setLength:0];
 [mutData appendData:data];
 dispatch_semaphore_signal(disp);
 }];
 [dataTask resume];
 dispatch_semaphore_wait(disp, dispatch_time(DISPATCH_TIME_NOW, 60*NSEC_PER_SEC));//30s 超时
 if (mutData.length > 0) {
 responseData = mutData;
 }
 */


@end

NS_ASSUME_NONNULL_END
