//
//  OKKLineSwift
//
//  Copyright © 2016年 Herb - https://github.com/Herb-Sun/OKKLineSwift
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

struct OKMACDModel {

    let klineModels: [OKKLineModel]
    
    init(klineModels: [OKKLineModel]) {
        self.klineModels = klineModels
    }
    
    public func fetchDrawMACDData(drawRange: NSRange? = nil) -> [OKKLineModel] {
        
        var datas = [OKKLineModel]()
        guard klineModels.count > 0 else {
            return datas
        }
        var lastEMA12: Double?
        var lastEMA26: Double?
        
        for (index, model) in klineModels.enumerated() {
            let previousModel: OKKLineModel? = index > 0 ? klineModels[index - 1] : nil
            
            let ema12 = handleEMA(day: 12, model: model, index: index, previousEMA: lastEMA12)
            let ema26 = handleEMA(day: 26, model: model, index: index, previousEMA: lastEMA26)
            lastEMA12 = ema12
            lastEMA26 = ema26
            model.DIF = handleDIF(EMA12: ema12, EMA26: ema26)
            model.DEA = handleDEA(model: model, previousModel: previousModel)
            model.MACD = handleMACD(model: model)
            
            datas.append(model)
        }
        
        if let range = drawRange {
            return Array(datas[range.location..<range.location+range.length])
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
    
    private func handleDIF(EMA12: Double?, EMA26: Double?) -> Double? {
        guard let ema12 = EMA12,
            let ema26 = EMA26 else {
                return nil
        }
        return ema12 - ema26
    }
    
    private func handleDEA(model: OKKLineModel, previousModel: OKKLineModel?) -> Double? {
        
        guard let dif = model.DIF else {
            return nil
        }
        
        if let previousDEA = previousModel?.DEA {
            return dif * 0.2 + previousDEA * 0.8
        } else {
            return dif * 0.2
        }
    }
    
    private func handleMACD(model: OKKLineModel) -> Double? {
        guard let dif = model.DIF,
            let dea = model.DEA else {
                return nil
        }
        return (dif - dea) * 2
    }
}
