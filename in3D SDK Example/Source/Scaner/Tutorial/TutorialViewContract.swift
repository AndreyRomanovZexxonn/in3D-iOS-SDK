//
//  TutorialContract.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 14.09.2020.
//

import Foundation

protocol TutorialViewModel {
    
    func nextAction()
    var videoURL: URL? { get }
    
}
