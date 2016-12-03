//
//  OKEMAModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/2.
//
//

import Foundation

class OKEMAModel {
    let day: Int
    let klineModels: [OKKLineModel]
    
    init(day: Int, klineModels: [OKKLineModel]) {
        self.day = day
        self.klineModels = klineModels
    }
    
    public func fetchDrawEMAData(drawRange: NSRange?) -> [Double?] {
        
        var datas: [Double?] = []
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            let previousEMA: Double? = index > 0 ? datas[index - 1] : nil
            
            if index < (day - 1) {
                datas.append(nil)
            }
            else if previousEMA != nil {
                datas.append(Double(day - 1) / Double(day + 1) * previousEMA! + 2 / Double(day + 1) * model.close)
            }
            else {
                datas.append(2 / Double(day + 1) * model.close)
            }
        }
        
        if let range = drawRange {
            return Array(datas[range.location...range.location+range.length])
        } else {
            return datas
        }
    }
//    private class func handleEMA(day: Int, model: OKKLineModel, index: Int, previousEMA: Double?) -> Double? {
//        if index < (day - 1) {
//            return nil
//        } else {
//            if previousEMA != nil {
//                return Double(day - 1) / Double(day + 1) * previousEMA! + 2 / Double(day + 1) * model.close
//            } else {
//                return 2 / Double(day + 1) * model.close
//            }
//        }
//    }
}
