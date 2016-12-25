//
//  OKBOLLModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/10.
//
//

import Foundation

struct OKBOLLModel {
    
    let indicatorType: OKIndicatorType
    let klineModels: [OKKLineModel]
    
    init(indicatorType: OKIndicatorType, klineModels: [OKKLineModel]) {
        self.indicatorType = indicatorType
        self.klineModels = klineModels
    }
    
    public func fetchDrawBOLLData(drawRange: NSRange? = nil) -> [OKKLineModel] {
        var datas = [OKKLineModel]()
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            model.sumClose = model.close + (index > 0 ? klineModels[index - 1].sumClose! : 0)
            
            switch indicatorType {
            case .BOLL(let day):
                let MA = handleMA(day: day, model: model, index: index, models: klineModels)
                let MD = handleMD(day: day, model: model, MAValue: MA)
                model.BOLL_MB = MA
                model.BOLL_UP = handleUP(MB: model.BOLL_MB, MD: MD)
                model.BOLL_DN = handleDN(MB: model.BOLL_MB, MD: MD)
                
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
    
    private func handleMD(day: Int, model: OKKLineModel, MAValue: Double?) -> Double? {
        if let MA = MAValue {
            return sqrt(pow((model.close - MA), 2) / Double(day))
        }
        return nil
    }
    
    private func handleMA(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double? {
        if day <= 0 || index < (day - 1) {
            return nil
        }
        else if index == (day - 1) {
            return model.sumClose! / Double(day)
        }
        else {
            return (model.sumClose! - models[index - day].sumClose!) / Double(day)
        }
    }
    
    private func handleUP(MB: Double?, MD: Double?) -> Double? {
        if let MB = MB,
            let MD = MD {
            return MB + 2 * MD
        }
        return nil
    }
    
    private func handleDN(MB: Double?, MD: Double?) -> Double? {
        if let MB = MB,
            let MD = MD {
            return MB - 2 * MD
        }
        return nil
    }
}
