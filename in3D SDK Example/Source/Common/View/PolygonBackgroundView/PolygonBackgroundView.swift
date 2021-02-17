//
//  PolygonBackgroundView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 02/04/2020.
//

import Foundation
import UIKit

class PolygonBackgroundView: UIView {
    
    // MARK: - Subviews
    private let gradientView: GradientBackgroundView = {
        let view = GradientBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "polygons")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.3
        return imageView
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func animate() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 60.0
        rotateAnimation.repeatCount = Float.infinity
        imageView.layer.add(rotateAnimation, forKey: nil)
    }
    
    // MARK: - Private methods
    private func setupView() {
        backgroundColor = .clear
        addSubview(gradientView)
        addSubview(imageView)
        
        let constraints = [
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: -201),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 201),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -282),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 282),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
