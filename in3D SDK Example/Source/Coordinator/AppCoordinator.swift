//
//  AppCoordinator.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 19/08/2019.
//  Copyright © 2019 Булат Якупов. All rights reserved.
//

import ARKit
import Foundation
import UIKit
import RxCocoa
import RxSwift
import StoreKit

protocol AppCoordination: WindowCoordinator {
    
    func showScanner()
    
}

class AppCoordinator: AppCoordination {
    
    // MARK: - Public Properties
    var didFinishClosure: (() -> ())?
    var window: UIWindow
    
    // MARK: - Private Properties
    private let container: DependancyContainer
    private var scannerCoordinator: ScannerCoordination?
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(window: UIWindow, container: DependancyContainer) {
        self.window = window
        self.container = container
    }
    
    // MARK: - Public Methods
    func start() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchController = storyboard.instantiateInitialViewController()
        window.rootViewController = launchController
        window.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[unowned self] in
            self.showStart()
        }
    }
    
    func showScanner() {
        if ARFaceTrackingConfiguration.isSupported {
            let navController = UINavigationController()
            
            scannerCoordinator = nil
            scannerCoordinator = ScannerCoordinator(navigationController: navController,
                                                    container: container)
            scannerCoordinator?.didFinishClosure = { [unowned self] in
                self.showStart()
            }
            
            navController.modalPresentationStyle = .overFullScreen
            navController.modalTransitionStyle = .coverVertical
            window.rootViewController = navController
            
            scannerCoordinator?.start()
        } else {
            let alert = UIAlertController(title: "Not suitable device", message: "Your device should have a TrueDepth camera in order to scan.", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(cancel)
            
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private methods
    private func showStart() {
        let vc = StartVC(coordinator: self)
        window.rootViewController = vc
    }
        
}
