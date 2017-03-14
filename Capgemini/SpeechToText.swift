//
//  SpeechToText.swift
//  Capgemini
//
//  Created by xavier green on 24/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import Speech

// Classe qui va gérer le SpeechToText qui permet la navigation dans l'application avec la voix, le speechToText est fait en meme temps que la voix est enregistrée

class SpeechToText {
    
    // Initialisation du speechRecognizer natif en langue francaise
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "fr-FR"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var textString = ""
    
    func isRecording() -> Bool {
        if audioEngine.isRunning {
            return true
        } else {
            return false
        }
    }
    
    // Fonction appelée lorsque l'on appuye sur le bouton d'enregistrement pour naviger avec la voix
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        // C'est ici que se fait le reconnaissance, tache asynchrone
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            // isFinal est appelée lorsque la fonction décèle que la personne a fini de parler
            var isFinal = false  //8
            
            if result != nil {
                
                self.textString = (result?.bestTranscription.formattedString)!
                //print("current text: ",self.textString)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                // Lorsque la requête est terminée une notification est renvoyée au front pour informer le main thread que le processing est fini
                NotificationCenter.default.post(name: Notification.Name(rawValue: "DONE_SPEECH_TO_TEXT"), object: self.textString)
                self.textString=""
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func getResult() -> String {
        return textString
    }
    
    // Vérifie que l'application a bien les permissions necessaires a l'acces du microphone
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("microphone available")
        } else {
            print("microphone not available")
        }
    }
    
}
