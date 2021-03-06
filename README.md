# TangHelper 

矿场批量部署辅助工具

## 适用场景

该工具适用于矿场初次批量部署。

### 传统矿场部署步骤

1. 将矿机与操作的计算机接入同一网段网络，如烤猫矿机出厂默认设置 IP 为 192.168.0.100，需要将计算机 IP 设置为同一网段，如 192.168.0.123；
2. 在计算机上输入矿机默认 IP 地址，进入管理界面；
3. 设置挖矿配置；
4. 设置网络配置；
5. 设置其他服务，如关闭 DNS 服务等；
6. 重启（或使新配置生效）并接入下一台矿机，重复步骤1。

### 使用 TangHelper

使用 TangHelper 后，上述步骤的第 2~5 步可以由该工具自动完成。矿场部署人员仅需要按照提示完成以下步骤：

1. 按照提示插入矿机网线；
2. 等待自动配置；
3. 拔出网线，接入下一台矿机。

## 使用方法

### 使用平台

该工具基于 Chrome 开发，做为 Chrome App 出现，因此可以在 Windows/Linux/MacOS 上运行。

### 安装

1. [安装 Google Chrome 浏览器](http://www.baidu.com/s?ie=UTF-8&wd=google%20chrome)；
1. [下载程序文件](https://raw.githubusercontent.com/tangpool/TangHelper/master/release/release.zip)，并解压缩；
2. 打开 Chrome 浏览器，点击右上角 设置 - 工具 - 扩展，点击“开发者模式”，点击“载入开发中的扩展”，然后选择第 2 步中解压的**文件夹**；
2. 此时 TangHelper 应已显示在扩展列表中。

### 使用

1. 打开 TangHelper后，进入设置页面。
1. 按照页面提示设置矿机信息。
2. 设置完成后，点击开始按钮，进入执行页面。
3. 执行页面共分为以下几个状态：
   1. 等待连接
   2. 操作中
   3. 等待断开
   
   正常工作状态下会按顺序显示。
   
## 技术支持

+ 在 [issues](https://github.com/tangpool/TangHelper/issues) 页面提出问题，或者
+ 发邮件到 techsupport@tangpool.com ，请注明问题类型为 TangHelper。
