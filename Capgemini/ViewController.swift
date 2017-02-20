//
//  ViewController.swift
//  Capgemini
//
//  Created by xavier green on 17/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var YesBut: UIButton!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var AccountLabel: UILabel!
    @IBAction func noButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Enrolment", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrolmentViewController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var fileUrl : URL!
    
    func nexView() {
        print("Moving to next storyboard")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("App started")
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        NSLog("Recording allowed")
                        self.recordButton.isHidden = false
                        self.recordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
                        let labelArray: [UILabel] = [self.HelloLabel, self.AccountLabel]
                        self.speak(labels: labelArray)
                        self.YesBut.addTarget(self, action: #selector(self.nexView), for: .touchUpInside)
                    } else {
                        NSLog("Recording disallowed")
                        self.recordButton.isHidden = true
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func doPlay() {
        self.audioPlayer = try! AVAudioPlayer(contentsOf: fileUrl)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.delegate = self
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
    
    func speak( labels: [UILabel]) {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        for label in labels {
            let string = label.text!
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-CA")
            utterance.postUtteranceDelay = 0.2
            utterance.rate = 0.4
            synthesizer.speak(utterance)
        }
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            NSLog("Starting recording")
            startRecording()
        } else {
            NSLog("Stopping recording")
            finishRecording(success: true)
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL!)
        return soundURL as NSURL?
    }
    
    func startRecording() {
        //let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        fileUrl = self.directoryURL()! as URL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Re-record", for: .normal)
            self.doPlay()
        } else {
            recordButton.setTitle("Record", for: .normal)
            // recording failed :(
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

