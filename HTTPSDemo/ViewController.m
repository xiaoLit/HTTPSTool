//
//  ViewController.m
//  HTTPSDemo
//
//  Created by light on 2019/2/12.
//  Copyright © 2019 Lit. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"
#import "HTTPSTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    
    [self test2];
}
    
- (void)test1{


    // 使用baidu的HTTPS链接
//    NSString *urlString = @"https://www.baidu.com";
    
    NSString *urlString = @"https://www.12306.cn";

    NSURL *url = [NSURL URLWithString:urlString];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager]initWithBaseURL:url];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [HTTPSTool setSecurityPolicyAFN:manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"results: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"results: %@", error);
        
    }];

}
    
- (void)test2{
 
    
}


@end
