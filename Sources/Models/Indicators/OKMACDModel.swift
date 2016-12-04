//
//  OKMACDModel.swift
//  OKKLineSwift
//
//  Created by SHB on 2016/12/4.
//
//

import Foundation

class OKMACDModel {

    let klineModels: [OKKLineModel]
    
    init(klineModels: [OKKLineModel]) {
        self.klineModels = klineModels
    }
    
    public func fetchDrawMACDData(drawRange: NSRange? = nil) -> [[Double?]] {
        
        guard klineModels.count > 0 else {
            return []
        }
        
        let ema12Model = OKEMAModel(day: 12, klineModels: klineModels)
        let ema12Datas = ema12Model.fetchDrawEMAData()
        
        let ema26Model = OKEMAModel(day: 26, klineModels: klineModels)
        let ema26Datas = ema26Model.fetchDrawEMAData()
        
        
        var difDatas: [Double?] = []
        var deaDatas: [Double?] = []
        var macdDatas: [Double?] = []
        
        for index in 0..<klineModels.count {
            
            guard let ema12 = ema12Datas[index],
                let ema26 = ema26Datas[index] else {
                
                    difDatas.append(nil)
                    deaDatas.append(nil)
                    macdDatas.append(nil)
                    continue
            }
            
            difDatas.append(ema12 - ema26)
            
            if index > 0 && deaDatas[index - 1] != nil {
                deaDatas.append(difDatas[index]! * 0.2 + deaDatas[index - 1]! * 0.8)
            } else {
                deaDatas.append(difDatas[index]! * 0.2)
            }
            
            macdDatas.append((difDatas[index]! - deaDatas[index]!) * 2)
        }
        
        if let range = drawRange {
            return [Array(difDatas[range.location...range.location+range.length]),
                    Array(deaDatas[range.location...range.location+range.length]),
                    Array(macdDatas[range.location...range.location+range.length])
            ]
        } else {
            return [difDatas, deaDatas, macdDatas]
        }
    }
    
//    private class func handleDIF(model: OKKLineModel) -> Double? {
//        guard let ema12 = model.EMA12,
//            let ema26 = model.EMA26 else {
//                return nil
//        }
//        return ema12 - ema26
//    }
//    
//    private class func handleDEA(model: OKKLineModel, previousModel: OKKLineModel?) -> Double? {
//        
//        guard let dif = model.DIF else {
//            return nil
//        }
//        
//        if let previousDEA = previousModel?.DEA {
//            return dif * 0.2 + previousDEA * 0.8
//        } else {
//            return dif * 0.2
//        }
//    }
//    
//    private class func handleMACD(model: OKKLineModel) -> Double? {
//        guard let dif = model.DIF,
//            let dea = model.DEA else {
//                return nil
//        }
//        return (dif - dea) * 2
//    }
}
