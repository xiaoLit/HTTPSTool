# HTTPSTool

>问题来源：首先为什么要接入`HTTPS`，对比`HTTP`有什么好处？
并不是苹果爸爸要求我们(目前无限期延长)，而是确实有其需要的重要意义。

#如何食用
**如果你只是想最简单使用后台提供的`HTTPS`接口（**CA机构购买的证书**），并不想了解更多内容，那么你可以直接不用看了，因为`iOS`系统会帮我们自动验证`HTTPS`，不管是用的原生NSURLSession构建的网络库，还是使用AFN都不需要我们额外费心思。如果你是有安全方面的要求（金融等相关-需要加入`TLS`证书钢钉）或者想了解更多关于`HTTPS`的相关内容可以跳转我写的博客啦。**

[iOS应该了解的HTTPS](https://xiaolit.github.io/2018/07/15/iOS-s-HTTPS/)

[iOS如何在HTTPS中使用TLS证书验证](https://xiaolit.github.io/2019/02/12/iOS如何在HTTPS中使用TLS证书验证/)

[HTTPS的证书X.509](https://xiaolit.github.io/2019/02/01/X-509certificate/)
