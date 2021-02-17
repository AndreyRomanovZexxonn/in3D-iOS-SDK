//
//  GradientBackgroundView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 30/04/2020.
//

import Foundation
import UIKit

class GradientBackgroundView: UIView {
    
    // MARK: - Private property
    private let gradientLayer: CAGradientLayer

    // MARK: - Init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.Gradient.start.cgColor, UIColor.Gradient.end.cgColor]
        gradient.startPoint = .init(x: 0.5, y: 0.0)
        gradient.endPoint = .init(x: 0.5, y: 1.0)
        self.gradientLayer = gradient

        super.init(frame: frame)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    required init?(coder: NSCoder) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.Gradient.start.cgColor, UIColor.Gradient.end.cgColor]
        self.gradientLayer = gradient

        super.init(coder: coder)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
}
