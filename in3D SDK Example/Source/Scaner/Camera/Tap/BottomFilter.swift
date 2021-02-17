//
//  BottomFilter.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 30.11.2020.
//

import CoreVideo
import Foundation
import I3DRecorder
import RxCocoa
import RxSwift

class BottomFilter: NSObject, ImageFilter {
    
    // MARK: - Private property
    private let bottomMA = MovingAverage()
    fileprivate let _block = PublishSubject<Bool>()
    private var shouldBlockBottom = false
    
    // MARK: - Public properties
    var shouldDetectBottom = false
    let fps = 1
    
    func process(rgb: CVPixelBuffer, depth: CVPixelBuffer, attachments: Attachments) {
        guard shouldDetectBottom else {
            return
        }
        
        let buffer = depth
        
        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        
        var bottomDistance = [Float]()
        for x in (width / 2 - 50)..<(width / 2 + 50) {
            if let pixelValue = buffer.pixelFrom(x: x, y: height - 10), pixelValue.isNormal {
                bottomDistance.append(pixelValue)
            }
        }
        var _bottomDistance = Double(bottomDistance.reduce(0, +) / Float(bottomDistance.count))
        _bottomDistance = bottomMA.addSample(value: _bottomDistance)
        
        _block.onNext(_bottomDistance < 0.4)
    }
    
}

extension Reactive where Base: BottomFilter {
    
    var block: Observable<Bool> {
        return base._block
    }
    
}
