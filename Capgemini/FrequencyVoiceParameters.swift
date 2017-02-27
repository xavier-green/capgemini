//
//  File.swift
//  VocalPasswordSwift
//
//  Created by Gaetan on 10/08/2016.
//  Copyright © 2016 Gaetan. All rights reserved.
//

import Foundation

class FrequencyVoiceParameters: NSObject, NSCoding {
    var f0: Double!
    var fmin: Double!
    var fmax: Double!
    var fe: Double!
    
    struct PropertyKey {
        static let f0Key = "f0"
        static let fminKey = "fmin"
        static let fmaxKey = "fmax"
        static let feKey = "fe"
    }
    
    init(mediumFrequency _f0: Double){
        f0 = _f0
        fmin = FrequencyVoiceParameters.getFmin(mediumFrequency: _f0)
        fmax = FrequencyVoiceParameters.getFmax(mediumFrequency: _f0)
        fe = 10.0
    }
    
    fileprivate static func getFmin(mediumFrequency _f0: Double) -> Double {
        return _f0/2.0
    }
    
    fileprivate static func getFmax(mediumFrequency _f0: Double) -> Double {
        return _f0*2.0
    }
    
    func encode(with aCode: NSCoder){
        aCode.encode(f0, forKey: PropertyKey.f0Key)
        aCode.encode(fmin, forKey: PropertyKey.fminKey)
        aCode.encode(fmax, forKey: PropertyKey.fmaxKey)
        aCode.encode(fe, forKey: PropertyKey.feKey)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let _f0 = aDecoder.decodeDouble(forKey: PropertyKey.f0Key)
        
        self.init(mediumFrequency: _f0)
    }
    
}
