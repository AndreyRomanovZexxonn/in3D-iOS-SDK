//
//  UIImageView.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 25/12/2019.
//

import Foundation
import UIKit

extension UIImageView {
    
    func async(image: String) {
        guard let url = URL(string: image) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }

            DispatchQueue.main.async { [unowned self] in
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
    
}
