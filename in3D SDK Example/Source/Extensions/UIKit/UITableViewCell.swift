//
//  UITableViewCell.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 17/12/2019.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func setup() {
        contentView.backgroundColor = UIColor.Cell.background
        backgroundColor = UIColor.Cell.background
        selectionStyle = .none
    }
    
}
