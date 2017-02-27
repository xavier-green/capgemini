//
//  extensionDouble.swift
//  DrawYourVoice
//
//  Created by Gaetan on 02/08/2016.
//  Copyright © 2016 Gaetan. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    
    func roundToN(n numberOfDigits: Int) -> Double {
        
        let converter = NumberFormatter()
        let formatter = NumberFormatter()
        
        formatter.numberStyle = NumberFormatter.Style.none
        formatter.minimumFractionDigits = numberOfDigits
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = numberOfDigits
        
        if let stringFromDouble = formatter.string(from: NSNumber(value: self)) {
            if let doubleFromString = converter.number(from: stringFromDouble) {
                return doubleFromString as Double
            }
        }
        
        return 0
    }
    
}

extension CGVector {
    
    func rotate(radAngle angle: CGFloat) -> CGVector {
        let cosAngle = CGFloat(cos(angle))
        let sinAngle = CGFloat(sin(angle))
        let x = self.dx * cosAngle - self.dy * sinAngle
        let y = self.dx * sinAngle + self.dy * cosAngle
        return CGVector(dx: x, dy: y)
    }
}
