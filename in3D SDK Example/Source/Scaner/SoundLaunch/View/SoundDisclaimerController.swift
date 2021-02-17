//
//  SoundDisclaimerController.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 12/12/2019.
//

import Foundation
import UIKit
import UserNotifications
import RxSwift

class SoundLaunchViewController: UIViewController {

    // MARK: - Subview
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        imageView.tintColor = UIColor.Image.tint
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.Label.background
        label.textColor = UIColor.Label.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.Button.white
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    // MARK: - Private properties
    private let viewModel: SoundLaunchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: SoundLaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        layoutSubviews()
        
        update(volume: viewModel.currentVolumeLevel)
    }
    
    // MARK: - Private methods
    private func layoutSubviews() {
        view.backgroundColor = UIColor.View.background
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        let constraints = [
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupNavBar() {
        nextButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.nextTap()
        }).disposed(by: disposeBag)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: nextButton)
        
        cancelButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.cancelTap()
        }).disposed(by: disposeBag)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: cancelButton)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension SoundLaunchViewController: SoundLaunchView {
    
    func update(volume level: VolumeLevel) {
        nextButton.isHidden = level != .high
        
        switch level {
        case .high:
            imageView.image = UIImage(named: "speaker_full")?.withRenderingMode(.alwaysTemplate)
            label.text = "Volume is high enough"
        case .low:
            imageView.image = UIImage(named: "speaker_low")?.withRenderingMode(.alwaysTemplate)
            label.text = "Volume is low. Please turn up to 50% at least."
        case .mute:
            imageView.image = UIImage(named: "mute")?.withRenderingMode(.alwaysTemplate)
            label.text = "Phone is muted. Please turn up the volume."
        }
    }
    
}
