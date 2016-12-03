//
//  OKMAModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/2.
//
//

import Foundation

class OKMAModel {

    let day: Int
    let klineModels: [OKKLineModel]
    
    init(day: Int, klineModels: [OKKLineModel]) {
        self.day = day
        self.klineModels = klineModels
    }
    
    public func fetchDrawMAData(drawRange: NSRange?) -> [Double?] {
        
        var maDatas: [Double?] = []
        
        guard klineModels.count > 0 else {
            return maDatas
        }
        
        for (index, model) in klineModels.enumerated() {
            
            if index < (day - 1) {
                maDatas.append(nil)
            }
            else if index == (day - 1) {
                maDatas.append(model.sumClose / Double(day))
            }
            else {
                maDatas.append((model.sumClose - klineModels[index - day].sumClose) / Double(day))
            }
        }
        
        if let range = drawRange {
            return Array(maDatas[range.location...range.location+range.length])
        } else {
            return maDatas
        }
    }
    
    
//    private func handleMA(day: Int, model: OKKLineModel, index: Int, models: [OKKLineModel]) -> Double? {
//        if index < (day - 1) {
//            return nil
//        }
//        else if index == (day - 1) {
//            return model.sumClose / Double(day)
//        }
//        else {
//            return (model.sumClose - models[index - day].sumClose) / Double(day)
//        }
//    }
}
