//
//  TextField.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 27.10.2020.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class TextField: UIView {
    
    // MARK: - Subviews
    fileprivate let textField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.TextField.text
        textField.backgroundColor = UIColor.TextField.background
        textField.autocorrectionType = .no
        textField.clearButtonMode = .unlessEditing
        textField.returnKeyType = .done
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let fieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.TextField.background
        view.layer.cornerRadius = 21
        view.layer.borderColor = UIColor.TextField.border.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Label.red
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    // MARK: - Public properties
    var statusText = "" {
        didSet {
            statusLabel.text = statusText
        }
    }
    var text: String? {
        
        get {
            return textField.text
        }
        
        set {
            textField.text = newValue
        }
        
    }
    var isEnabled: Bool = true {
        didSet {
            textField.isEnabled = isEnabled
        }
    }
    
    // MARK: - Init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }
    
    // MARK: - Private methods
    private func layout() {
        addSubview(fieldContainer)
        addSubview(textField)
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            fieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            fieldContainer.heightAnchor.constraint(equalToConstant: 42),
            
            textField.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
            textField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: 21),
            textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -21),
            textField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

extension Reactive where Base: TextField {
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    
}
