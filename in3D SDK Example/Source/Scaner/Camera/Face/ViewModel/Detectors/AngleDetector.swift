//
//  AngleDetector.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 30.11.2020.
//

import Foundation
import I3DRecorder
import RxCocoa
import RxSwift

class AngleDetector: NSObject, SensorFilter {
    
    // MARK: - Public property
    let targetAngle = AngleDetector.baseAngle
    
    // MARK: - Private properties
    private let angleMA = MovingAverage(period: 20)
    private static let baseAngle = -0.08
    private var angleTime: Date? = Date()
    private var didSetAngle = false
    fileprivate let _state = PublishSubject<(Double, Bool, Bool)>()
    
    // MARK: - SensorFilter
    func process(accelerometer data: AccelerometerData) {
        var currentAngle = angleMA.addSample(value: data.z)
        currentAngle = (currentAngle * 100.0).rounded() / 100.0
        
        if abs(currentAngle - targetAngle) <= 0.4 {
            currentAngle = targetAngle
        }
        
        if currentAngle != targetAngle {
            angleTime = nil
            didSetAngle = false
            _state.onNext((currentAngle, false, true))
        } else {
            if let angleTime = angleTime {
                if Date().timeIntervalSince(angleTime) > 1, !didSetAngle {
                    didSetAngle = true
                    _state.onNext((currentAngle, true, false))
                }
            } else {
                _state.onNext((currentAngle, false, false))
                angleTime = Date()
            }
        }
    }
    
    func process(gyroscope data: GyroscopeData) {
        
    }
    
    func process(thermal data: ThermalData) {
        
    }
    
}

extension Reactive where Base: AngleDetector {
    
    var state: Observable<(Double, Bool, Bool)> {
        return base._state
    }
    
}
