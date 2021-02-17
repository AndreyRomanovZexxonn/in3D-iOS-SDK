//
//  Coordinator.swift
//  Virtual dressing room
//
//  Created by Булат Якупов on 15/10/2019.
//

import Foundation
import UIKit

protocol WindowCoordinator: class {
    
    var window: UIWindow { get set }
    var didFinishClosure: (() -> ())? { get set }
    
    func start()
    
}

protocol NavCoordinator: class {
    
    var navigationController: UINavigationController { get set }
    var didFinishClosure: (() -> ())? { get set }
    
    func start()
    
}

protocol TabCoordinator: class {
    
    var tabBarController: UITabBarController { get set }
    var didFinishClosure: (() -> ())? { get set }
    
    func start()
}
