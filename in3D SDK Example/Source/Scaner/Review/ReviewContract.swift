//
//  ReviewContract.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/01/2020.
//

import Foundation

protocol ReviewViewModel: class {
    
    func approve()
    func rewrite()
    var video: URL { get }
    
}
