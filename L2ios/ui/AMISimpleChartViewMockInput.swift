//
//  Created by Sergei E. on 1/3/19.
//  (c) 2019 Ambrosus. All rights reserved.
//  

import UIKit

class AMISimpleChartViewMockInput : NSObject {
    var lineChart: AMISimpleChartView
    var ptCount: Int
    var mean:Double = Double.random(in: 0.1..<0.8)
    
    
    init(_ chartView: AMISimpleChartView, ptCount:Int) {
        self.ptCount = ptCount
        lineChart = chartView
        lineChart.sampleBufferCount = 3600;
        lineChart.pointsCount = 3600;
        
        super.init()
    }
    
    public func updateChart(_ blackout: Bool) {
        switch Int.random(in: 0..<50) {
        case 0:
            mean = Double.random(in: 0.1..<0.9)
        default:
            break
        }
        
        let sigLen = 1
        var signal = [blackout ? Double.nan : Double.random(in: mean-0.02..<mean+0.02)]
        var times = (0..<sigLen).map{x in Double(x)/Double(sigLen)}
        
        let usignal = UnsafeMutablePointer(&signal)
        let utimes = UnsafeMutablePointer(&times)
        
        lineChart.appendSignal(usignal, times: utimes, sigLen: Int32(sigLen))
    }
    
}

