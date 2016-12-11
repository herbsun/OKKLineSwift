//
//  OKLBOLLModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/10.
//
//

import Foundation

struct OKLBOLLModel {
    
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
            let previousModel: OKKLineModel? = index > 0 ? klineModels[index - 1] : nil
            
            model.sumClose = model.close + (index > 0 ? klineModels[index - 1].sumClose! : 0)
            
            switch indicatorType {
            case .BOLL(let day): break
                
//                model.BOOL_MB = handleMB(day: day, model: model, index: index, models: klineModels)
                
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
    
//    private func handleMB(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double? {
//        if day <= 0 || index < (day - 1) {
//            return nil
//        } else {
//            return nil
//        }
    
            
//        else if index == (day - 1) {
//            return model.sumClose! / Double(day)
//        }
//        else {
//            return (model.sumClose! - models[index - day].sumClose!) / Double(day)
//        }
//    }
    
    private func handleUP() {
        
    }
    
    private func handleDN() {
        
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
