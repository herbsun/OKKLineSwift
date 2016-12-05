//
//  OKKDJModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/5.
//
//

import UIKit

class OKKDJModel {
    
    let klineModels: [OKKLineModel]
    
    init(klineModels: [OKKLineModel]) {
        self.klineModels = klineModels
    }
    
    public func fetchDrawKDJData(drawRange: NSRange? = nil) -> [[Double?]] {
        return []
    }
    
//    private class func handleMinPriceOfNineClock(index: Int, models: [OKKLineModel]) -> Double {
//        var minValue = models[index].low
//        let startIndex = index < 9 ? 0 : (index - (9 - 1))
//        
//        for i in startIndex..<index {
//            if models[i].low < minValue {
//                minValue = models[i].low
//            }
//        }
//        return minValue
//    }
//    
//    private class func handleMaxPriceOfNineClock(index: Int, models: [OKKLineModel]) -> Double {
//        var maxValue = models[index].high
//        let startIndex = index < 9 ? 0 : (index - (9 - 1))
//        
//        for i in startIndex..<index {
//            if models[i].high < maxValue {
//                maxValue = models[i].high
//            }
//        }
//        return maxValue
//    }
//    
//    private class func handleRSV9(model: OKKLineModel) -> Double {
//        if model.minPriceOfNineClock == model.maxPriceOfNineClock {
//            return 100.0
//        } else {
//            return (model.close - model.minPriceOfNineClock) / (model.maxPriceOfNineClock - model.minPriceOfNineClock)
//        }
//    }
//    
//    private class func handleKDJ_K(model: OKKLineModel, previousModel: OKKLineModel?) -> Double {
//        
//        if previousModel == nil { // 第一个数据
//            return (model.RSV9 + 2 * 50) / 3
//        } else {
//            return (model.RSV9 + 2 * previousModel!.KDJ_K) / 3
//        }
//    }
//    
//    private class func handleKDJ_D(model: OKKLineModel, previousModel: OKKLineModel?) -> Double {
//        
//        if previousModel == nil { // 第一个数据
//            return (model.KDJ_K + 2 * 50) / 3
//        } else {
//            return (model.KDJ_K + 2 * previousModel!.KDJ_D) / 3
//        }
//    }
//    
//    private class func handleKDJ_J(model: OKKLineModel) -> Double {
//        return model.KDJ_K * 3 - model.KDJ_D * 2
//    }

}
