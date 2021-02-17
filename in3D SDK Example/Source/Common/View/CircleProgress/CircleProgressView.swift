//
//  CircleProgressView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 16/04/2020.
//

import Foundation
import UIKit

class CircleProgressView: UIView {
    
    // MARK: - Subviews
    private let circle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.Label.textColor
        return label
    }()
    
    // MARK: - Public properties
    var progress: Double = 0.0 {
        didSet {
            progressLayer.strokeEnd = CGFloat(progress)
        }
    }
    var text = "" {
        didSet {
            label.text = text
        }
    }
    
    // MARK: - Private properties
    private let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.ProgressView.progressTint.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 0.0
        layer.lineWidth = 2.0
        return layer
    }()
    private let baseLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.ProgressView.background.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 1.0
        layer.lineWidth = 2.0
        return layer
    }()
    
    // MARK: - Init
    convenience init() {
        self.init(frame: .zero)
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    // MARK: - Lifecycle
    func layout() {
        addSubview(circle)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: leadingAnchor),
            circle.trailingAnchor.constraint(equalTo: trailingAnchor),
            circle.topAnchor.constraint(equalTo: topAnchor),
            circle.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        layer.addSublayer(baseLayer)
        layer.addSublayer(progressLayer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midY, startAngle: -CGFloat(Double.pi / 2), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        progressLayer.path = circlePath.cgPath
        baseLayer.path = circlePath.cgPath
        
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
}
