//
//  UIDevice.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 30/01/2020.
//

import Foundation
import UIKit

enum DeviceGeneration {
    
    case old
    case x
    case xs
    case i11
    
}

extension UIDevice {

    static let suitableDevice: Bool = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> Bool {
            #if os(iOS)
            switch identifier {
            case "iPhone10,3", "iPhone10,6", "iPhone11,2", "iPhone11,4", "iPhone11,8", "iPhone11,6", "iPhone12,1", "iPhone12,3", "iPhone12,5":
                return true
            default:
                return false
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
    
    static let deviceGeneration: DeviceGeneration = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> DeviceGeneration {
            #if os(iOS)
            switch identifier {
            case "iPhone10,3", "iPhone10,6":
                return .x
            case "iPhone11,2", "iPhone11,4", "iPhone11,8", "iPhone11,6":
                return .xs
            case "iPhone12,1", "iPhone12,3", "iPhone12,5":
                return .i11
            default:
                return .old
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
