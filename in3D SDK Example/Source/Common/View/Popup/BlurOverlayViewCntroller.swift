//
//  BlurOverlayView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 31/03/2020.
//

import Foundation
import UIKit
import RxSwift

class BlurOverlayViewController: UIViewController {
    
    // MARK: - Subviews
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    private let popupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.View.background
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.Label.background
        label.textColor = UIColor.Label.textColor
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "check")
        return imageView
    }()
    private let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.background
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.layer.cornerRadius = 25
        return button
    }()
    
    // MARK: - Private properties
    private let text: String
    private let withCheck: Bool
    private let withButton: Bool
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(text: String, withCheck: Bool, withButton: Bool, completion: (() -> ())? = nil) {
        self.text = text
        self.withCheck = withCheck
        self.withButton = withButton
        super.init(nibName: nil, bundle: nil)
        
        okButton.rx.tap.subscribe(onNext: { _ in
            completion?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = text
        
        setupViews()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = .clear
        
        view.addSubview(blurView)
        view.addSubview(popupView)
        popupView.addSubview(label)
        
        var constraints = [
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            
            label.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20)
        ]
        
        if withCheck {
            popupView.addSubview(imageView)
            
            constraints.append(contentsOf: [
                imageView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
                imageView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20),
                imageView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
                
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20)
            ])
        }
        
        if withButton {
            popupView.addSubview(okButton)
            
            constraints.append(contentsOf: [
                okButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25),
                okButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20),
                okButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
                okButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
                okButton.heightAnchor.constraint(equalToConstant: 50),
                
                label.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            ])
        } else {
            constraints.append(contentsOf: [
                label.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20)
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
