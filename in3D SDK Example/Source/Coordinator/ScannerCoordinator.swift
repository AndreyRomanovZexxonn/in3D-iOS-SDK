//
//  ScannerCoordinator.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 06/09/2019.
//  Copyright © 2019 Булат Якупов. All rights reserved.
//

import Foundation
import I3DRecorder
import UIKit
import RxSwift

protocol ScannerCoordination: NavCoordinator {
    
    func showFaceScanner()
    func showScanner(animated: Bool, height: Int?)
    func showHeight()
    func showUpload()
    func showBodyReview()
    func showHeadReview()
    func showBodyTutorial()
    func showTutorial()
    func showHeadPipeline()
    func showHeadTutorial()
    func showBodyScanner()
    func showBodyStart()
    func showUploadFinish()
    func finish()
    
}

class ScannerCoordinator: NSObject, ScannerCoordination {
    
    // MARK: - Public properties
    var navigationController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let container: DependancyContainer
    fileprivate var currentVC: UIViewController?
    private var previewImage: URL?
    private let startTime = Date()
    private var currentHeight: Int = 0
    private let voiceHints: VoiceHints = AudioPlayer()
    private let disposeBag = DisposeBag()
    private let recording: ScanRecording
    private let settings: RecorderSettings
    
    // MARK: - Init
    init(navigationController: UINavigationController, container: DependancyContainer) {
        self.navigationController = navigationController
        self.container = container
        self.recording = container.scanService.newRecording(withHead: true)
        self.settings = I3DRecorderSettings(exposureMode: .auto((value: Int64(1), timescale: Int32(100))),
                                            fps: 10)
        
        super.init()
        navigationController.delegate = self
        setupNavBar()
    }
    
    // MARK: - Public methods
    func start() {
        startNavigation()
    }
    
    func showTutorial() {
        let vm: TutorialViewModel
        if navigationController.topViewController is FaceCameraViewController {
            vm = HeadTutorialVM(coordinator: self)
        } else {
            vm = BodyTutorialVM(coordinator: self)
        }
        let vc = TutorialViewController(viewModel: vm, canSkip: true, shouldShowButtons: false)
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func showBodyTutorial() {
        let vm = BodyTutorialVM(coordinator: self)
        let vc = TutorialViewController(viewModel: vm, canSkip: true)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showHeadTutorial() {
        let vm = HeadTutorialVM(coordinator: self)
        let vc = TutorialViewController(viewModel: vm, canSkip: true)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showBodyStart() {
        let controller = BlurOverlayViewController(text: "Now let's scan the body.",
                                                   withCheck: false,
                                                   withButton: true) { [unowned self] in
            self.navigationController.dismiss(animated: true, completion: nil)
            self.showBodyScanner()
        }
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .coverVertical
        navigationController.present(controller, animated: true, completion: nil)
    }
    
    func showBodyScanner() {
        navigationController.setNavigationBarHidden(false, animated: true)
        showBodyTutorial()
    }
    
    func showHeight() {
        let vm = HeightViewModelImpl(coordinator: self)
        let vc = HeightViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFaceScanner() {
        guard let headSequence = recording.headSequence else {
            fatalError()
        }
        
        let recorder = ScanRecorder(settings: settings, sequence: headSequence, height: currentHeight)
        let vm = FaceViewModel(recorder: recorder,
                               coordinator: self,
                               scanService: container.scanService)
        let vc = FaceCameraViewController(viewModel: vm)
        recorder.previewView = vc.previewView
        
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showScanner(animated: Bool = true, height: Int? = nil) {
        if let height = height {
            currentHeight = height
        }
                
        if currentVC is ReviewViewController {
            do {
                for item in recording.bodySequence.all {
                    try FileManager.default.removeItem(at: item)
                }
            } catch {
                print(error)
            }
        }
        
        let recorder = ScanRecorder(settings: settings, sequence: recording.bodySequence, height: currentHeight)
        let vm = TapCameraViewModel(recorder: recorder,
                                    scanService: container.scanService,
                                    coordinator: self,
                                    voiceHints: AudioPlayer())
        let vc = BaseCameraViewController(viewModel: vm)
        recorder.previewView = vc.previewView
        
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.setViewControllers([vc], animated: animated)
    }
    
    func showUpload() {
        upload()
    }
    
    func showBodyReview() {
        do {
            try container.scanService.recorded(recording: recording)
        } catch {
            print(error)
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.navigationController.setNavigationBarHidden(true, animated: true)
            
            let vm = DefaultReviewViewModel(coordinator: self, video: recording.bodySequence.rgb)
            vm.onApprove = { [unowned self] in
                self.showUpload()
            }
            vm.onRewrite = { [unowned self] in
                self.showScanner(animated: true, height: nil)
            }
            let vc = ReviewViewController(viewModel: vm)
            self.navigationController.setViewControllers([vc], animated: true)
        }
    }
    
    func showHeadReview() {
        guard let headSequence = recording.headSequence else {
            fatalError()
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.navigationController.setNavigationBarHidden(true, animated: true)
                    
            let vm = DefaultReviewViewModel(coordinator: self, video: headSequence.rgb)
            vm.onApprove = { [unowned self] in
                self.showBodyStart()
            }
            vm.onRewrite = { [unowned self] in
                self.showFaceScanner()
            }
            let vc = ReviewViewController(viewModel: vm)
            self.navigationController.setViewControllers([vc], animated: true)
        }
    }
    
    func finish() {
        currentVC = nil
        navigationController.setViewControllers([], animated: true)
        if let didFinish = didFinishClosure {
            didFinish()
        }
    }
    
    func showUploadFinish() {
        let vc = UploadFinishView(coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showHeadPipeline() {
        navigationController.setNavigationBarHidden(false, animated: true)
        showHeadTutorial()
    }
    
    // MARK: - Private methods
    private func setupNavBar() {
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.Label.textColor]
        navigationController.navigationBar.backgroundColor = UIColor.NavBar.scannerBackground
        navigationController.navigationBar.barTintColor = UIColor.NavBar.scannerBackground
        navigationController.navigationBar.tintColor = UIColor.NavBar.tint
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        navigationController.isNavigationBarHidden = false
    }
    
    private func startNavigation() {
        let vm = SoundLaunchViewModelImpl(coordinator: self)
        let vc = SoundLaunchViewController(viewModel: vm)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        if vm.currentVolumeLevel != .high {
            navigationController.present(vc, animated: true, completion: nil)
        } else {
            showHeadPipeline()
        }
        
        vm.volumeLevel.subscribe(onNext: { [unowned self] level in
            if level == .high {
                if self.navigationController.presentedViewController == vc {
                    self.navigationController.dismiss(animated: true, completion: nil)
                }
                
                if self.navigationController.viewControllers == [] {
                    showHeadPipeline()
                }
            } else {
                if self.navigationController.presentedViewController != vc {
                    self.navigationController.present(vc, animated: true, completion: nil)
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func upload() {
        let vm = ScanerUploadViewModel(coordinator: self,
                                       scanService: container.scanService,
                                       recording: recording)
        let vc = UploadViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
}

extension ScannerCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentVC = viewController
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ScannerTypeViewController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
