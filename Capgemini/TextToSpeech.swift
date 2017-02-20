//
//  SpeechToText.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech {
    
    var synthesizer = AVSpeechSynthesizer()
    var utterance: AVSpeechUtterance!
    var voice = AVSpeechSynthesisVoice(language: "fr-CA")
    
    func speak(sentences: [String]) {
        for sentence in sentences {
            utterance = AVSpeechUtterance(string: sentence)
            utterance.voice = voice
            utterance.postUtteranceDelay = 0.2
            utterance.rate = 0.4
            synthesizer.speak(utterance)
        }
    }
    
}
