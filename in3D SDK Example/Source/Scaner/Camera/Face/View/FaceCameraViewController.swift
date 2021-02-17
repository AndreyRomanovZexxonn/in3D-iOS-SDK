//
//  FaceCameraViewController.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21/05/2020.
//

import AVFoundation
import Foundation
import UIKit

class FaceCameraViewController: BaseCameraViewController {
    
    // MARK: - Subviews
    let faceView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "oval")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.Image.red
        return imageView
    }()
    let instructionView: FaceInstructionView = {
        let view = FaceInstructionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func layoutViews() {
        super.layoutViews()
        
        angleView.caption = "Hold the phone at the required angle and then fit the face to the oval."
        
        recordButton.isHidden = true
        
        view.insertSubview(faceView, belowSubview: angleView)
        view.addSubview(instructionView)
        
        NSLayoutConstraint.activate([
            faceView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            faceView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            faceView.widthAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 0.65),
            faceView.heightAnchor.constraint(equalTo: previewView.heightAnchor, multiplier: 0.65),
            
            instructionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            instructionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            instructionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            instructionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
}

extension FaceCameraViewController: FaceCameraView {
    
    func hideInstruction() {
        instructionView.isHidden = true
    }
    
    func showInstructionView() {
        instructionView.isHidden = false
    }
    
    func showLeft(completion: @escaping (() -> ())) {
        instructionView.turnHeadLeft(completion: completion)
    }
    
    func showRight(completion: @escaping (() -> ())) {
        instructionView.turnHeadRight(completion: completion)
    }
    
    func showMiddle(completion: @escaping (() -> ())) {
        instructionView.turnHeadMiddle(completion: completion)
    }
    
    func showDown(completion: @escaping (() -> ())) {
        instructionView.turnHeadDown(completion: completion)
    }
    
    func showTop(completion: @escaping (() -> ())) {
        instructionView.turnHeadUp(completion: completion)
    }
    
    
    var faceFrame: CGRect {
        return .init(x: 0.125, y: 0.125, width: 0.75, height: 0.75)
    }
    
    func face(inFrame: Bool) {
        faceView.tintColor = inFrame ? UIColor.Image.faceTint : UIColor.Image.red
    }
    
}
