//
//  HTTPSTool.m
//  HTTPSDemo
//
//  Created by light on 2019/2/12.
//  Copyright © 2019 Lit. All rights reserved.
//

#import "HTTPSTool.h"


@interface HTTPSTool()
    
@property (nonatomic,strong) NSArray *trustedCertificates;

@end

@implementation HTTPSTool
    
+ (NSString *)cerPath {
    //证书路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cerName" ofType:@".cer"];
    return cerPath;
}


/**
 证书数组 可以使用多张证书
 */
- (NSArray *)trustedCertificates {
    if (!_trustedCertificates) {
        NSString *cerPath = [HTTPSTool cerPath];
        
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
        _trustedCertificates = @[CFBridgingRelease(certificate)];
    }
    return _trustedCertificates;
}
    
    
+ (void)setSecurityPolicyAFN:(AFHTTPSessionManager *)manager {
    
    //AFSSLPinningModePublicKey : 只对比服务器证书的 public key 跟我们打包的 public key 是否匹配
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    NSString *cerPath = [HTTPSTool cerPath];
    NSData *dataSou = [NSData dataWithContentsOfFile:cerPath];
    NSSet *set = [NSSet setWithObjects:dataSou, nil];
    
    //是否允许无效证书
    securityPolicy.allowInvalidCertificates = NO;

    //是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = YES;
    
    [securityPolicy setPinnedCertificates:set];
    [manager setSecurityPolicy:securityPolicy];
}
    
+ (instancetype )setSecurityPolicyNSURLSession {
    HTTPSTool *saTool = [[HTTPSTool alloc]init];
    return saTool;
}
    
    
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    //默认为空
    NSURLCredential *credential = nil;
    
    //如果使用默认的处置方式，那么 credential 就会被忽略
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    
    //当取得保护空间要求我们认证的方式为NSURLAuthenticationMethodServerTrust时才会有serverTrust
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        //拿到系统的 SecTrustRef 它包含验证策略（SecPolicyRef）以及一系列受信任的锚点证书
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        
        //设置锚点证书。
        SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)self.trustedCertificates);
        //true 代表仅被传入的证书作为锚点，false 允许系统 CA 证书也作为锚点
        SecTrustSetAnchorCertificatesOnly(trust, true);

        //假设验证结果是无效的
        SecTrustResultType result = kSecTrustResultInvalid;
        
        //证书校验函数,在函数的内部递归地从叶节点证书到根证书验证。
        OSStatus status = SecTrustEvaluate(trust, &result);

        /* 调用自定义的验证过程 */
        if (status == errSecSuccess && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            credential = [NSURLCredential credentialForTrust:trust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
        } else {
            /* 无效的话，取消 */
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}
    

@end
