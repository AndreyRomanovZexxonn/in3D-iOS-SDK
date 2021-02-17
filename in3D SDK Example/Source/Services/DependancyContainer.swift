//
//  DependancyContainer.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 28.11.2020.
//

import Foundation
import I3DRecorder

protocol DependancyContainer {
    
    var scanService: ScanService { get }
    
}

class DependancyContainerImpl: DependancyContainer {
    
    let scanService: ScanService
    
    init(scanService: ScanService) {
        self.scanService = scanService
    }
    
}
