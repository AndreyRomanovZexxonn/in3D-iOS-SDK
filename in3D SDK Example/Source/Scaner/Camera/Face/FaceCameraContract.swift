//
//  FaceCameraContract.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21/05/2020.
//

import Foundation
import CoreGraphics

protocol FaceCameraView: CameraView {
    
    var faceFrame: CGRect { get }
    func face(inFrame: Bool)
    func hideInstruction()
    func showInstructionView()
    func showLeft(completion: @escaping (() -> ()))
    func showRight(completion: @escaping (() -> ()))
    func showMiddle(completion: @escaping (() -> ()))
    func showDown(completion: @escaping (() -> ()))
    func showTop(completion: @escaping (() -> ()))
    
}
