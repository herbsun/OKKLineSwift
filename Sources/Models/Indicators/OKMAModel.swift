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
    let dataSource: [OKKLineModel]
    
    init(day: Int, dataSource: [OKKLineModel]) {
        self.day = day
        self.dataSource = dataSource
    }
    
    public func fetchMADataSource() -> [Double?]? {
        
        var maDatas: [Double?]?
        guard dataSource.count > 0 else {
            return maDatas
        }
        
        for (index, model) in dataSource.enumerated() {
            
            if index < (day - 1) {
                maDatas?.append(nil)
            }
            else if index == (day - 1) {
                maDatas?.append(model.sumClose / Double(day))
                
            }
            else {
                maDatas?.append((model.sumClose - dataSource[index - day].sumClose) / Double(day))
            }
        }
        return maDatas
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
