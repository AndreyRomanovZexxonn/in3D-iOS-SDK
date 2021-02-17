//
//  UIViewController.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 25/12/2019.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String? = nil, onReturn: (() -> ())? = nil ) {
        let errorMessage = message ?? "Something wrong with server or internet connection. Please try again later."
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Ok", style: .cancel) { [unowned self] _ in
            onReturn?()
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
