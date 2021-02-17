//
//  OneButtonCell.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 17/12/2019.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class OneButtonCell: UITableViewCell {
    
    // MARK: - Subviews
    @IBOutlet fileprivate weak var button: UIButton!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var buttonTitle: String? = nil {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    var buttonIsEnabled = false {
        didSet {
            button.isEnabled = buttonIsEnabled
            button.backgroundColor = buttonIsEnabled ? UIColor.Button.background : UIColor.Button.gray
        }
    }
    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        button.setup()
        
        buttonIsEnabled = false
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public methods
    func showActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        button.setTitle("", for: .normal)
    }
    
    func hideActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        button.setTitle(buttonTitle, for: .normal)
    }
    
}

extension Reactive where Base: OneButtonCell {

    var tap: ControlEvent<Void> {
        return base.button.rx.tap
    }

}
