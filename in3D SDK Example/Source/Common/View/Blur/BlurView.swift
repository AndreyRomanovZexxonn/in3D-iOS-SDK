//
//  BlurView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 15/04/2020.
//

import Foundation
import UIKit

class BlurView: UIView {
    
    // MARK: - Subviews
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
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
    
    // MARK: - Layout
    func layout() {
        backgroundColor = .clear
        addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
}
