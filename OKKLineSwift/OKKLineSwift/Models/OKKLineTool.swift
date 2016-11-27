//
//  OKKLineTool.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/11/27.
//  Copyright © 2016年 Herb. All rights reserved.
//

import Foundation

class OKKLineTool {
    
    class func handleKLineModels(klineModels: [OKKLineModel]) -> [OKKLineModel] {
        
        var models = [OKKLineModel]()
        
        for (idx, model) in klineModels.enumerated() {
            
            if idx == 0 {
                // 处理第一个数据
                model.sumVolume = model.volume
                model.sumOpen = model.open
                model.sumClose = model.close
                model.sumHigh = model.high
                model.sumLow = model.low
                model.MA5 = model.close
                model.MA7 = model.close
                model.MA10 = model.close
                model.MA12 = model.close
                model.MA20 = model.close
                model.MA26 = model.close
                model.MA30 = model.close
                model.MA60 = model.close
                model.MA5_VOLUME = model.volume
                model.MA7_VOLUME = model.volume
                model.MA10_VOLUME = model.volume
                model.MA12_VOLUME = model.volume
                model.MA20_VOLUME = model.volume
                model.MA26_VOLUME = model.volume
                model.MA30_VOLUME = model.volume
                model.MA60_VOLUME = model.volume
                model.EMA5 = model.close
                model.EMA7 = model.close
                model.EMA10 = model.close
                model.EMA12 = model.close
                model.EMA20 = model.close
                model.EMA26 = model.close
                model.EMA30 = model.close
                model.EMA60 = model.close
                model.EMA5_VOLUME = model.volume
                model.EMA7_VOLUME = model.volume
                model.EMA10_VOLUME = model.volume
                model.EMA12_VOLUME = model.volume
                model.EMA20_VOLUME = model.volume
                model.EMA26_VOLUME = model.volume
                model.EMA30_VOLUME = model.volume
                model.EMA60_VOLUME = model.volume
                
                model.DIF = model.EMA12 - model.EMA26
                model.DEA = model.DIF * 0.2
                model.MACD = (model.DIF - model.DEA) * 2
                model.minPriceOfNineClock = model.low
                model.maxPriceOfNineClock = model.high
                model.RSV9 = handleRSV9(model: model)
                model.KDJ_K = handleKDJ_K(model: model, previousModel: nil)
                model.KDJ_D = handleKDJ_D(model: model, previousModel: nil)
                model.KDJ_J = handleKDJ_J(model: model)
                
            } else {
                
                let previousModel = klineModels[idx - 1]
                
                model.sumVolume += previousModel.sumVolume
                model.sumOpen += previousModel.sumOpen
                model.sumClose += previousModel.sumClose
                model.sumHigh += previousModel.sumHigh
                model.sumLow += previousModel.sumLow
                model.MA5 = handleMA(day: 5, model: model, index: idx, models: klineModels)
                model.MA7 = handleMA(day: 7, model: model, index: idx, models: klineModels)
                model.MA10 = handleMA(day: 10, model: model, index: idx, models: klineModels)
                model.MA12 = handleMA(day: 12, model: model, index: idx, models: klineModels)
                model.MA20 = handleMA(day: 20, model: model, index: idx, models: klineModels)
                model.MA26 = handleMA(day: 26, model: model, index: idx, models: klineModels)
                model.MA30 = handleMA(day: 30, model: model, index: idx, models: klineModels)
                model.MA60 = handleMA(day: 60, model: model, index: idx, models: klineModels)
                model.MA5_VOLUME = handleMA_VOLUME(day: 5, model: model, index: idx, models: klineModels)
                model.MA7_VOLUME = handleMA_VOLUME(day: 7, model: model, index: idx, models: klineModels)
                model.MA10_VOLUME = handleMA_VOLUME(day: 10, model: model, index: idx, models: klineModels)
                model.MA12_VOLUME = handleMA_VOLUME(day: 12, model: model, index: idx, models: klineModels)
                model.MA20_VOLUME = handleMA_VOLUME(day: 20, model: model, index: idx, models: klineModels)
                model.MA26_VOLUME = handleMA_VOLUME(day: 26, model: model, index: idx, models: klineModels)
                model.MA30_VOLUME = handleMA_VOLUME(day: 30, model: model, index: idx, models: klineModels)
                model.MA60_VOLUME = handleMA_VOLUME(day: 60, model: model, index: idx, models: klineModels)

                model.EMA5 = handleEMA(day: 5, model: model, previousEMA: previousModel.EMA5)
                model.EMA7 = handleEMA(day: 7, model: model, previousEMA: previousModel.EMA7)
                model.EMA10 = handleEMA(day: 10, model: model, previousEMA: previousModel.EMA10)
                model.EMA12 = handleEMA(day: 12, model: model, previousEMA: previousModel.EMA12)
                model.EMA20 = handleEMA(day: 20, model: model, previousEMA: previousModel.EMA20)
                model.EMA26 = handleEMA(day: 26, model: model, previousEMA: previousModel.EMA26)
                model.EMA30 = handleEMA(day: 30, model: model, previousEMA: previousModel.EMA30)
                model.EMA60 = handleEMA(day: 60, model: model, previousEMA: previousModel.EMA60)
                model.EMA5_VOLUME = handleEMA_VOLUME(day: 5, model: model, previousEMA_VOLUME: previousModel.EMA5_VOLUME)
                model.EMA7_VOLUME = handleEMA_VOLUME(day: 7, model: model, previousEMA_VOLUME: previousModel.EMA7_VOLUME)
                model.EMA10_VOLUME = handleEMA_VOLUME(day: 10, model: model, previousEMA_VOLUME: previousModel.EMA10_VOLUME)
                model.EMA12_VOLUME = handleEMA_VOLUME(day: 12, model: model, previousEMA_VOLUME: previousModel.EMA12_VOLUME)
                model.EMA20_VOLUME = handleEMA_VOLUME(day: 20, model: model, previousEMA_VOLUME: previousModel.EMA20_VOLUME)
                model.EMA26_VOLUME = handleEMA_VOLUME(day: 26, model: model, previousEMA_VOLUME: previousModel.EMA26_VOLUME)
                model.EMA30_VOLUME = handleEMA_VOLUME(day: 30, model: model, previousEMA_VOLUME: previousModel.EMA30_VOLUME)
                model.EMA60_VOLUME = handleEMA_VOLUME(day: 60, model: model, previousEMA_VOLUME: previousModel.EMA60_VOLUME)
                
                model.DIF = model.EMA12 - model.EMA26
                model.DEA = model.DIF * 0.2 + previousModel.DEA * 0.8
                model.MACD = (model.DIF - model.DEA) * 2
                model.minPriceOfNineClock = handleMinPriceOfNineClock(index: idx, models: klineModels)
                model.maxPriceOfNineClock = handleMaxPriceOfNineClock(index: idx, models: klineModels)
                model.RSV9 = handleRSV9(model: model)
                model.KDJ_K = handleKDJ_K(model: model, previousModel: nil)
                model.KDJ_D = handleKDJ_D(model: model, previousModel: nil)
                model.KDJ_J = handleKDJ_J(model: model)
            }
            models.append(model)
        }
        
