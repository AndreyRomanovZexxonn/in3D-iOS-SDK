//
//  BaseCameraViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 03/02/2020.
//

import AVFoundation
import Foundation
import I3DRecorder
import RxCocoa
import RxSwift

class BaseCameraViewModel: RecorderDelegate {

    // MARK: - Public properties
    weak var coordinator: ScannerCoordination?
    weak var view: CameraView?
    let recorder: Recorder
    var state = I3DRecorder.RecordState.ready
    let scanService: ScanService

    // MARK: - Init
    init(recorder: Recorder, coordinator: ScannerCoordination, scanService: ScanService) {
        self.recorder = recorder
        self.recorder.delegate = self
        self.coordinator = coordinator
        self.scanService = scanService
    }
    
    func prepare(with imageFilter: ImageFilter?, and sensorFilter: SensorFilter?) {
        recorder.prepareForRecord(imageFilter: imageFilter, sensorFilter: sensorFilter) { [unowned self] error in
            if let error = error as? I3DRecordInitError {
                switch error {
                case .cameraSetupError:
                    self.view?.show(error: .initFailed)
                case .cameraAccessDenied, .cameraAccessRestricted:
                    self.view?.show(error: .accessDenied)
                }
            }
            
            print(error)
        }
    }
    
    func finish() {
        
    }
    
    func startWriting() {
        recorder.startRecord()
    }
    
    func cancelCapture() {
        recorder.stopRecord { _, _ in }
    }
    
    func stopCapture() {
        recorder.stopRecord { [unowned self] (sequnce, error) in
            if let error = error {
                self.view?.show(error: .recordFaield)
                return
            }
            
            if let sequence = sequnce {
                self.finish()
            }
        }
    }
    
    func recorder(changed state: I3DRecorder.RecordState) {
        self.state = state
        
        let _state: RecordState
        switch state {
        case .finished:
            _state = .finished
        case .ready:
            _state = .ready
        case .scanning:
            _state = .scanning
        }
        DispatchQueue.main.async { [weak self] in
            self?.view?.update(record: _state)
        }
    }
    
}
