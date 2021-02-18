//
//  FaceDetector.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21/05/2020.
//

import Foundation
import I3DRecorder
import UIKit
import Vision

class FaceDetector {
    
    // MARK: - Public proprty
    var detectionCompletion: ((CGRect, Double) -> ())?
    var shouldDetect = false
    
    // MARK: - Private properties
    private var faceDetectionRequest: VNDetectFaceRectanglesRequest!
    private var currentDepth: CVPixelBuffer!
    
    // MARK: - Init
    init() {
        faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { [unowned self] (request, error) in
            
            if error != nil {
                print("FaceDetection error: \(String(describing: error)).")
            }
            
            guard let faceDetectionRequest = request as? VNDetectFaceRectanglesRequest,
                let results = faceDetectionRequest.results as? [VNFaceObservation] else {
                    return
            }
            
            let width = CGFloat(CVPixelBufferGetWidth(self.currentDepth))
            let height = CGFloat(CVPixelBufferGetHeight(self.currentDepth))
            let x = Int((results.first?.boundingBox.midX ?? 0.5) * width)
            let y = Int((results.first?.boundingBox.midY ?? 0.5) * height)
            let faceMiddle = self.currentDepth.pixelFrom(x: x, y: y)
            
            if let closure = self.detectionCompletion {
                closure(results.first?.boundingBox ?? .zero, Double(faceMiddle ?? 0))
            }
        })
    }
    
    // MARK: - Public methods
    func detectFace(in buffer: CVPixelBuffer, with instrinsic: Any, and depth: CVPixelBuffer) {
        currentDepth = depth
        let exifOrientation = self.exifOrientationForCurrentDeviceOrientation()
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: buffer,
                                                        orientation: exifOrientation,
                                                        options: [VNImageOption.cameraIntrinsics: instrinsic])
        
        
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            do {
                try imageRequestHandler.perform([self.faceDetectionRequest])
            } catch let error as NSError {
                NSLog("Failed to perform FaceRectangleRequest: %@", error)
            }
        }
    }
    
    // MARK: - Private methods
    private func exifOrientationForCurrentDeviceOrientation() -> CGImagePropertyOrientation {
        return exifOrientationForDeviceOrientation(UIDevice.current.orientation)
    }
    
    private func exifOrientationForDeviceOrientation(_ deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
        
        switch deviceOrientation {
        case .portraitUpsideDown:
            return .rightMirrored
            
        case .landscapeLeft:
            return .downMirrored
            
        case .landscapeRight:
            return .upMirrored
            
        default:
            return .leftMirrored
        }
    }
    
}

extension FaceDetector: ImageFilter {
    
    var fps: Int {
        return 2
    }
    
    func process(rgb: CVPixelBuffer, depth: CVPixelBuffer, attachments: Attachments) {
        if shouldDetect {
            detectFace(in: rgb, with: attachments.intrinsic, and: depth)
        }
    }
    
}
