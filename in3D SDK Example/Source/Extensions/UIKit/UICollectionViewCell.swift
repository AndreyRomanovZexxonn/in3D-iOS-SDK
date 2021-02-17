//
//  UICollectionCell.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 14.10.2020.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
