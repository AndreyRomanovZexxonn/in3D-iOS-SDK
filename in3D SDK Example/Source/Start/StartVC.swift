//
//  StartVC.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 13/04/2020.
//  Copyright © 2020 In3D. All rights reserved.
//

import I3DRecorder
import UIKit

class StartVC: UIViewController {
    
    // MARK: - Subview
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("scan", for: .normal)
        return button
    }()
    
    // MARK: - Private properties
    private weak var coordinator: AppCoordination?
    
    // MARK: - Init
    init(coordinator: AppCoordination) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }

    // MARK: - Private methods
    private func setupButton() {
        button.addTarget(self,
                         action: #selector(tapButton),
                         for: .touchUpInside)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func tapButton() {
        coordinator?.showScanner()
    }
    
}

