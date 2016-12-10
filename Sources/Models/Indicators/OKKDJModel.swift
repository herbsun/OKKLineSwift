//
//  OKKDJModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/5.
//
//

import Foundation

struct OKKDJModel {
    
    let klineModels: [OKKLineModel]
    
    init(klineModels: [OKKLineModel]) {
        self.klineModels = klineModels
    }
    
    public func fetchDrawKDJData(drawRange: NSRange? = nil) -> [OKKLineModel] {
        var datas = [OKKLineModel]()
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            let previousModel: OKKLineModel? = index > 0 ? klineModels[index - 1] : nil
            model.minPriceOfNineClock = handleMinPriceOfNineClock(index: index, models: klineModels)
            model.maxPriceOfNineClock = handleMaxPriceOfNineClock(index: index, models: klineModels)
            model.RSV9 = handleRSV9(model: model)
            model.KDJ_K = handleKDJ_K(model: model, previousModel: previousModel)
            model.KDJ_D = handleKDJ_D(model: model, previousModel: previousModel)
            model.KDJ_J = handleKDJ_J(model: model)
            datas.append(model)
        }
        
        if let range = drawRange {
            return Array(datas[range.location...range.location+range.length])
        } else {
            return datas
        }
    }
    
    private func handleMinPriceOfNineClock(index: Int, models: [OKKLineModel]) -> Double {
        var minValue = models[index].low
        let startIndex = index < 9 ? 0 : (index - (9 - 1))
        
        for i in startIndex..<index {
            if models[i].low < minValue {
                minValue = models[i].low
            }
        }
        return minValue
    }
    
    private func handleMaxPriceOfNineClock(index: Int, models: [OKKLineModel]) -> Double {
        var maxValue = models[index].high
        let startIndex = index < 9 ? 0 : (index - (9 - 1))
        
        for i in startIndex..<index {
            if models[i].high < maxValue {
                maxValue = models[i].high
            }
        }
        return maxValue
    }

    private func handleRSV9(model: OKKLineModel) -> Double {
        
        guard let minPrice = model.minPriceOfNineClock,
            let maxPrice = model.maxPriceOfNineClock else {
            return 100.0
        }
        
        if minPrice == maxPrice {
            return 100.0
        } else {
            return (model.close - minPrice) / (maxPrice - minPrice)
        }
    }
    
    private func handleKDJ_K(model: OKKLineModel, previousModel: OKKLineModel?) -> Double {
        
        if previousModel == nil { // 第一个数据
            return (model.RSV9! + 2 * 50) / 3
        } else {
            return (model.RSV9! + 2 * previousModel!.KDJ_K!) / 3
        }
    }
    
    private func handleKDJ_D(model: OKKLineModel, previousModel: OKKLineModel?) -> Double {
        
        if previousModel == nil { // 第一个数据
            return (model.KDJ_K! + 2 * 50) / 3
        } else {
            return (model.KDJ_K! + 2 * previousModel!.KDJ_D!) / 3
        }
    }
    
    private func handleKDJ_J(model: OKKLineModel) -> Double {
        return model.KDJ_K! * 3 - model.KDJ_D! * 2
    }

}
