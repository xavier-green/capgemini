//
//  ServerConnection.swift
//  Capgemini
//
//  Created by xavier green on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
import Foundation

/* 
    Classe qui va gérer toutes les connexions au serveur de nuance
 */

class ServerConnection {
    
    init() {
        print("Initialising nuance server connection")
    }
    
    private let BASE_URL: String = Config.nuanceURL
    private let SERVER_USERNAME: String = Config.nuanceUsername
    private let SERVER_PASSWORD: String = Config.nuancePassword
    private let SCOPE: String = Config.nuanceScope
    private let VOICE_PRINT_TAG: String = Config.nuanceVoicePrintTag
    private let CONFIG_SET_NAME: String = Config.nuanceConfig
    
    private var resultData: String = ""
    
    func connectToServer(url: String, params: [[String]], method: String, notificationString: String) -> String {
        
        if method=="GET" {
            
            let connectionUrl = constructURL(base: BASE_URL, url: url, params: params)
            return getRequest(connectionUrl: connectionUrl, notificationString: notificationString)
            
        } else if method=="POST" {
            
            return postRequest(connectionUrl: BASE_URL+url, params: params, notificationString: notificationString)
            
        }
        
        return ""
        
    }
    
    // Requête GET
    func getRequest(connectionUrl: String, notificationString: String) -> String {
        
        print("Connecting to ",connectionUrl)
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest=TimeInterval(20)
        config.timeoutIntervalForResource=TimeInterval(20)
        let authString = constructHeaders()
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let url = URL(string: connectionUrl)!
        let request = URLRequest(url: url)
        
        return sendRequest(session: session, request: request, notificationString: notificationString)
        
    }
    
    // Requête POST
    func postRequest(connectionUrl: String, params: [[String]], notificationString: String) -> String {
        
        print("Connecting to ",connectionUrl)
        
        let postParams = constructParams(params: params)
        let sendData = postParams.data(using: String.Encoding.utf8)
        
        //print(postParams)
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest=TimeInterval(20)
        config.timeoutIntervalForResource=TimeInterval(20)
        let authString = constructHeaders()
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let url = URL(string: connectionUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        return sendRequest(session: session, request: request, notificationString: notificationString)
        
    }
    
    // Envoi de la requête, qui lors de sa finalisation enverra une notification au front
    func sendRequest(session: URLSession, request: URLRequest, notificationString: String) -> String {
        
        print("sending request")
        let start = NSDate()
        let semaphore = DispatchSemaphore(value: 0)
        var dataString: String?
        var errors: String?
        
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "TIME_OUT_NUANCE"), object: errors)
                let end = NSDate()
                let timeInterval: Double = end.timeIntervalSince(start as Date)
                print("Time to evaluate problem: \(timeInterval) seconds")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                print("******** REQUEST ERROR")
                errors = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ERROR_NUANCE"), object: errors)
                return
            }
            dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
            //print(dataString)
            
            semaphore.signal()
            
            print("Done, sending notification: ",notificationString)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationString), object: dataString)
            
        }).resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error = errors {
            print(error)
        }
    
        return dataString!
        
    }
    
    // Construction des headers d'authentification pour nuance
    func constructHeaders() -> String {
        
        let loginString = String(format: "%@:%@", SERVER_USERNAME, SERVER_PASSWORD)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authString = "Basic \(base64LoginString)"
        return authString
        
    }
    
    // Construction de l'url GET à partir de la base, de la page à query et des paramètres éventuels
    func constructURL(base: String, url: String, params: [[String]]) -> String {
        
        var finalUrl = base + url + "?"
        for param in params {
            finalUrl += param[0]+"="+param[1]+"&"
        }
        return finalUrl
        
    }
    
    // Construction de l'url POST à partir de la page à query et des paramètres éventuels
    func constructParams(params: [[String]]) -> String {
        
        var finalUrl = ""
        for param in params {
            finalUrl += param[0]+"="+param[1]+"&"
        }
        return finalUrl
        
    }
    
    // Fetch de la liste des utilisateurs inscrits chez Nuance (pour qu'il n'y ait pas de conflits lors d'un nouvel enrollement)
    func getUserList() -> String {
        
        let url: String = "/vocalpassword/vocalpasswordmanager.asmx/GetSpeakersList"
        let params: [[String]] = [["configSetName",CONFIG_SET_NAME],["maxSpeakers","500"]]
        
        return connectToServer(url: url, params: params, method: "GET", notificationString: "USER_LIST")
        
    }
    
    // Test pour voir si un utilisateur à déjà un enrollement en cours, et si oui combien d'enregistrements doit il encore faire
    func isUserTrained(speakerId: String) -> String {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/IsTrained"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG]]
        
        return connectToServer(url: url, params: params, method: "GET", notificationString: "USER_TRAINED")
        
    }
    
    // Suppresssion de tous les enregistrements audio pour un utilisateur déjà enrôlé
    func deleteAllEnrollSegment(speakerId: String) -> String {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/DeleteAllEnrollSegments"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG]]
        
        return connectToServer(url: url, params: params, method: "GET", notificationString: "DELETE_ALL_ENROLL_SEGMENT")
        
    }
    
    // Enrollement d'un utilisateur à partir de son pseudo et de son enregistrement audio en base64
    func enroll(speakerId: String, audio: String) -> String {
        
        print("Nuance server enrollment")
        //print(audio)
        
        let url: String = "/VocalPassword/VocalPasswordServer.asmx/Enroll"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG],["text","null"],["audio",audio]]
        
        return connectToServer(url: url, params: params, method: "POST", notificationString: "ENROLL")
        
    }
    
    // Authentification d'un utilisateur à partir de son pseudo et de son enregistrement audio en base64
    func verify(speakerId: String, audio: String) -> String {
        
        print("Nuance server verification")
        
        let url: String = "/VocalPassword/VocalPasswordServer.asmx/Verify"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG],["text","null"],["audio",audio]]
        
        return connectToServer(url: url, params: params, method: "POST", notificationString: "VERIFY")
        
    }
    
    // Permet de savoir le nombre d'enregistrements restants pour un enrôlement
    func getEnrollSegmentsStatus(speakerId: String) -> String {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/GetEnrollSegmentsStatus"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME],["voiceprintTag",VOICE_PRINT_TAG]]
        
        return connectToServer(url: url, params: params, method: "GET", notificationString: "ENROLL_SEGMENT_STATUS")
        
    }
    
    // Supprimer un utilisateur de nuance à partir de son pseudo
    func deleteSpeaker(speakerId: String) -> String {
        
        let url: String = "/vocalpassword/vocalpasswordserver.asmx/DeleteSpeaker"
        let params: [[String]] = [["sessionId","0"],["speakerId",speakerId],["configSetName",CONFIG_SET_NAME]]
        
        return connectToServer(url: url, params: params, method: "GET", notificationString: "DELETE_SPEAKER")
        
    }
    
}
