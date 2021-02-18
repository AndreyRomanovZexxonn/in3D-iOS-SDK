//
//  FaceViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21/05/2020.
//

import CoreMedia
import Foundation
import I3DRecorder
import UIKit
import RxSwift

class FaceViewModel: BaseCameraViewModel {
    
    // MARK: - Private properties
    private let faceDetector = FaceDetector()
    private let angleDetector = AngleDetector()
    private var faceInFrameTime: Date?
    private var inFrameEnough = false
    private var didStart = false
    private var shouldDetect = false {
        didSet {
            faceDetector.shouldDetect = shouldDetect
        }
    }
    private let audioPlayer: VoiceHints = AudioPlayer()
    private var faceFrame: CGRect!
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    override init(recorder: Recorder, coordinator: ScannerCoordination, scanService: ScanService) {
        super.init(recorder: recorder, coordinator: coordinator, scanService: scanService)
        
        angleDetector.rx.state.subscribe(onNext: { [unowned self] state in
            guard self.state != .scanning else {
                return
            }
            
            self.view?.update(angle: state.0)
            
            if state.2 {
                self.view?.showAngle(with: self.angleDetector.targetAngle)
            } else {
                self.view?.hideAngle()
            }
            
            self.shouldDetect = state.1
        }).disposed(by: disposeBag)
        
        faceDetector.detectionCompletion = { [unowned self] (rect, distance) in
            guard let faceView = self.view as? FaceCameraView else {
                return
            }
            
            guard !self.audioPlayer.isPlaying else {
                return
            }
            
            let inFrame = self.faceFrame.contains(rect)
            let distanceOkay: Bool
            
            switch UIDevice.deviceGeneration {
            case .i11:
                distanceOkay = distance < 0.3
            default:
                distanceOkay = distance < 0.5
            }
            
            DispatchQueue.main.async { [unowned faceView] in
                faceView.face(inFrame: inFrame && distanceOkay)
            }
            
            if inFrame, distanceOkay {
                if self.faceInFrameTime == nil {
                    self.faceInFrameTime = Date()
                } else {
                    if !self.didStart, self.inFrameEnough {
                        self.shouldDetect = false
                        self.didStart = true
                        
                        DispatchQueue.main.async { [weak self, weak faceView] in
                            self?.startWriting()
                            self?.state = .scanning
                            
                            faceView?.showInstructionView()
                                self?.audioPlayer.playRight { [weak self] in
                                    faceView?.showRight { [weak self] in
                                        self?.audioPlayer.playBackMiddle { [weak self] in
                                            faceView?.showMiddle { [weak self] in
                                                self?.audioPlayer.playLeft { [weak self] in
                                                    faceView?.showLeft { [weak self] in
                                                        self?.audioPlayer.playMiddle { [weak self] in
                                                            faceView?.showMiddle { [weak self] in
                                                                self?.audioPlayer.playUp { [weak self] in
                                                                    faceView?.showTop { [weak self] in
                                                                        self?.audioPlayer.playMiddle { [weak self] in
                                                                            faceView?.showMiddle { [weak self] in
                                                                                self?.audioPlayer.playDown { [weak self] in
                                                                                    faceView?.showDown { [weak self] in
                                                                                        self?.audioPlayer.playMiddle { [weak self] in
                                                                                            faceView?.showMiddle { [weak self] in
                                                                                                self?.state = .finished
                                                                                                self?.stopCapture()
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        
                        return
                    }
                    
                    if Date().timeIntervalSince(self.faceInFrameTime!) > 1.0, !self.inFrameEnough {
                        self.inFrameEnough = true
                        self.audioPlayer.playLookCamera(completion: nil)
                    }
                }
            } else {
                self.inFrameEnough = false
            }
        }
    }
    
    // MARK: - Recording
    override func finish() {
        coordinator?.showHeadReview()
    }
    
}

extension FaceViewModel: CameraViewModel {
    
    func phoneFixated() {
        
    }
    
    func recordTap() {
        
    }
    
    func tutorialTap() {
        self.audioPlayer.stop()
        coordinator?.showTutorial()
    }
    
    func cancelTap() {
        if state != .finished {
            cancelCapture()
        }
        
        audioPlayer.stop()
        coordinator?.finish()
    }
    
    func ready() {
        prepare(with: faceDetector, and: angleDetector)
        
        guard let faceView = self.view as? FaceCameraView else {
            return
        }
        
        faceFrame = faceView.faceFrame
        audioPlayer.playOval(completion: nil)
    }
    
}
