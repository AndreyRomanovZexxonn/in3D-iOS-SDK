//
//  AngleView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 11/05/2020.
//

import Foundation
import UIKit
import RxSwift

class AngleView: UIView{
    
    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Please rotate your phone and put on a required angle and wait for instructions."
        label.textColor = UIColor.Label.textColor
        label.textAlignment = .center
        return label
    }()
    private let scaleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.View.grayBackground
        return view
    }()
    private let notchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.View.lightBackground
        return view
    }()
    private let indexView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.View.tintBackground
        return view
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.isHidden = true
        return button
    }()
    private let restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.dark
        button.setBackgroundImage(UIImage(named: "cancel"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Public properties
    var currentAngle: Double = 0 {
        didSet {
            let constant = scaleView.frame.height * (CGFloat(currentAngle) + 1) / 2
            currentConstraint?.constant = constant >= scaleView.frame.height ? scaleView.frame.height - indexHeight : constant
        }
    }
    var targetAngle: Double = 0 {
        didSet {
            let constant = scaleView.frame.height * (CGFloat(targetAngle) + 1) / 2
            targetConstraint?.constant = constant >= scaleView.frame.height ? scaleView.frame.height - indexHeight : constant
        }
    }
    var caption: String = "" {
        didSet {
            titleLabel.text = caption
        }
    }
    
    // MARK: - Private properties
    private let indexHeight: CGFloat = 15
    private var targetConstraint: NSLayoutConstraint?
    private var currentConstraint: NSLayoutConstraint?
    private let disposeBag = DisposeBag()
    
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
        backgroundColor = UIColor.View.background
        
        addSubview(titleLabel)
        addSubview(scaleView)
        addSubview(notchView)
        addSubview(indexView)
        addSubview(nextButton)
        addSubview(restartButton)
        
        currentConstraint = indexView.topAnchor.constraint(equalTo: scaleView.topAnchor)
        targetConstraint = notchView.topAnchor.constraint(equalTo: scaleView.topAnchor)
        
        NSLayoutConstraint.activate([
            restartButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            restartButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            restartButton.heightAnchor.constraint(equalToConstant: 25),
            restartButton.widthAnchor.constraint(equalToConstant: 25),
            
            nextButton.centerYAnchor.constraint(equalTo: restartButton.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            scaleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scaleView.widthAnchor.constraint(equalToConstant: 80),
            scaleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scaleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80),
            
            targetConstraint!,
            notchView.leadingAnchor.constraint(equalTo: scaleView.leadingAnchor),
            notchView.trailingAnchor.constraint(equalTo: scaleView.trailingAnchor),
            notchView.heightAnchor.constraint(equalToConstant: indexHeight),
            
            currentConstraint!,
            indexView.leadingAnchor.constraint(equalTo: scaleView.leadingAnchor),
            indexView.trailingAnchor.constraint(equalTo: scaleView.trailingAnchor),
            indexView.heightAnchor.constraint(equalToConstant: indexHeight)
        ])
    }
    
}
