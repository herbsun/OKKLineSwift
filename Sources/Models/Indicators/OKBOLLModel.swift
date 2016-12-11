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

//计算公式
//中轨线=N日的移动平均线
//上轨线=中轨线+两倍的标准差
//下轨线=中轨线－两倍的标准差
//计算过程
//（1）计算MA
//MA=N日内的收盘价之和÷N
//（2）计算标准差MD
//MD=平方根N日的（C－MA）的两次方之和除以N
//（3）计算MB、UP、DN线
//MB=（N－1）日的MA
//UP=MB+k×MD
//DN=MB－k×MD
//（K为参数，可根据股票的特性来做相应的调整，一般默认为2）
