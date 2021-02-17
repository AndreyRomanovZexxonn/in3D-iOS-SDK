//
//  CameraContract.swift
//  Recorder
//
//  Created by Булат Якупов on 09/10/2019.
//  Copyright © 2019 Булат Якупов. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

enum CameraError {
    
    case initFailed
    case accessDenied
    case recordFaield
    
}

enum PoseAlert {
    
    case knees
    case interfere
    
}

protocol CameraView: class {

    func update(record state: RecordState)
    func present(activity: UIViewController)
    func showCountDown(to value: Int)
    func brightness(isOkay: Bool)
    func showAngle(with target: Double)
    func hideAngle()
    func update(angle: Double)
    func show(error: CameraError)
    func show(alert: PoseAlert)

}

protocol CameraViewModel: class {

    func phoneFixated()
    func recordTap()
    func tutorialTap()
    func cancelTap()
    func ready()
    var view: CameraView? { get set }
    
}

enum RecordState {

    case ready
    case scanning
    case finished

}
