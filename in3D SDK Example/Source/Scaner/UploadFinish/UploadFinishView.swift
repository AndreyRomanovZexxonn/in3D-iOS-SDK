//
//  UploadFinishView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 16/06/2020.
//

import Foundation
import UIKit
import RxSwift

class UploadFinishView: UIViewController {
    
    // MARK: - Subviews
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.Label.textColor
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Uploaded successfully!"
        return label
    }()
    fileprivate let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.background
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    // MARK: - Private properties
    private weak var coordinator: ScannerCoordinator?
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(coordinator: ScannerCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setupActions()
        navBar()
    }
    
    // MARK: - Private methods
    private func layout() {
        view.backgroundColor = UIColor.View.background
        
        let buttonHeight: CGFloat = 50
        button.layer.cornerRadius = buttonHeight / 2
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -115),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupActions() {
        button.rx.tap.subscribe(onNext: { [unowned self] in
            self.coordinator?.finish()
        }).disposed(by: disposeBag)
    }
    
    private func navBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

