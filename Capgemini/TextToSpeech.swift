//
//  SpeechToText.swift
//  Capgemini
//
//  Created by xavier green on 20/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import Foundation
import AVFoundation

/*
 Class that manages the TextToSpeech synthesizer with Siri frameword
 Parameters:
    - language: "fr-CA"
    - delay between sentences spoken: postUtteranceDelay
    - spoken speed: rate
 */

class TextToSpeech {
    
    var synthesizer = AVSpeechSynthesizer()
    var utterance: AVSpeechUtterance!
    var voice = AVSpeechSynthesisVoice(language: Config.speechLanguage)
    
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
