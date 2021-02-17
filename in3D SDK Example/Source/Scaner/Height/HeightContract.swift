//
//  HeightContract.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/03/2020.
//

import Foundation

enum Units: Int {
    
    case cm = 0
    case ft = 1
    
}

protocol HeightView: class {
    
    func show(heights: [(height: String, type: PickerLineType)], in row: Int)
    
}

protocol HeightViewModel: class {
    
    var view: HeightView? { set get }
    func update(height: Int)
    func update(units: Units)
    func ready()
    func nextTap()
    
}
