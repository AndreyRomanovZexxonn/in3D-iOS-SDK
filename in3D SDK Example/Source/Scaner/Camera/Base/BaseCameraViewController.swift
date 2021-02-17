//
//  CameraVideoViewController.swift
//  Recorder
//
//  Created by Булат Якупов on 09/10/2019.
//  Copyright © 2019 Булат Якупов. All rights reserved.
//

import AVFoundation
import Foundation
import MetalKit
import UIKit
import RxCocoa
import RxSwift

class BaseCameraViewController: UIViewController {
    
    // MARK: - Subviews
    let angleView: AngleView = {
        let view = AngleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    let recordButton: RecordButton = {
        let button = RecordButton(frame: CGRect(x: 20, y: 20, width: 80, height: 80))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let previewView: MTKView = {
        let view = MTKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoResizeDrawable = false
        return view
    }()
    let countDownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.Label.textColor
        label.font = UIFont.systemFont(ofSize: 300, weight: .bold)
        return label
    }()
    let darknessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.Label.background
        label.textColor = UIColor.Label.red
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.text = "LOW LIGHT. CAN'T START RECORD."
        return label
    }()
    private let alertView: PoseAlertView = {
        let view = PoseAlertView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Public properties
    var viewModel: CameraViewModel!
    var canStartConnecting = true
    let disposeBag = DisposeBag()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Init
    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        layoutViews()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.ready()
        previewView.drawableSize = .init(width: 1440, height: 1920)
    }
    
    // MARK: - Private methods
    private func setupActions() {
        recordButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.recordTap()
        }).disposed(by: disposeBag)
        
        alertView.rx.readyTap.subscribe(onNext: { [unowned self] _ in
            self.alertView.isHidden = true
            self.viewModel.phoneFixated()
        }).disposed(by: disposeBag)
    }
    
    private func setupNavBar() {
        let leftButton = UIBarButtonItem.init(image: UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action:  #selector(cancelTap))
        navigationItem.setLeftBarButton(leftButton, animated: false)
        
        let rightButton = UIBarButtonItem(title: "Tutorial", style: .plain, target: self, action: #selector(tutorialTap))
        navigationItem.setRightBarButton(rightButton, animated: false)
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: nil, style: .plain, target: self, action: nil)
    }
    
    func layoutViews() {
        view.backgroundColor = UIColor.View.background
        
        view.addSubview(previewView)
        view.addSubview(recordButton)
        view.addSubview(countDownLabel)
        view.addSubview(darknessLabel)
        view.addSubview(angleView)
        view.addSubview(alertView)
        
        let constraints = [
            angleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            angleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            angleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            angleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: CGFloat(640)/CGFloat(480)),
            
            recordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            recordButton.heightAnchor.constraint(equalToConstant: 70),
            recordButton.widthAnchor.constraint(equalTo: recordButton.heightAnchor, multiplier: 1),
            
            countDownLabel.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            countDownLabel.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            
            darknessLabel.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            darknessLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -20),
            
            alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            alertView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func cancelTap() {
        dismiss(animated: true, completion: nil)
        viewModel.cancelTap()
    }
    
    @objc private func tutorialTap() {
        viewModel.tutorialTap()
    }
    
    private func showSettings() {
        let alertController = UIAlertController (title: "Camera access denied", message: "To create an avatar we need camera access. Please give us a permission. Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [unowned self] _ in
            self.viewModel.cancelTap()
        })
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
}

extension BaseCameraViewController: CameraView {
    
    func show(error: CameraError) {
        DispatchQueue.main.async { [unowned self] in
            switch error {
            case .accessDenied:
                self.showSettings()
            case .initFailed:
                self.showErrorAlert(message: "Your camera usage is restricted.") { [unowned self] in
                    self.viewModel.cancelTap()
                }
            case .recordFaield:
                self.showErrorAlert(message: "Something went wrong during scanning. Please close the app and restart. Also check if you have any free space left in your device memory storage.") { [unowned self] in
                    self.viewModel.cancelTap()
                }
            }
        }
    }
    
    
    func showAngle(with target: Double) {
        if angleView.isHidden {
            angleView.targetAngle = target
            angleView.isHidden = false
        }
    }
    
    func hideAngle() {
        angleView.isHidden = true
    }
    
    func update(angle: Double) {
        angleView.currentAngle = angle
    }
    
    func showCountDown(to value: Int) {
        let start = DispatchTime.now()
        for i in 0...value {
            DispatchQueue.main.asyncAfter(deadline: start + Double(i), execute: { [weak self] in
                let number = value - i
                self?.countDownLabel.text = number > 0 ? "\(number)" : ""
            })
        }
    }
    
    func update(record state: RecordState) {
        DispatchQueue.main.async { [unowned self] in
            switch state {
            case .ready:
                self.recordButton.recordState = .ready
            case .scanning:
                self.recordButton.recordState = .recording
            case .finished:
                self.recordButton.recordState = .ready
            }
        }
    }
    
    func brightness(isOkay: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.darknessLabel.isHidden = isOkay
        }
    }
    
    func present(activity: UIViewController) {
        present(activity, animated: true, completion: nil)
    }
    
    func show(alert: PoseAlert) {
        DispatchQueue.main.async { [unowned self] in
            self.alertView.isHidden = false
            self.alertView.type = alert
        }
    }
    
}

