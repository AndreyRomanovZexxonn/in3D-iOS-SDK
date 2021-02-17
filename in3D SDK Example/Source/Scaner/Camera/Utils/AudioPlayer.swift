//
//  AudioPlayer.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 20/03/2020.
//

import AVFoundation
import Foundation

protocol VoiceHints {
    
    var isPlaying: Bool { get }
    func playIntro()
    func playFinished()
    func playCountdown()
    
    func playStepForward()
    func playLegsWider()
    func playHandsWider()
    func playStepBack()
    func playChangeAngle()
    func play2StepsBack()
    func playPutPhoneLower()
    func playPutPhoneHigher()
    func playRemember()
    
    func playRight(completion: (() -> ())?)
    func playLeft(completion: (() -> ())?)
    func playBackMiddle(completion: (() -> ())?)
    func playMiddle(completion: (() -> ())?)
    func playUp(completion: (() -> ())?)
    func playDown(completion: (() -> ())?)
    func playLookCamera(completion: (() -> ())?)
    func playOval(completion: (() -> ())?)
    
    func stop()
    
}

class AudioPlayer: NSObject {
    
    // MARK: - Private properties
    private let speechGenerator = SpeechGenerator()
    private var currentCompletion: (() -> ())?
    
    // MARK: - Public properties
    var currentSound: AVAudioPlayer?
    
    // MARK: - Init
    override init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        super.init()
    }
    
    // MARK: - Public methods
    func play(url: URL) {
        do {
            currentSound = try AVAudioPlayer(contentsOf: url)
            currentSound?.delegate = self
            currentSound?.volume = 0.5
            currentSound?.play()
        } catch {
            print("\(#file): couldn't load \(url)")
        }
    }
    
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let completion = currentCompletion else {
            return
        }
        completion()
        currentCompletion = nil
    }
    
}

extension AudioPlayer: VoiceHints {
    
    func playOval(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "oval", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playLookCamera(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "look_camera", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playRight(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "right", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playLeft(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "left", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playBackMiddle(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "back_middle", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playMiddle(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "middle", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playUp(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "up", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    func playDown(completion: (() -> ())? = nil) {
        guard let url = Bundle.main.url(forResource: "down", withExtension: "m4a") else {
            return
        }
        
        currentCompletion = completion
        play(url: url)
    }
    
    
    func playPutPhoneHigher() {
        speechGenerator.speak(text: "Please put your phone higher and restart.")
    }
    
    func playRemember() {
        speechGenerator.speak(text: "Remember this position. You will need to slowly turn around like this.")
    }
    
    func playPutPhoneLower() {
        speechGenerator.speak(text: "Please put your phone lower and restart.")
    }
    
    func play2StepsBack() {
        speechGenerator.speak(text: "Please take 2 steps back.")
    }
    
    func playStepBack() {
        speechGenerator.speak(text: "You are not fully visible, please take one step back.")
    }
    
    func playStepForward() {
        speechGenerator.speak(text: "You are too far, please take one step forward.")
    }
    
    func playLegsWider() {
        speechGenerator.speak(text: "Please put your legs wider.")
    }
    
    func playHandsWider() {
        speechGenerator.speak(text: "Please put your hands wider.")
    }
    
    func playChangeAngle()  {
        speechGenerator.speak(text: "Please change phone angle.")
    }
    
    var isPlaying: Bool {
        return currentSound?.isPlaying ?? false || speechGenerator.isSpeaking
    }
    
    func playIntro() {
        guard let url = Bundle.main.url(forResource: "intro", withExtension: "m4a") else {
            return
        }
        
        play(url: url)
    }
    
    func playFinished() {
        guard let url = Bundle.main.url(forResource: "finished", withExtension: "m4a") else {
            return
        }
        
        play(url: url)
    }
    
    func playCountdown() {
        guard let url = Bundle.main.url(forResource: "countdown", withExtension: "m4a") else {
            return
        }
        
        play(url: url)
    }
    
    func stop() {
        currentSound?.stop()
    }
    
}
