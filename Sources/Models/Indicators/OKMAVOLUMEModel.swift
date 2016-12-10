//
//  OKMAVOLUMEModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/4.
//
//

import Foundation

struct OKMAVOLUMEModel {
    
    let indicatorType: OKIndicatorType
    let klineModels: [OKKLineModel]
    
    init(indicatorType: OKIndicatorType, klineModels: [OKKLineModel]) {
        self.indicatorType = indicatorType
        self.klineModels = klineModels
    }
    
    public func fetchDrawMAVOLUMEData(drawRange: NSRange?) -> [OKKLineModel] {
        
        var datas = [OKKLineModel]()
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            model.sumVolume = model.volume + (index > 0 ? klineModels[index - 1].sumVolume! : 0)
            
            switch indicatorType {
            case .MA_VOLUME(let days):
                var values = [Double?]()
                for day in days {
                    
                    values.append(handleMA_VOLUME(day: day, model: model, index: index, models: klineModels))
                }
                model.MA_VOLUMEs = values
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
    private func handleMA_VOLUME(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double? {
        if day <= 0 || index < (day - 1) {
            return nil
        }
        else if index == (day - 1) {
            return model.sumVolume! / Double(day)
        }
        else {
            return (model.sumVolume! - models[index - day].sumVolume!) / Double(day)
        }
    }
}
