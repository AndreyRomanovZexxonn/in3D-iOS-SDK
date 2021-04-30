//
//  TapCameraViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 03/02/2020.
//

import Foundation
import I3DRecorder
import RxCocoa
import RxSwift

class TapCameraViewModel: BaseCameraViewModel {

    // MARK: - Private methods
    private let voiceHints: VoiceHints
    private var mainItem: DispatchWorkItem?
    private var countdownItems = [DispatchWorkItem]()
    private var finishItem: DispatchWorkItem?
    private var canTap = true
    private let bottomFilter = BottomFilter()
    private let disposeBag = DisposeBag()
    private var shouldBlockBottom = false
    
    init(recorder: Recorder, settings: RecorderSettings, scanService: ScanService, coordinator: ScannerCoordination, voiceHints: VoiceHints) {
        self.voiceHints = voiceHints
        super.init(recorder: recorder, settings: settings, coordinator: coordinator, scanService: scanService)
        
        bottomFilter.rx.block.subscribe(onNext: { [unowned self] shouldBlock in
            self.shouldBlockBottom = shouldBlock
        }).disposed(by: disposeBag)
    }
    
    override func finish() {
        coordinator?.showBodyReview()
    }
    
    // MARK: - Private methods
    private func blockBottom() {
        bottomFilter.shouldDetectBottom = false
        view?.show(alert: .interfere)
    }
    
}

extension TapCameraViewModel: CameraViewModel {
    
    func phoneFixated() {
        voiceHints.playIntro()
        bottomFilter.shouldDetectBottom = true
    }
    
    func recordTap() {
        if shouldBlockBottom {
            blockBottom()
            return
        }
        
        if canTap {
            switch state {
            case .ready:
                canTap.toggle()
                voiceHints.stop()
                voiceHints.playCountdown()
                view?.showCountDown(to: 5)
                
                let countDownStart = DispatchTime.now()
                
                let workItem = DispatchWorkItem.init { [weak self] in
                    let recordStart = DispatchTime.now()
                    
                    self?.view?.showCountDown(to: 10)
                    self?.startWriting()
                    
                    self?.state = .scanning
                    
                    let item = DispatchWorkItem.init { [weak self] in
                        self?.state = .finished
                        self?.stopCapture()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: recordStart + 10.0, execute: item)
                    
                    self?.finishItem = item
                }
                
                DispatchQueue.main.asyncAfter(deadline: countDownStart + 6.0, execute: workItem)
                mainItem = workItem
                
            case .scanning:
                voiceHints.stop()
                state = .finished
                stopCapture()
            default:
                break
            }
        }
    }
    
    func tutorialTap() {
        self.voiceHints.stop()
        coordinator?.showTutorial()
    }
    
    func cancelTap() {
        if state != .finished {
            cancelCapture()
        }
        
        mainItem?.cancel()
        finishItem?.cancel()
        countdownItems.forEach { $0.cancel() }
        
        voiceHints.stop()
        coordinator?.finish()
    }
    
    func ready() {
        prepare(with: bottomFilter, and: nil)
        view?.show(alert: .knees)
    }
    
}
