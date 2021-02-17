//
//  BodyTutorialVM.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 14.09.2020.
//

import Foundation

class BodyTutorialVM: TutorialViewModel {
    
    // MARK: - Public property
    var videoURL: URL? {
        return Bundle.main.url(forResource: "Instruction", withExtension: "mp4")
    }
    
    // MARK: - Private property
    private weak var coordinator: ScannerCoordinator?
    
    // MARK: - Init
    init(coordinator: ScannerCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func nextAction() {
        coordinator?.showHeight()
    }
    
}
