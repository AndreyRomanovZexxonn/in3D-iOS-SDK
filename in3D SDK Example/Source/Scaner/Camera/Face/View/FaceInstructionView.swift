//
//  FaceInstructionView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 21/05/2020.
//

import AVFoundation
import Foundation
import UIKit
import RxSwift

class FaceInstructionView: UIView {
    
    // MARK: - Subview
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.View.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Label.textColor
        label.backgroundColor = UIColor.View.background
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Follow along"
        return label
    }()
    
    // MARK: - Private properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        setupVideoView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layout()
        setupVideoView()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = videoView.bounds
    }
    
    // MARK: - Public methods
    func play(completion: @escaping (() -> ())) {
        guard let player = player else {
            return
        }
        
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            completion()
        }
    }
    
    func turnHeadLeft(completion: @escaping (() -> ())) {
        guard let player = player else {
            return
        }
        
        player.play()
        player.perform(#selector(player.pause), with: nil, afterDelay: 1.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion()
        }
    }
    
    func turnHeadRight(completion: @escaping (() -> ())) {
        guard let player = player else {
            return
        }
        
        player.play()
        player.perform(#selector(player.pause), with: nil, afterDelay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func turnHeadMiddle(completion: @escaping (() -> ())) {
        guard let player = player else {
            return
        }
        
        player.play()
        player.perform(#selector(player.pause), with: nil, afterDelay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func turnHeadDown(completion: @escaping (() -> ())) {
        guard let player = player else {
            return
        }
        
        player.play()
        player.perform(#selector(player.pause), with: nil, afterDelay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func turnHeadUp(completion: @escaping (() -> ())) {
        guard let player = player else {
            return
        }
        
        player.play()
        player.perform(#selector(player.pause), with: nil, afterDelay: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    // MARK: - Private methods
    private func layout() {
        backgroundColor = UIColor.View.background
        addSubview(videoView)
        addSubview(label)
        
        let constraints = [
            videoView.topAnchor.constraint(equalTo: topAnchor),
            videoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupVideoView() {
        guard let videoUrl = Bundle.main.url(forResource: "face_instruction", withExtension: "mp4") else {
            return
        }
        
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player!)
        playerLayer?.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer!)
        
        NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            .subscribe(onNext: { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
            }).disposed(by: disposeBag)
    }
    
}
