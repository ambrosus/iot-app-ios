//
//  Created by Sergei E. on 12/13/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

import UIKit

class AMISensorTickerBuilder: NSObject {    
    func attributize(text:NSString) {
        
    }
    
    public func tickers(with rec:AMIDeviceRecord, lineHeight:CGFloat, maxEntries:Int) -> [NSAttributedString] {
        let styleConstants = AMIStyleConstants.sharedInstance
        let tickerFont = styleConstants.masterViewCellTickerFont
        let tickerFontSize = tickerFont.pointSize
        var result:[NSAttributedString] = []
        
        if (rec.temperaturePresence != .notSupported) {
            let entry = NSMutableAttributedString.init()
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sensortype-temp.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight + 2, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            entry.append(attStr)
            let valueString = rec.temperaturePresence == .notSampled ? " --" : String(format: " %.0f°C", rec.temperature)
            entry.append(NSAttributedString.init(string: valueString))
            entry.addAttributes([.font : tickerFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                 range: NSRange.init(location: 0, length: entry.length))
            result.append(entry)
        }
        
        if (rec.pressurePresence != .notSupported) {
            let entry = NSMutableAttributedString.init()
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sensortype-prsr.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight + 2, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            entry.append(attStr)
            let valueString = rec.pressurePresence == .notSampled ? " --" : String(format: " %.0fhPa", rec.pressure / 100.0)
            entry.append(NSAttributedString.init(string: valueString))
            entry.addAttributes([.font : tickerFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                range: NSRange.init(location: 0, length: entry.length))
            result.append(entry)
        }
        
        if (rec.humidityPresence != .notSupported) {
            let entry = NSMutableAttributedString.init()
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: "ic-sensortype-humi.pdf", atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: tickerFontSize - lineHeight + 2, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            entry.append(attStr)
            let valueString = rec.humidityPresence == .notSampled ? " --" : String(format: " %.1f%%", rec.humidity)
            entry.append(NSAttributedString.init(string: valueString))
            entry.addAttributes([.font : tickerFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                range: NSRange.init(location: 0, length: entry.length))
            result.append(entry)
        }
        
        return result
    }
    
    public func briefChartLegend(sensorType:AMISensorType, lineHeight:CGFloat) -> NSAttributedString{
        let styleConstants = AMIStyleConstants.sharedInstance
        let legendFont = styleConstants.briefChartSensorLegendFont
        let legendFontSize = legendFont.pointSize
        let result = NSMutableAttributedString.init()
        
        var spriteName:String? = nil
        var legendText:String? = nil
        switch sensorType {
        case .thermometer:
            spriteName = "sensortype-temp"
            legendText = "Temperature"
        case .hygrometer:
            spriteName = "sensortype-humi"
            legendText = "Humidity"
        case .manometer:
            spriteName = "sensortype-prsr"
            legendText = "Pressure"
        case .batteryVoltage:
            spriteName = "battery"
            legendText = "Battery voltage"
        case .batteryPercentage:
            spriteName = "battery"
            legendText = "Battery percentage"
        case .rssi:
            spriteName = "rssi"
            legendText = "RSSI"
        default:
            break
        }
        
        if let spriteName = spriteName {
            let pdfName = "ic-" + spriteName + ".pdf"
            let att = NSTextAttachment.init()
            att.image = UIImage.init(pdfNamed: pdfName, atHeight:lineHeight)
            att.bounds = CGRect.init(x: 0, y: legendFontSize - lineHeight + 1, uptoX: lineHeight, height: lineHeight)
            let attStr = NSMutableAttributedString.init(attachment: att)
            result.append(attStr)
            
            
            result.append(NSAttributedString.init(string: "  " + legendText!))
            result.addAttributes([.font : legendFont, .foregroundColor : styleConstants.dimmedTextColor, .baselineOffset: 0],
                                range: NSRange.init(location: 0, length: result.length))
        }
        
        return result
    }

}
