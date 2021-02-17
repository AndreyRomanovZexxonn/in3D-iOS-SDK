//
//  PickerRowView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/03/2020.
//

import Foundation
import UIKit

enum PickerLineType {
    
    case long
    case short
    
}

class PickerRowView: UIView {
    
    // MARK: - Subviews
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Label.textColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.PickerView.row
        return view
    }()
    
    // MARK: - Public properties
    var height: String = "" {
        didSet {
            heightLabel.text = height
        }
    }
    var lineType: PickerLineType {
        didSet {
            offsetConstraint?.constant = width
        }
    }
    
    // MARK: - Private properties
    private let lineHeight: CGFloat = 2
    private var offsetConstraint: NSLayoutConstraint?
    private var width: CGFloat {
        switch lineType {
        case .long:
            return frame.width / 2
        case .short:
            return frame.width / 4
        }
    }
        
    // MARK: - Init
    init(line type: PickerLineType, frame: CGRect) {
        self.lineType = type
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func layout() {
        backgroundColor = UIColor.View.background
        
        addSubview(heightLabel)
        addSubview(lineView)
        
        let _offsetConstraint = lineView.widthAnchor.constraint(equalToConstant: width)

        let constraints = [
            heightLabel.topAnchor.constraint(equalTo: topAnchor),
            heightLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            _offsetConstraint,
            lineView.leadingAnchor.constraint(equalTo: heightLabel.trailingAnchor, constant: 10),
            lineView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: lineHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    
}
