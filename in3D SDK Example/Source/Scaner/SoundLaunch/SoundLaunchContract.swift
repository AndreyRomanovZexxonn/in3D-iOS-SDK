//
//  SoundLaunchContract.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 20/03/2020.
//

import Foundation

enum VolumeLevel {
    
    case mute
    case low
    case high
    
}

protocol SoundLaunchView: class {
    
    func update(volume level: VolumeLevel)
    
}

protocol SoundLaunchViewModel: class {
    
    func cancelTap()
    func nextTap()
    var currentVolumeLevel: VolumeLevel { get }
    var view: SoundLaunchView? { get set }
    
}
