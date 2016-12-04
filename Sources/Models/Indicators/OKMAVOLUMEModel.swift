//
//  OKMAVOLUMEModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/4.
//
//

import Foundation

struct OKMAVOLUMEModel {
    let day: Int
    let klineModels: [OKKLineModel]
    
    init(day: Int, klineModels: [OKKLineModel]) {
        self.day = day
        self.klineModels = klineModels
    }
    
    public func fetchDrawMAVOLUMEData(drawRange: NSRange?) -> [Double?] {
        
        var datas: [Double?] = []
        
        guard klineModels.count > 0 else {
            return datas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            if index < (day - 1) {
                datas.append(nil)
            }
            else if index == (day - 1) {
                datas.append(model.sumVolume / Double(day))
            }
            else {
                datas.append((model.sumVolume - klineModels[index - day].sumVolume) / Double(day))
            }
        }
        
        if let range = drawRange {
            return Array(datas[range.location...range.location+range.length])
        } else {
            return datas
        }
    }
//    private class func handleMA_VOLUME(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double? {
//        if index < (day - 1) {
//            return nil
//        }
//        else if index == (day - 1) {
//            return model.sumVolume / Double(day)
//        }
//        else {
//            return (model.sumVolume - models[index - day].sumVolume) / Double(day)
//        }
//    }
}
