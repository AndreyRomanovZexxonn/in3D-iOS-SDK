//
//  UploadContract.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 19/12/2019.
//

import Foundation
import UIKit

protocol UploadView: class {
    
    func upload(progress: Double, totalSize: Int64)
    func showError()
    
}

protocol UploadViewModel: class {
    
    func ready()
    func finish(offset time: Double)
    var view: UploadView? { get set }
    
}
