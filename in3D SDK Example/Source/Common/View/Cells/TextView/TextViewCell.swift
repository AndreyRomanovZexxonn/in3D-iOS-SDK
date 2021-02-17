//
//  TextViewCell.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 22/12/2019.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class TextViewCell: UITableViewCell {
    
    // MARK: - Subviews
    @IBOutlet private weak var textViewContainer: UIView! {
        didSet {
            textViewContainer.backgroundColor = UIColor.TextField.background
            textViewContainer.layer.cornerRadius = 21
            textViewContainer.layer.borderColor = UIColor.TextField.border.cgColor
            textViewContainer.layer.borderWidth = 2
        }
    }
    @IBOutlet fileprivate weak var textView: UITextView! {
        didSet {
            textView.textColor = UIColor.TextField.text
            textView.backgroundColor = UIColor.TextField.background
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Label.textColor
            titleLabel.numberOfLines = 1
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    // MARK: - Public property
    private(set) var disposeBag = DisposeBag()
    
    var titleText = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public methods
    func makeActive() {
        textView.becomeFirstResponder()
    }
        
}

extension Reactive where Base: TextViewCell {
    
    var text: ControlProperty<String?> {
        return base.textView.rx.text
    }
    
    var beginEditing: ControlEvent<Void> {
        return base.textView.rx.didBeginEditing
    }
    
}
