//
//  ServerFunctions.swift
//  Capgemini
//
//  Created by xavier green on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation

class ServerFunctions {
    
    private let BASE_URL: String = "http://82.80.219.196"
    private let SERVER_USERNAME: String = "Capgemini"
    private let SERVER_PASSWORD: String = "12345678"
    private let SCOPE: String = "CAPGEMINI"
    private let VOICE_PRINT_TAG: String = "Mobile"
    private let CONFIG_SET_NAME: String = "Capgemini"

    
    private var Server: ServerConnection!
    private var Parser: NuanceXMLParser!
    
    init() {
        
        Server = ServerConnection()
        Parser = NuanceXMLParser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserListDone), name: NSNotification.Name(rawValue: "USER_LIST"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.verifyDone), name: NSNotification.Name(rawValue: "VERIFY"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.enrollDone), name: NSNotification.Name(rawValue: "ENROLL"), object: nil)
        
    }
    //MARK:
    func getUserList() {
        
        let url: String = "/vocalpassword/vocalpasswordmanager.asmx/GetSpeakersList"
        let params: [[String]] = [["configSetName",CONFIG_SET_NAME],["maxSpeakers","100"]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "USER_LIST")
        
    }
    
    func isUserTrained(speakerId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/IsTrained"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "USER_TRAINED")
        
    }
    
    func deleteAllEnrollSegment(speakerId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/DeleteAllEnrollSegments"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "DELETE_ALL_ENROLL_SEGMENT")
        
    }
    
    func enroll(speakerId: String, audio: String) {
        
        let url: String = "/VocalPassword/VocalPasswordServer.asmx/Enroll"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG],["text","null"],["audio",audio]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "POST", notificationString: "ENROLL")
        
    }
    
    func verify(speakerId: String, audio: String) {
        
        print("Nuance server verification")
        
        let url: String = "/VocalPassword/VocalPasswordServer.asmx/Verify"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG],["text","null"],["audio",audio]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "POST", notificationString: "VERIFY")
        
    }
    
    func getConfigurationSetList() {
        
        let url: String = "/VocalPassword/VocalPasswordManager.asmx/GetConfigurationSetList"
        let params: [[String]] = [["configSetName",SCOPE],["type","ConfigurationSet"]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "CONFIGURATION_SET_LIST")
        
    }
    
    func createSpeaker(sessionId: String, speakerId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/CreateSpeaker"
        let params: [[String]] = [["sessionId",sessionId],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "CREATE_SPEAKER")
        
    }
    
    func getEnrollSegmentsStatus(sessionId: String, speakerId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/GetEnrollSegmentsStatus"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "ENROLL_SEGMENT_STATUS")
        
    }
    
    func deleteSpeaker(sessionId: String, speakerId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/DeleteSpeaker"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "DELETE_SPEAKER")
        
    }
    
    func addSpeakerToGroup(groupId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/AddSpeakerToGroup"
        let params: [[String]] = [["sessionId","0"],["groupId",groupId],["configSetName",CONFIG_SET_NAME]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "ADD_SPEAKER")
        
    }
    
    func getGroupMembers(groupId: String) {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/GetGroupMembers"
        let params: [[String]] = [["sessionId","0"],["groupId",groupId],["configSetName",CONFIG_SET_NAME]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "GET", notificationString: "GROUP_MEMBERS")
        
    }
    
    func identify(groupId: String, audio: String) {
        
        let url: String = "/VocalPassword/VocalPasswordServer.asmx/Identify"
        let params: [[String]] = [["sessionId","0"],["groupId",groupId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG],["text","null"],["audio",audio]]
        
        Server.connectToServer(BASE_URL: BASE_URL,url: url, params: params, method: "POST", notificationString: "IDENTIFY")
        
    }
    

    
    //MARK: Methods
    
    func getUserList(username: String, audio: String) {
        getUserList()
    }
    
    @objc func getUserListDone(notification: NSNotification) {
        let xmlString = notification.object as! String
        print("got users:")
        print(xmlString)
    }
    
    func verify(username: String, audio: String) {
        verify(speakerId: username, audio: audio)
    }
    
    @objc func verifyDone(notification: NSNotification) {
        let xmlString = notification.object as! String
        print("Verify done handler")
        //print(xmlString)
        let isMatched = Parser.extractMatch(xmlString: xmlString)
        print("user is logged in :",isMatched)
    }
    
    func enroll(username: String, audio: String) {
        verify(speakerId: username, audio: audio)
    }
    
    @objc func enrollDone(notification: NSNotification) {
        let xmlString = notification.object as! String
        print("enroll done ?")
        print(xmlString)
    }
    
}
