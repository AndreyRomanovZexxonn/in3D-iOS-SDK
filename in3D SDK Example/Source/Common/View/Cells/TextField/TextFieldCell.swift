//
//  TextFieldCell.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 16/12/2019.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class TextFieldCell: UITableViewCell {
    
    // MARK: - Subviews
    @IBOutlet private weak var textFieldContainer: UIView! {
        didSet {
            textFieldContainer.backgroundColor = UIColor.TextField.background
            textFieldContainer.layer.cornerRadius = 21
            textFieldContainer.layer.borderColor = UIColor.TextField.border.cgColor
            textFieldContainer.layer.borderWidth = 2
        }
    }
    @IBOutlet fileprivate weak var textField: UITextField! {
        didSet {
            textField.textColor = UIColor.TextField.text
            textField.backgroundColor = UIColor.TextField.background
            textField.borderStyle = .none
            textField.clearButtonMode = .unlessEditing
            textField.returnKeyType = .done
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.Label.textColor
            titleLabel.numberOfLines = 1
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    @IBOutlet fileprivate weak var statusLabel: UILabel! {
        didSet {
            statusLabel.isHidden = true
            statusLabel.textColor = UIColor.Label.statusColor
            statusLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var isPassword = false {
        didSet {
            textField.isSecureTextEntry = isPassword
            textField.textContentType = isPassword ? .password : .none
        }
    }
    var isNewPassword = false {
        didSet {
            textField.isSecureTextEntry = isPassword
            textField.textContentType = isPassword ? .newPassword : .none
        }
    }
    var isEmail = false {
        didSet {
            if isEmail {
                textField.textContentType = .username
                textField.keyboardType = .emailAddress
            } else {
                textField.keyboardType = .default
            }
        }
    }
    var titleText = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    var placeholder = "" {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextField.placeholder])
        }
    }
    var enteredText: String? {
        return textField.text
    }
    var returnType: UIReturnKeyType = .done {
        didSet {
            textField.returnKeyType = returnType
        }
    }
    private(set) var disposeBag = DisposeBag()
    
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
        textField.becomeFirstResponder()
    }
    
    func show(error status: String?) {
        statusLabel.isHidden = false
        statusLabel.text = status
        statusLabel.textColor = UIColor.Label.red
        
        textFieldContainer.layer.borderColor = UIColor.TextField.error.cgColor
    }
    
    func show(normal status: String) {
        statusLabel.isHidden = false
        statusLabel.text = status
        statusLabel.textColor = UIColor.Label.statusColor
        
        textFieldContainer.layer.borderColor = UIColor.TextField.border.cgColor
    }
    
    func hideStatus() {
        statusLabel.isHidden = true
        textFieldContainer.layer.borderColor = UIColor.TextField.border.cgColor
    }
    
    func showActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()           
    }
    
    func hideActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}

extension Reactive where Base: TextFieldCell {
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    
    var beginEditing: ControlEvent<Void> {
        return base.textField.rx.controlEvent([.editingDidBegin])
    }
    
    var endEditing: ControlEvent<Void> {
        return base.textField.rx.controlEvent([.editingDidEnd])
    }
    
    var returnTap: ControlEvent<Void> {
        return base.textField.rx.controlEvent([.editingDidEndOnExit])
    }
    
}
