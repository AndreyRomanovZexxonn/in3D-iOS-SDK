//
//  MovingAverage.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 13/01/2020.
//

import Foundation

class MovingAverage {
    
    // MARK: - Public properties
    var average: Double {
        let sum: Double = samples.reduce(0, +)
        
        if period > samples.count {
            return sum / Double(samples.count)
        } else {
            return sum / Double(period)
        }
    }
    
    // MARK: - Private properties
    private var samples: Array<Double>
    private var sampleCount = 0
    private var period = 5
    
    // MARK: - Init
    init(period: Int = 5) {
        self.period = period
        samples = Array<Double>()
    }
    
    // MARK: - Public methods
    func addSample(value: Double) -> Double {
        sampleCount += 1
        var pos = Int(fmodf(Float(sampleCount), Float(period)))
        
        if pos >= samples.count {
            samples.append(value)
        } else {
            samples[pos] = value
        }
        
        return average
    }
    
    func clear() {
        samples.removeAll()
    }
    
}
