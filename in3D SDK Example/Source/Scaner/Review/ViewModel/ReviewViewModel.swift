//
//  ReviewViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/01/2020.
//

import Foundation

class DefaultReviewViewModel: ReviewViewModel {
    
    // MARK: - Public properties
    var video: URL
    var onApprove: (() -> ())?
    var onRewrite: (() -> ())?
    
    // MARK: - Private properties
    private weak var coordinator: ScannerCoordination?
    
    // MARK: - Init
    init(coordinator: ScannerCoordination, video: URL) {
        self.coordinator = coordinator
        self.video = video
    }
    
    // MARK: - Public methods
    func approve() {
        onApprove?()
    }
    
    func rewrite() {
        onRewrite?()
    }
    
}
