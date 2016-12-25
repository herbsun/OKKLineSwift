<H1 align="center">OKKLineSwift</H1>

## 前言

:smile: OKKLineSwift是本人用Swift3编写的绘制股票K线库

## Screenshot

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-iOS.gif)

Support
===
Swift 3.0 & iOS 8+

Installation
===
#### Manually
因为绘制K线大部分工作都是在UI层,而UI层又是最易变的,目前不打算以Cocoapods方式提供

1. Download the full file.
2. Drag the Source folder to your project.

## 源码目录(所有源码均放在Source文件夹下)

### Configuration
* OKConfiguration.swift - 这是一个全局控制类,控制全局主题(e.g. 颜色,字号等)
### Views
  * OKKLineView
    * OKKLineDrawView.swift
      * MainView
        * OKKLineMainView.swift - 此类负责主图的绘制
    * OKValueView
### Models
### Tools

## TODO
- [ ] 支持 macOS 系统

## Licenses
本项目所有OK-开头的源码遵守MIT license. 

## Contributions
欢迎各位贡献你们的思路和代码! 您可以在这里pull requests和issues我! :clap:
