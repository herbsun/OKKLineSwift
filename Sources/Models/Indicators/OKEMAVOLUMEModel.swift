//
//  OKEMAVOLUMEModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/4.
//
//

import Foundation

struct OKEMAVOLUMEModel {
    
    let day: Int
    let klineModels: [OKKLineModel]
    
    init(day: Int, klineModels: [OKKLineModel]) {
        self.day = day
        self.klineModels = klineModels
    }
    
    public func fetchDrawEMAVOLUMEData(drawRange: NSRange?) -> [Double?] {
        
        var datas: [Double?] = []
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            let previousData: Double? = index > 0 ? datas[index - 1] : nil
            
            if index < (day - 1) {
                datas.append(nil)
            }
            else if previousData != nil {
                datas.append(Double(day - 1) / Double(day + 1) * previousData! + 2 / Double(day + 1) * model.volume)
            }
            else {
                datas.append(2 / Double(day + 1) * model.volume)
            }
        }
        
        if let range = drawRange {
            return Array(datas[range.location...range.location+range.length])
        } else {
            return datas
        }
    }
    
//    private class func handleEMA_VOLUME(day: Int, model: OKKLineModel, index: Int, previousEMA_VOLUME: Double?) -> Double? {
//        if index < (day - 1) {
//            return nil
//        } else {
//            if previousEMA_VOLUME != nil {
//                return Double(day - 1) / Double(day + 1) * previousEMA_VOLUME! + 2 / Double(day + 1) * model.volume
//            } else {
//                return 2 / Double(day + 1) * model.volume
//            }
//        }
//    }
}
