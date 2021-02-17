//
//  ScannerTypeView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21.07.2020.
//

import Foundation
import UIKit
import RxSwift

class ScannerTypeViewController: UIViewController {
    
    // MARK: - Subviews
    private let backgroundView: PolygonBackgroundView = {
        let view = PolygonBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let yesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.background
        button.setTitle("Yes", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    private let noButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.background
        button.setTitle("No", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Scan head?"
        label.textColor = UIColor.Label.textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    // MARK: - Private properties
    private let viewModel: ScannerTypeViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: ScannerTypeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.animate()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = UIColor.View.background
        
        let buttonHeight: CGFloat = 50
        noButton.layer.cornerRadius = buttonHeight / 2
        yesButton.layer.cornerRadius = buttonHeight / 2
        
        view.addSubview(backgroundView)
        view.addSubview(yesButton)
        view.addSubview(titleLabel)
        view.addSubview(noButton)
        
        let constraints = [
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            yesButton.widthAnchor.constraint(equalToConstant: 100),
            yesButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            yesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            yesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -115),
            
            noButton.widthAnchor.constraint(equalToConstant: 100),
            noButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            noButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            noButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -115),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupActions() {
        yesButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.tapYes()
        }).disposed(by: disposeBag)
        
        noButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.tapNo()
        }).disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        titleLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func labelTap() {
        guard
            let url = URL(string: "https://unspun.io"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

