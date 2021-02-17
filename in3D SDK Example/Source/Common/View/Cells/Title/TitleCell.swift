//
//  TitleCell.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23.07.2020.
//

import Foundation
import UIKit

class TitleCell: UITableViewCell {
    
    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.Label.textColor
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Public properties
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        layout()
    }
    
    // MARK: - Private methods
    private func layout() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
}
