//
//  HeightViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 23/03/2020.
//

import Foundation

class HeightViewModelImpl {
    
    // MARK: - Public properties
    weak var view: HeightView?
    
    // MARK: - Private properties
    private weak var coordinator: ScannerCoordination?
    private var currentHeight = 90
    private var currentUnits = Units.cm
    private var _cmHeights = [Int]()
    private var _inHeights = [Int]()
    private let cmHeights: [(height: String, type: PickerLineType)]
    private let ftHeights: [(height: String, type: PickerLineType)]
    
    // MARK: - Init
    init(coordinator: ScannerCoordination) {
        self.coordinator = coordinator
        
        let cmMin = 121
        let cmMax = 241
        let ftMin = Int(Double(cmMin) / 2.54)
        let ftMax = Int(Double(cmMax) / 2.54)

        for height in cmMin...cmMax {
            _cmHeights.append(cmMin + cmMax - height)
        }
        
        cmHeights = _cmHeights.map { height -> (height: String, type: PickerLineType) in
            let strHeight = "\(height) cm"

            if height % 10 == 0 {
                return (height: strHeight, type: .long)
            } else {
                return (height: strHeight, type: .short)
            }
        }
        
        for height in ftMin...ftMax {
            _inHeights.append(ftMin + ftMax - height)
        }
        ftHeights = _inHeights.map { height -> (height: String, type: PickerLineType) in
            let inch = height % 12
            let ft = height / 12
            
            if inch == 0 {
                return (height: "\(ft)\'", type: .long)
            } else {
                return (height: "\(ft)\'\(inch)\"", type: .short)
            }
        }
    }
    
}


extension HeightViewModelImpl: HeightViewModel {
    
    func update(height: Int) {
        currentHeight = height
    }
    
    func ready() {
        view?.show(heights: cmHeights, in: currentHeight)
    }
    
    func update(units: Units) {
        var row: Int
        if currentUnits != units {
            if currentUnits == .cm {
                let height = _cmHeights[currentHeight]
                row = _inHeights.last! - Int((Double(height) / 2.54).rounded()) + _inHeights.count - 1
                
                if row > _inHeights.count - 1 {
                    row = _inHeights.count - 1
                }
                
                if row < 0 {
                    row = 0
                }
            } else {
                let height = _inHeights[currentHeight]
                row = _cmHeights.last! - Int((Double(height) * 2.54).rounded()) + _cmHeights.count - 1
                
                if row > _cmHeights.count - 1 {
                    row = _cmHeights.count - 1
                }
                
                if row < 0 {
                    row = 0
                }
            }
        } else {
            row = currentHeight
        }
        
        switch units {
        case .cm:
            view?.show(heights: cmHeights, in: row)
        case .ft:
            view?.show(heights: ftHeights, in: row)
        }
        
        currentHeight = row
        currentUnits = units
    }
    
    func nextTap() {
        let height: Int
        if currentUnits == .cm {
            height = _cmHeights[currentHeight]
        } else {
            height = Int(Double(_inHeights[currentHeight]) * 2.54)
        }
        
        coordinator?.showScanner(animated: true, height: height)
    }
    
}
