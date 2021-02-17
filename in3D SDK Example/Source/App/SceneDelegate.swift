//
//  SceneDelegate.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 26.10.2020.
//

import UIKit
import I3DRecorder

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordination?
    var container: DependancyContainer!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let _window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        _window.windowScene = windowScene
        window = _window
        
        setupDependencies()
        
        appCoordinator = AppCoordinator(window: _window, container: container)
        appCoordinator?.start()
    }
    
    // MARK: - Private methods
    private func setupDependencies() {
        let scanService = I3DScanService()
        
        container = DependancyContainerImpl(scanService: scanService)
    }

}

