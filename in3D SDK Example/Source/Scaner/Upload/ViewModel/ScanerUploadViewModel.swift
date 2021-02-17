//
//  UploadViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 19/12/2019.
//

import Foundation
import I3DRecorder
import UIKit
import RxCocoa
import RxSwift

class ScanerUploadViewModel: UploadViewModel {
    
    // MARK: - Public properties
    weak var view: UploadView?
    
    // MARK: - Private properties
    private weak var coordinator: ScannerCoordination?
    private let scanService: ScanService
    private let recording: ScanRecording
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(coordinator: ScannerCoordination,
         scanService: ScanService,
         recording: ScanRecording) {
        self.coordinator = coordinator
        self.scanService = scanService
        self.recording = recording
    }
    
    // MARK: - UploadViewModel
    func ready() {
        scanService.upload(recording: recording.id, progress: { (progress, totalSize) in
            self.view?.upload(progress: progress, totalSize: totalSize)
        }, completion: { [unowned self] scan, error in
            guard error == nil else {
                print(error!)
                self.view?.showError()
                return
            }

            self.finish(offset: 0.5)
        })
    }
    
    func finish(offset time: Double) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + time) { [unowned self] in
            self.coordinator?.showUploadFinish()
        }
    }
    
}

extension ScanerUploadViewModel: ScanServiceDelegate {
    
    func createScan(for recording: ScanRecording, completion: @escaping (String?) -> ()) {
        // Read https://github.com/in3D-io/in3D-iOS-SDK
        fatalError("You should implement this method in order to upload ScanRecroding.")
    }
    
}
