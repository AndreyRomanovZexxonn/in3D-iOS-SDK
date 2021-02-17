//
//  PoseAlertView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 26.10.2020.
//

import AVFoundation
import Foundation
import UIKit
import RxCocoa
import RxSwift

class PoseAlertView: UIView {
    
    // MARK: - Subviews
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.Label.textColor
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    fileprivate let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.background
        button.setTitle("Ready", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x1A2029)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public property
    var type: PoseAlert = .knees {
        didSet {
            videoView.isHidden = type != .knees
            
            constraint.constant = type == .knees ? 100 : 0
            
            switch type {
            case .knees:
                playVideo()
                self.label.text = "Place the phone vertically at the level of your hips."
            case .interfere:
                self.label.text = "The surface is blocking the view at the bottom. Please move the phone closer to the edge."
            }
        }
    }
    
    // MARK: - Public properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let disposeBag = DisposeBag()
    private var constraint: NSLayoutConstraint!
    
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
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoView.bounds
    }
    
    // MARK: - Private methods
    private func layout() {
        backgroundColor = UIColor(rgb: 0x1A2029)
        
        let buttonHeight: CGFloat = 50
        button.layer.cornerRadius = buttonHeight / 2
        
        addSubview(videoView)
        addSubview(label)
        addSubview(button)
        
        constraint = label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 100)
        
        NSLayoutConstraint.activate([
            constraint,
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            videoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            videoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            videoView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
            videoView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -115),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func playVideo() {
        videoView.isHidden = false
        
        player = AVPlayer(url: Bundle.main.url(forResource: "tutorial_hip", withExtension: "mp4")!)
        player?.isMuted = true
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer!)
        playerLayer?.frame = videoView.bounds
        player?.play()
        
        NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
            .subscribe(onNext: { [unowned self] _ in
                self.player?.seek(to: CMTime.zero)
                self.player?.play()
            }).disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: PoseAlertView {
    
    var readyTap: ControlEvent<Void> {
        return base.button.rx.tap
    }
    
}
