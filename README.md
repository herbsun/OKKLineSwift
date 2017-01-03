<H1 align="center">OKKLineSwift</H1>

## 前言

:smile: OKKLineSwift是本人用Swift3编写的绘制股票K线库

## Screenshot

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-iOS.gif)

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-macOS.gif)

Support
===
Swift 3.0 & iOS 8+ & macOS 10.10+

Installation
===
#### Manually
因为绘制K线大部分工作都是在UI层,而UI层又是最易变的,目前不打算以Cocoapods方式提供

1. Download the full file.
2. Drag the Source folder to your project.

## 源码目录(所有源码均放在Source文件夹下)

|目录 | 说明|
| ---------- | -----------|
| Configuration | OKConfiguration.swift - 这是一个全局控制类,控制全局主题(e.g. 颜色,字号等 |
| Views | OKKLineView - 此类是所有视图的父视图 <br/> OKKLineDrawView.swift - 此类是所有涉及K线视图的父视图,负责处理手势和数据源 <br/> OKValueView.swift - 此类负责绘制价格 <br/> 1、MainView： <br/> OKKLineMainView.swift - 此类负责主图的绘制<br/>2、VolumeView： <br/> OKKLineVolumeView.swift - 此类负责成交量视图的绘制<br/>3、AccessoryView： <br/> OKKLineAccessoryView.swift - 此类负责指标视图的绘制<br/>4、SegmentView： <br/> OKSegmentView.swift - 此类负责显示时间线或者指标类型<br/>|
| Models | 数据模型目录,主要是K线数据以及各种指标模型 |
| Tools | 工具类目录,例如:OKLineBrush.swift - 负责画线的类, OKMALineBrush.swift - 负责画均线的类|

## TODO
- [x] 支持 macOS 系统                                                                                                                                                                                                                                                 
- [ ] 支持更多指标类型

## Licenses
本项目所有OK-开头的源码遵守MIT license. 

## Contributions
欢迎各位贡献你们的思路和代码! 您可以在这里pull requests和issues我! :clap:


