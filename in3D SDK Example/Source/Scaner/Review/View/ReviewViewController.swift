//
//  ReviewViewController.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/01/2020.
//

import AVFoundation
import Foundation
import UIKit
import RxSwift

class ReviewViewController: UIViewController {
    
    // MARK: - Subview
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.Label.background
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Label.textColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Did you follow the instructions?"
        return label
    }()
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.View.background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "play"), for: .normal)
        return button
    }()
    private let restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.dark
        button.setBackgroundImage(UIImage(named: "cancel"), for: .normal)
        return button
    }()
    private let approveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.dark
        button.setBackgroundImage(UIImage(named: "check"), for: .normal)
        return button
    }()
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .white)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    private let blurView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.isHidden = true
        return blurEffectView
    }()
    
    // MARK: - Private properties
    private var viewModel: ReviewViewModel
    private var player1: AVPlayer!
    private var playerLayer1: AVPlayerLayer!
    private let disposeBag = DisposeBag()
    private var isPlaying: Bool {
        return player1.timeControlStatus == AVPlayer.TimeControlStatus.playing
    }
    
    // MARK: - Init
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoView()
        layoutSubviews()
        setupActions()
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer1.frame = videoView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    // MARK: - Private methods
    @objc private func doneAction(sender: UITapGestureRecognizer) {
        pauseVideo()
        viewModel.approve()
    }
    
    private func setupActions() {
        playButton.rx.tap.subscribe(onNext: { [unowned self] in
            if self.isPlaying {
                self.pauseVideo()
                self.playButton.setImage(UIImage(named: "play"), for: .normal)
            } else {
                self.playVideo()
                self.playButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        restartButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.showLoader()
            self.viewModel.rewrite()
        }).disposed(by: disposeBag)
        
        approveButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.approve()
        }).disposed(by: disposeBag)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Review"
        navigationItem.setHidesBackButton(true, animated: true);
    }
    
    private func layoutSubviews() {
        view.backgroundColor = UIColor.View.background
        view.addSubview(titleLabel)
        view.addSubview(videoView)
        view.addSubview(restartButton)
        view.addSubview(approveButton)
        view.addSubview(blurView)
        view.addSubview(loader)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            videoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 1.33),
            videoView.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            
            approveButton.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 40),
            approveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -65),
            approveButton.heightAnchor.constraint(equalToConstant: 40),
            approveButton.widthAnchor.constraint(equalToConstant: 40),
            
            restartButton.topAnchor.constraint(equalTo: approveButton.topAnchor),
            restartButton.bottomAnchor.constraint(equalTo: approveButton.bottomAnchor),
            restartButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 65),
            restartButton.heightAnchor.constraint(equalToConstant: 40),
            restartButton.widthAnchor.constraint(equalToConstant: 40),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            loader.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showLoader() {
        blurView.isHidden = false
        loader.startAnimating()
    }
    
    private func setupVideoView() {
        player1 = AVPlayer(url: viewModel.video)
        player1.seek(to: CMTime.zero)
        playerLayer1 = AVPlayerLayer(player: player1)
        playerLayer1.videoGravity = .resizeAspect
        playerLayer1.cornerRadius = 20
        videoView.layer.addSublayer(playerLayer1)
        
        NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: player1.currentItem)
            .subscribe(onNext: { [weak self] _ in
                self?.player1.seek(to: CMTime.zero)
                self?.player1.play()
            }).disposed(by: disposeBag)
    }
    
    private func playVideo() {
        self.player1.play()
    }
    
    private func pauseVideo() {
        self.player1.pause()
    }
    
    private func restartVideo() {
        self.player1.pause()
        self.player1.seek(to: CMTime.zero)
        self.player1.play()
    }
    
}
