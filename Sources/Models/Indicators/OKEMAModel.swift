//
//  OKEMAModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/2.
//
//

import Foundation

struct OKEMAModel {
    
    let indicatorType: OKIndicatorType
    let klineModels: [OKKLineModel]
    
    init(indicatorType: OKIndicatorType, klineModels: [OKKLineModel]) {
        self.indicatorType = indicatorType
        self.klineModels = klineModels
    }
    
    public func fetchDrawEMAData(drawRange: NSRange? = nil) -> [OKKLineModel] {
        
        var datas = [OKKLineModel]()
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            switch indicatorType {
            case .EMA(let days):
                
                var values = [Double?]()
                
                for (idx, day) in days.enumerated() {
                    
                    let previousEMA: Double? = index > 0 ? datas[index - 1].EMAs?[idx] : nil
                    values.append(handleEMA(day: day, model: model, index: index, previousEMA: previousEMA))
                }
                model.EMAs = values
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
    
    private func handleEMA(day: Int, model: OKKLineModel, index: Int, previousEMA: Double?) -> Double? {
        if day <= 0 || index < (day - 1) {
            return nil
        } else {
            if previousEMA != nil {
                return Double(day - 1) / Double(day + 1) * previousEMA! + 2 / Double(day + 1) * model.close
            } else {
                return 2 / Double(day + 1) * model.close
            }
        }
    }
}
