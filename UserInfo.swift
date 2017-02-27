//
//  UserInfo.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation

class UserInfo: NSObject, NSCoding {
    
    // MARK: Properties
    var userID: String = GlobalVariables.username
    var frequencyParameters: FrequencyVoiceParameters?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("UserInfo")
    
    // MARK: Types
    struct PropertyKey {
        static let userIDKey = "userID"
        static let frequencyParametersKey = "frequencyParameters"
    }
    
    // MARK: Initialization
    init(userID _userID: String) {
        userID = _userID
        
        super.init()
    }
    init(userID _userID: String, frequencyParameters _frequencyParameters: FrequencyVoiceParameters) {
        userID = _userID
        frequencyParameters = _frequencyParameters
        
        super.init()
    }
    
    // MARK: NSCoding
    
    func encode(with aCode: NSCoder){
        aCode.encode(userID, forKey: PropertyKey.userIDKey)
        if let parameters = frequencyParameters {
            aCode.encode(parameters, forKey: PropertyKey.frequencyParametersKey)
        }
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let _userID = aDecoder.decodeObject(forKey: PropertyKey.userIDKey) as! String
        let _frequencyParameters = aDecoder.decodeObject(forKey: PropertyKey.frequencyParametersKey) as? FrequencyVoiceParameters
        
        if _frequencyParameters != nil {
            self.init(userID: _userID, frequencyParameters: _frequencyParameters!)
        }
        else {
            self.init(userID: _userID)
        }
        
    }
    
    
}