        return models
    }
    
    private class func handleMA(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double {
        if index == day {
            return model.sumClose / Double(day)
        } else if index > day {
            return (model.sumClose - models[index - day].sumClose) / Double(day)
        } else {
            return 0.0
        }
    }
    
    private class func handleMA_VOLUME(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double {
        if index == day {
            return model.sumVolume / Double(day)
        } else if index > day {
            return (model.sumVolume - models[index - day].sumVolume) / Double(day)
        } else {
            return 0.0
        }
    }
    
    private class func handleEMA(day: Int, model: OKKLineModel, previousEMA: Double) -> Double {
        return Double((day - 1) / (day + 1)) * previousEMA + Double(2 / (day + 1)) * model.close
    }
    
    private class func handleEMA_VOLUME(day: Int, model: OKKLineModel, previousEMA_VOLUME: Double) -> Double {
        return Double((day - 1) / (day + 1)) * previousEMA_VOLUME + Double(2 / (day + 1)) * model.volume
    }
    
    private class func handleMinPriceOfNineClock(index: Int, models: [OKKLineModel]) -> Double {
        var minValue = models[index].low
        let startIndex = index < 9 ? 0 : (index - 9 - 1)

        for i in startIndex..<index {
            if models[i].low < minValue {
                minValue = models[i].low
            }
        }
        return minValue
    }
    
    private class func handleMaxPriceOfNineClock(index: Int, models: [OKKLineModel]) -> Double {
        var maxValue = models[index].high
        let startIndex = index < 9 ? 0 : (index - 9 - 1)
        
        for i in startIndex..<index {
            if models[i].high < maxValue {
                maxValue = models[i].high
            }
        }
        return maxValue
    }
    
    private class func handleRSV9(model: OKKLineModel) -> Double {
        if model.minPriceOfNineClock == model.maxPriceOfNineClock {
            return 100.0
        } else {
            return (model.close - model.minPriceOfNineClock) / (model.maxPriceOfNineClock - model.minPriceOfNineClock)
        }
    }
    
    private class func handleKDJ_K(model: OKKLineModel, previousModel: OKKLineModel?) -> Double {
    
        if previousModel == nil { // 第一个数据
            return (model.RSV9 + 2 * 50) / 3
        } else {
            return (model.RSV9 + 2 * previousModel!.KDJ_K) / 3
        }
    }
    
    private class func handleKDJ_D(model: OKKLineModel, previousModel: OKKLineModel?) -> Double {
        
        if previousModel == nil { // 第一个数据
            return (model.KDJ_K + 2 * 50) / 3
        } else {
            return (model.KDJ_K + 2 * previousModel!.KDJ_D) / 3
        }
    }
    
    private class func handleKDJ_J(model: OKKLineModel) -> Double {
        return model.KDJ_K * 3 - model.KDJ_D * 2
    }
    
    
}
