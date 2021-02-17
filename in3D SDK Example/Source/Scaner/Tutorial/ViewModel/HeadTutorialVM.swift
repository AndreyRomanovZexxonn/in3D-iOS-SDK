//
//  TutorialViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 14.09.2020.
//

import Foundation

class HeadTutorialVM: TutorialViewModel {
    
    // MARK: - Public property
    var videoURL: URL? {
        return Bundle.main.url(forResource: "head_tutorial", withExtension: "mp4")
    }
    
    // MARK: - Private property
    private weak var coordinator: ScannerCoordinator?
    
    // MARK: - Init
    init(coordinator: ScannerCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func nextAction() {
        coordinator?.showFaceScanner()
    }
    
}
