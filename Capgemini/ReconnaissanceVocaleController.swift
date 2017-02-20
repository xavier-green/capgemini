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
    private var fileUrl : URL!
    
    var recordingOkay: Bool = false
    
    func initAndCheck() -> Bool {
        print("App started")
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingOkay = true
            return true
        } catch {
            return false
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
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
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
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("recording.m4a")
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
