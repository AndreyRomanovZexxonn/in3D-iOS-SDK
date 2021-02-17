//
//  HeightViewController.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/03/2020.
//

import Foundation
import UIKit
import RxSwift

class HeightViewController: UIViewController {
    
    // MARK: - Subviews
    private let pickerView: UIPickerView = {
       let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = UIColor.PickerView.background
        picker.showsSelectionIndicator = false
        return picker
    }()
    private let unitControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.insertSegment(withTitle: "cm", at: 0, animated: false)
        control.insertSegment(withTitle: "ft", at: 1, animated: false)
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = UIColor.SegmentControl.tint
            control.setTitleTextAttributes([.foregroundColor: UIColor.SegmentControl.text,
                                            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)],
                                           for: .normal)
        } else {
            control.setTitleTextAttributes([.foregroundColor: UIColor.SegmentControl.tint,
                                            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)],
                                           for: .normal)
        }
        control.selectedSegmentIndex = 0
        return control
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "What is your height?"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.Label.background
        label.textColor = UIColor.Label.textColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    fileprivate let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Button.background
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.Button.text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 20
        return button
    }()
    
    // MARK: - Private properties
    private let viewModel: HeightViewModel
    private let disposeBag = DisposeBag()
    private let rowHeight: CGFloat = 40
    private var heights =  [(height: String, type: PickerLineType)]()
    
    // MARK: - Init
    init(viewModel: HeightViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.ready()
    }
    
    // MARK: - Private methods
    private func setupNavBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.View.background
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(pickerView)
        view.addSubview(titleLabel)
        view.addSubview(unitControl)
        view.addSubview(nextButton)
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            pickerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -60),
            pickerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pickerView.widthAnchor.constraint(equalToConstant: 200),
            pickerView.heightAnchor.constraint(equalToConstant: 300),
            
            unitControl.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 20),
            unitControl.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: -20),
            unitControl.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 20),
            unitControl.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.topAnchor.constraint(equalTo: unitControl.bottomAnchor, constant: 80),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupActions() {
        unitControl
            .rx
            .selectedSegmentIndex
            .subscribe(onNext: { [unowned self] segment in
                self.viewModel.update(units: Units(rawValue: segment)!)
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.nextTap()
        }).disposed(by: disposeBag)
    }
    
}

extension HeightViewController: HeightView {
    
    func show(heights: [(height: String, type: PickerLineType)], in row: Int) {
        self.heights = heights
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }
    
}

extension HeightViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heights.count
    }
    
}

extension HeightViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.update(height: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let rowView = view as? PickerRowView else {
            let newView = PickerRowView(line: heights[row].type,
                                        frame: .init(origin: .zero,
                                                     size: .init(width: pickerView.frame.width,
                                                                 height: rowHeight)))
            newView.height = heights[row].height
            return newView
        }
        
        rowView.height = heights[row].height
        rowView.lineType = heights[row].type
        
        return rowView
    }
    
}
