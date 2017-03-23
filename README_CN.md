<H1 align="center">OKKLineSwift</H1>

### [English Introduction](README.md)

:smile: **OKKLineSwift** 是本人用Swift3编写的绘制股票K线库

## 样例展示

iOS Screenshot
[支持拖动手势, 长按手势(查看详情), 捏合手势(放大缩小)]

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-iOS.gif) 

macOS Screenshot
[支持拖动事件,十字线跟随,鼠标滚动事件(放大缩小)]

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-macOS.gif) 

支持环境
===
Swift 3.0 

iOS 8+

macOS 10.10+

集成方法
===
#### 手动安装

1. 下载所有文件.
2. 将OKKLineSwift文件夹拖拽到你的工程中.

## 源码目录(所有源码均放在Source文件夹下)

|目录 | 说明|
| ---------- | -----------|
| Configuration | OKConfiguration.swift - 这是一个全局控制类,控制全局主题(e.g. 颜色,字号等 |
| Views | OKKLineView - 此类是所有视图的父视图 <br/> OKKLineDrawView.swift - 此类是所有涉及K线视图的父视图,负责处理手势和数据源 <br/> OKValueView.swift - 负责绘制价格 <br/> 1、MainView： <br/> OKKLineMainView.swift - 负责主图的绘制<br/>2、VolumeView： <br/> OKKLineVolumeView.swift - 负责成交量视图的绘制<br/>3、AccessoryView： <br/> OKKLineAccessoryView.swift - 负责指标视图的绘制<br/>4、SegmentView： <br/> OKSegmentView.swift - 负责显示时间线或者指标类型<br/>|
| Models | 数据模型目录,主要是K线数据以及各种指标模型 |
| Tools | 工具类目录,例如:<br/>OKLineBrush.swift - 负责画线的类<br/> OKMALineBrush.swift - 负责画均线的类|

## TODO
- [x] 支持 macOS 系统                                                                                                                                                                                                                                                 
- [ ] 支持更多指标类型

## Licenses
本项目所有OK开头的源码遵守MIT license. 
Copyright (c) 2016 Herb. All rights reserved.

## Contributions
欢迎各位贡献你们的思路和代码! 您可以在这里pull requests和issues我! :clap:


