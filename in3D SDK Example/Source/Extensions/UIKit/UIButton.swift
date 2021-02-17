//
//  UIButton.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 17/12/2019.
//

import Foundation
import UIKit

extension UIButton {
    
    func setup(cornerRadius: CGFloat = 21) {
        backgroundColor = UIColor.Button.background
        setTitleColor(UIColor.Button.text, for: .normal)
        layer.cornerRadius = cornerRadius
    }
    
}
