//
//  SoundLaunchViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 20/03/2020.
//

import AVFoundation
import Foundation
import MediaPlayer
import NotificationCenter
import RxCocoa
import RxSwift

class SoundLaunchViewModelImpl: NSObject {
    
    // MARK: - Public properties
    weak var view: SoundLaunchView?
    var volumeLevel: Observable<VolumeLevel> {
        return _volumeLevel
    }
    
    // MARK: - Private properties
    private weak var coordinator: ScannerCoordination?
    private var observation: NSKeyValueObservation?
    private let _volumeLevel = PublishSubject<VolumeLevel>()
    
    // MARK: - Init
    init(coordinator: ScannerCoordination) {
        self.coordinator = coordinator
        super.init()

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self,
                                     forKeyPath: "outputVolume",
                                     options: NSKeyValueObservingOptions.new,
                                     context: nil)
        } catch {
            print("Error")
        }
    }
    
    deinit {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
    }
    
    // MARK: - Private methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume"{
            let level = currentVolumeLevel
            _volumeLevel.onNext(level)
            view?.update(volume: level)
        }
    }
    
}

extension SoundLaunchViewModelImpl: SoundLaunchViewModel {
    
    var currentVolumeLevel: VolumeLevel {
        let volume = AVAudioSession.sharedInstance().outputVolume
        
        if volume == 0.0 {
            return .mute
        }
        
        if volume < 0.5 {
            return .low
        }
        
        return .high
    }
    
    func cancelTap() {
        coordinator?.finish()
    }
    
    func nextTap() {
        
    }
    
}
