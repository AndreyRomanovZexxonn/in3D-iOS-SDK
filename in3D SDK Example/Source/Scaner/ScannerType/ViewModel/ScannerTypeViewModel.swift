//
//  ScannerTypeViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21.07.2020.
//

import Foundation

protocol ScannerTypeViewModel {
    
    func tapYes()
    func tapNo()
    
}

class ScannerTypeViewModelImpl: ScannerTypeViewModel {
    
    // MARK; - Private properties
    private weak var coordinator: ScannerCoordination?
    
    // MARK: - Init
    init(coordinator: ScannerCoordination) {
        self.coordinator = coordinator
    }
    
    // MARK: - SourceViewModel
    func tapYes() {
        coordinator?.showHeadPipeline()
    }
    
    func tapNo() {
        coordinator?.showBodyScanner()
    }
    
}
