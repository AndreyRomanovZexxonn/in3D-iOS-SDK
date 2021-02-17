//
//  UploadViewController.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 06/09/2019.
//  Copyright © 2019 Булат Якупов. All rights reserved.
//

import Foundation
import UIKit

class UploadViewController: UIViewController {
    
    // MARK: - Subviews
    private let backgroundView: PolygonBackgroundView = {
        let view = PolygonBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let progressView: ProgressView = {
        let view = ProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionTitle = "Uploading"
        view.resultTitle = "Data is being prepared for upload"
        view.resultIsHidden = false
        return view
    }()
    
    // MARK: - Private properties
    private let viewModel: UploadViewModel
    
    // MARK: - Init
    init(viewModel: UploadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.animate()
        viewModel.ready()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = UIColor.View.background
        
        view.addSubview(backgroundView)
        view.addSubview(progressView)
        
        let constraints = [
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension UploadViewController: UploadView {
    
    func upload(progress: Double, totalSize: Int64) {
        progressView.update(progress: progress, totalSize: totalSize)
    }
 
    func showError() {
        DispatchQueue.main.async { [unowned self] in
            self.showErrorAlert(message: "Something wrong with server or internet connection. Please reload the app and try to upload one more time.") { [unowned self] in
                self.viewModel.finish(offset: 0.0)
            }
        }
    }
    
}
