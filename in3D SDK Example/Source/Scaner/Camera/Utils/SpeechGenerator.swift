//
//  SpeechGenerator.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 14/11/2019.
//

import AVFoundation
import Foundation

class SpeechGenerator: NSObject {
    
    // MARK: - Private properties
    private let synthesizer = AVSpeechSynthesizer()
    private var currentCompletion: (() -> ())?
    
    // MARK: - Public properties
    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }
    
    // MARK: - Init
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        synthesizer.delegate = self
    }
    
    // MARK: - Public methods
    func speak(text: String, completion: (() -> ())? = nil) {
        currentCompletion = completion
        
        let utterance = AVSpeechUtterance(string: text)
        for voice in AVSpeechSynthesisVoice.speechVoices() {
                if voice.language.contains("en"), voice.quality == .enhanced {
                    if #available(iOS 13.0, *) {
                        if voice.gender == .female {
                            utterance.voice = voice
                            continue
                        }
                    } else {
                        utterance.voice = voice
                    }
                                        
                    break
                }
        }

        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
}

extension SpeechGenerator: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard let completion = currentCompletion else {
            return
        }
        completion()
    }
    
}
