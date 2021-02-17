//
//  HeadVideoTutorialView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 28/05/2020.
//

import AVFoundation
import UIKit
import UserNotifications
import RxSwift

class TutorialViewController: UIViewController {
    
    // MARK: - Subview
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.View.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.backgroundColor = UIColor.Button.background
        button.setTitle("Next", for: .normal)
        button.layer.cornerRadius = 20
        button.isHidden = true
        return button
    }()
    private let retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.backgroundColor = UIColor.Button.dark
        button.setTitle("Repeat", for: .normal)
        button.isHidden = true
        button.layer.cornerRadius = 20
        return button
    }()
    private let topBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.View.lightBackground
        view.layer.cornerRadius = 2
        return view
    }()
    
    // MARK: - Private properties
    private let viewModel: TutorialViewModel
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var shouldRemove = false
    private var canSkip: Bool
    private let disposeBag = DisposeBag()
    private let shouldShowButtons: Bool
    
    // MARK: - Init
    init(viewModel: TutorialViewModel, canSkip: Bool, shouldShowButtons: Bool = true) {
        self.viewModel = viewModel
        self.canSkip = canSkip
        self.shouldShowButtons = shouldShowButtons
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        setupVideoView()
        layoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    private func setupActions() {
        retryButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.retryButton.isHidden = true
            self.player.play()
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.player.pause()
            self.viewModel.nextAction()
        }).disposed(by: disposeBag)
    }
    
    private func layoutSubviews() {
        topBarView.isHidden = navigationController != nil
        
        view.backgroundColor = UIColor.View.background
        view.addSubview(videoView)
        view.addSubview(retryButton)
        view.addSubview(nextButton)
        view.addSubview(topBarView)
        
        nextButton.isHidden = !canSkip || !shouldShowButtons
        
        let constraints = [
            videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBarView.widthAnchor.constraint(equalToConstant: 40),
            topBarView.heightAnchor.constraint(equalToConstant: 4),
            
            retryButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupVideoView() {
        guard let videoUrl = viewModel.videoURL else {
            return
        }
        
        player = AVPlayer(url: videoUrl)
        player.volume = 0.5
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        
        NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            .subscribe(onNext: { [unowned self] _ in
                self.nextButton.isHidden = !self.shouldShowButtons
                self.retryButton.isHidden = false
                self.player.seek(to: CMTime.zero)
            }).disposed(by: disposeBag)
        shouldRemove.toggle()
    }
    
}
