//
//  ReconnaissanceVocaleController.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import AVFoundation

class ReconnaissanceVocaleController {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var Server : ServerFunctions!
    private var fileUrl : URL!
    
    var recordingOkay: Bool = false
    
    init() {
        print("App started")
        recordingSession = AVAudioSession.sharedInstance()
        Server = ServerFunctions()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingOkay = true
            //return true
        } catch {
            //return false
        }
    }
    
    func getURL() -> URL {
        return fileUrl
    }
    
    func isRecording() -> Bool {
        if (self.audioRecorder == nil) {
            print("IS NOT RECORDING")
            return false
        } else {
            print("IS RECORDING")
            return true
        }
    }
    
    func startRecording() {
        
        fileUrl = self.directoryURL()! as URL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 8000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        if self.recordingOkay {
            
            print("currently recording...")
            
            do {
                audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
                audioRecorder.record()
            } catch {
                self.finishRecording(success: false)
            }
            
        }
    }
    
    func finishRecording(success: Bool) {
        print("finished recording !")
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func verify(username: String) {
        let base64data = NSData(contentsOf: fileUrl)?.base64EncodedString()
        Server.verify(username: username, audio: base64data!.RFC3986UnreservedEncoded)
    }
    
    func enroll(username: String) {
        let base64data = NSData(contentsOf: fileUrl)?.base64EncodedString()
        Server.enroll(username: username, audio: base64data!.RFC3986UnreservedEncoded)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("recording.wav")
        print(soundURL!)
        return soundURL as NSURL?
    }
    
    func playRecording() {
        self.audioPlayer = try! AVAudioPlayer(contentsOf: fileUrl)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
}
