<H1 align="center">OKKLineSwift</H1>

### [中文介绍](README_CN.md)

:smile: **OKKLineSwift** is written in Swift3 to draw the stock K-line library

## Screenshot

iOS Screenshot
[Support drag gestures, long press gestures (see details), knead gestures (zoom in)]

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-iOS.gif) 

macOS Screenshot
[Support drag events, crosshairs follow, mouse scrolling events (zoom in)]

![OKKLineSwift](https://github.com/Herb-Sun/OKKLineSwift/blob/master/Screenshot/OKKLineSwift-macOS.gif) 

Support
===
Swift 3.0 

iOS 8+

macOS 10.10+

Installation
===
#### Manually

1. Download the full file.
2. Drag the OKKLineSwift folder to your project.

## Source directory

|Directory | Description|
| ---------- | -----------|
| Configuration | OKConfiguration.swift - This is a global control class that controls the global theme (e.g. color, font size, etc.) |
| Views | OKKLineView - This class is the parent view of all views <br/> OKKLineDrawView.swift - This class is a parent view of all K-line views that handle gestures and data sources <br/> OKValueView.swift - Responsible for drawing prices <br/> 1、MainView： <br/> OKKLineMainView.swift - Responsible for drawing the main graph <br/>2、VolumeView： <br/> OKKLineVolumeView.swift - Responsible for drawing the volume view <br/>3、AccessoryView： <br/> OKKLineAccessoryView.swift - Responsible for drawing the index view<br/>4、SegmentView： <br/> OKSegmentView.swift - Responsible for displaying timeline or indicator type<br/>|
| Models | Data model directory, mainly K-line data and a variety of indicators model |
| Tools | Tool class directory,for example: <br/>OKLineBrush.swift - Responsible for drawing lines <br/>OKMALineBrush.swift - Responsible for drawing the average class|

## TODO
- [x] Support macOS system                                                                                                                                                                                                                                                 
- [ ] Support for more metric types

## Licenses
All the OK at the beginning of the project source code to comply with MIT license. 
Copyright (c) 2016 Herb. All rights reserved.

## Contributions
Welcome to contribute to your ideas and code! You can pull requests and issues here! :clap:


