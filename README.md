### 1、iOS集成步骤

#### 1.1 添加ToBid适配器依赖
```
pod 'HXToBidAdapter'
```

### 2、ToBid平台上配置自定义广告平台
Adapter类名介绍
```
初始化：HXWMConfigCustomAdapter
开屏：HXWMSplashCustomAdapter
```
#### 2.1 创建自定义广告平台，填写适配器类名
#### 2.2 添加应用维度参数和代码位ID配置如下,appId
应用维度参数：
```
appId = 71004
开屏广告代码位ID：11111231
```
注意事项：

1、上线时需要将appId的值和代码位ID替换成正式的，上述的appId和代码位ID的值为测试通用的
