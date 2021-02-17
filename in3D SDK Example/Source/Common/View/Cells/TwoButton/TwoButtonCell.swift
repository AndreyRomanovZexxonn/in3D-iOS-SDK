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

class TwoButtonCell: UITableViewCell {
    
    // MARK: - Subviews
    @IBOutlet fileprivate weak var leftButton: UIButton!
    @IBOutlet fileprivate weak var rightButton: UIButton!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var leftTitle: String? = nil {
        didSet {
            leftButton.setTitle(leftTitle, for: .normal)
        }
    }
    var rightTitle: String? = nil {
        didSet {
            rightButton.setTitle(rightTitle, for: .normal)
        }
    }
    var leftButtonIsEnabled = false {
        didSet {
            leftButton.isEnabled = leftButtonIsEnabled
            leftButton.backgroundColor = leftButtonIsEnabled ? UIColor.Button.background : UIColor.Button.gray
        }
    }
    var rightButtonIsEnabled = true {
        didSet {
            rightButton.isEnabled = rightButtonIsEnabled
            rightButton.backgroundColor = rightButtonIsEnabled ? UIColor.Button.background : UIColor.Button.gray
        }
    }
    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        leftButton.setup()
        rightButton.setup()
        
        leftButtonIsEnabled = false
        rightButtonIsEnabled = true
        
        activityIndicator.isHidden = true
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public methods
    func showActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        leftButton.setTitle("", for: .normal)
    }
    
    func hideActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        leftButton.setTitle(leftTitle, for: .normal)
    }
    
}

extension Reactive where Base: TwoButtonCell {

    var leftTap: ControlEvent<Void> {
        return base.leftButton.rx.tap
    }

    var rightTap: ControlEvent<Void> {
        return base.rightButton.rx.tap
    }

}
