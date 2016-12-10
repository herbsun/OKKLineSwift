//
//  OKEMAVOLUMEModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/4.
//
//

import Foundation

struct OKEMAVOLUMEModel {
    
    let indicatorType: OKIndicatorType
    let klineModels: [OKKLineModel]
    
    init(indicatorType: OKIndicatorType, klineModels: [OKKLineModel]) {
        self.indicatorType = indicatorType
        self.klineModels = klineModels
    }
    
    public func fetchDrawEMAVOLUMEData(drawRange: NSRange?) -> [OKKLineModel] {
        
        var datas = [OKKLineModel]()
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {

            switch indicatorType {
            case .EMA_VOLUME(let days):
                
                var values = [Double?]()
                
                for (idx, day) in days.enumerated() {
                    
                    let previousEMA_VOLUME: Double? = index > 0 ? datas[index - 1].EMA_VOLUMEs?[idx] : nil
                    values.append(handleEMA_VOLUME(day: day, model: model, index: index, previousEMA_VOLUME: previousEMA_VOLUME))
                }
                model.EMA_VOLUMEs = values
            default:
                break
            }
            datas.append(model)
        }
        
        if let range = drawRange {
            return Array(datas[range.location...range.location+range.length])
        } else {
            return datas
        }
    }
    
    private func handleEMA_VOLUME(day: Int, model: OKKLineModel, index: Int, previousEMA_VOLUME: Double?) -> Double? {
        if day <= 0 || index < (day - 1) {
            return nil
        } else {
            if previousEMA_VOLUME != nil {
                return Double(day - 1) / Double(day + 1) * previousEMA_VOLUME! + 2 / Double(day + 1) * model.volume
            } else {
                return 2 / Double(day + 1) * model.volume
            }
        }
    }
}
