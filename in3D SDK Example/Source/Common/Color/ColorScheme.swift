//
//  ColorScheme.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 02/12/2019.
//

import Foundation
import UIKit

protocol ColorScheme {
    
    var main: UIColor { get }
    var sub: UIColor { get }
    var mainText: UIColor { get }
    var subText: UIColor { get }
    var tint: UIColor { get }
    var attention: UIColor { get }
    
}

struct MainColorScheme: ColorScheme {
    
    var main: UIColor {
        return UIColor(rgb: 0x222831)
    }
    var sub: UIColor {
        return UIColor(rgb: 0x1A2029)
    }
    var mainText: UIColor {
        return UIColor.white
    }
    var subText: UIColor {
        return UIColor.white.withAlphaComponent(0.4)
    }
    var tint: UIColor {
        return UIColor(rgb: 0x29A19C)
    }
    var attention: UIColor {
        return UIColor(rgb: 0xC72C41)
    }
    
}

extension UIColor {
    
    class var scheme: ColorScheme {
        return MainColorScheme()
    }
    
    struct View {
        
        static var background: UIColor {
            return UIColor.scheme.sub
        }
        
        static var secondaryBackground: UIColor {
            return UIColor.scheme.main
        }
        
        static var lightBackground: UIColor {
            return UIColor.scheme.mainText
        }
        
        static var grayBackground: UIColor {
            return UIColor.scheme.subText
        }
        
        static var darkBackground: UIColor {
            return UIColor.scheme.sub.withAlphaComponent(0.2)
        }
        
        static var tintBackground: UIColor {
            return UIColor.scheme.tint
        }
        
        static var error: UIColor {
            return UIColor.scheme.attention
        }
        
    }
    
    struct View3D {
        
        static var background: UIColor {
            return UIColor(rgb: 0x505050)
        }
        
        static var lightBackground: UIColor {
            return UIColor(rgb: 0xAAAAAA)
        }
        
    }
    
    struct TableView {
        
        static var clearBackground: UIColor {
            return UIColor.clear
        }
        
        static var background: UIColor {
            return UIColor.scheme.main
        }
        
    }
    
    struct TableCell {
        
        static var background: UIColor {
            return UIColor.scheme.sub
        }
        
    }
    
    struct CollectionView {
        
        static var background: UIColor {
            return UIColor.clear
        }
        
    }
    
    struct CollectionCell {
        
        static var background: UIColor {
            return UIColor.scheme.main
        }
        static var border: UIColor {
            return UIColor.scheme.subText
        }
        
    }
    
    struct NavBar {
        
        static var chatBackground: UIColor {
            return UIColor.scheme.sub
        }
        static var background: UIColor {
            return UIColor.scheme.main
        }
        static var scannerBackground: UIColor {
            return UIColor.scheme.sub
        }
        static var tutorialBackground: UIColor {
            return UIColor.scheme.sub
        }
        static var tint: UIColor {
            return UIColor.scheme.mainText
        }
        
    }
    
    struct Button {
        
        static var dark: UIColor {
            return UIColor.scheme.sub
        }
        static var text: UIColor {
            return UIColor.scheme.mainText
        }
        static var inactiveText: UIColor {
            return UIColor.scheme.subText
        }
        static var background: UIColor {
            return UIColor.scheme.tint
        }
        static var red: UIColor {
            return UIColor.scheme.attention
        }
        static var white: UIColor {
            return UIColor.scheme.mainText
        }
        static var gray: UIColor {
            return UIColor.scheme.subText
        }
        static var viewer: UIColor {
            return UIColor.scheme.subText
        }
        static var url: UIColor {
            return UIColor.scheme.tint
        }
        static var border: UIColor {
            return UIColor.scheme.subText
        }
        
    }
    
    struct Label {
        
        static var textColor: UIColor {
            return UIColor.scheme.mainText
        }
        static var urlColor: UIColor {
            return UIColor.scheme.tint
        }
        static var background: UIColor {
            return UIColor.clear
        }
        static var red: UIColor {
            return UIColor.scheme.attention
        }
        static var statusColor: UIColor {
            return UIColor.scheme.subText
        }
        
    }
    
    struct TabBar {
        
        static var background: UIColor {
            return UIColor.scheme.sub
        }
        static var selectedTab: UIColor {
            return UIColor.scheme.tint
        }
        static var tab: UIColor {
            return UIColor.scheme.subText
        }
        
    }
    
    struct TextField {
        
        static var tint: UIColor {
            return UIColor.scheme.tint
        }
        static var chatBorder: UIColor {
            return UIColor.scheme.subText
        }
        static var border: UIColor {
            return UIColor.scheme.tint
        }
        static var placeholder: UIColor {
            return UIColor.scheme.subText
        }
        static var text: UIColor {
            return UIColor.scheme.mainText
        }
        static var background: UIColor {
            return UIColor.clear
        }
        static var error: UIColor {
            return UIColor.scheme.attention
        }
    }
    
    struct ProgressView {
        
        static var progressTint: UIColor {
            return UIColor.scheme.tint
        }
        static var background: UIColor {
            return UIColor.scheme.subText
        }
                
    }
    
    struct Image {
        
        static var clearBackground: UIColor {
            return UIColor.clear
        }
        static var chatTint: UIColor {
            return UIColor.scheme.tint
        }
        static var tint: UIColor {
            return UIColor.scheme.mainText
        }
        static var settingsTint: UIColor {
            return UIColor.scheme.tint
        }
        static var viewerTint: UIColor {
            return UIColor.scheme.tint
        }
        static var faceTint: UIColor {
            return UIColor.scheme.tint
        }
        static var red: UIColor {
            return UIColor.scheme.attention
        }
        static var transparent: UIColor {
            return UIColor.scheme.subText
        }
        
    }
    
    struct Cell {
        
        static var background: UIColor {
            return UIColor.clear
        }
        
    }
    
    struct PageControll {
        
        static var background: UIColor {
            return UIColor.scheme.sub
        }
        
        static var selectedFill: UIColor {
            return UIColor.scheme.mainText
        }
        
        static var normalFill: UIColor {
            return UIColor.scheme.subText
        }
        
    }
    
    struct PickerView {
        
        static var background: UIColor {
            return UIColor.scheme.sub
        }
        
        static var row: UIColor {
            return UIColor.scheme.mainText
        }
        
    }
    
    struct SegmentControl {
        
        static var tint: UIColor {
            return UIColor.scheme.tint
        }
        
        static var text: UIColor {
            return UIColor.scheme.mainText
        }
        
    }
    
    struct RefreshControl {
        
        static var tint: UIColor {
            return UIColor.scheme.tint
        }
        
    }
    
    struct Gradient {
        
        static var start: UIColor {
            return UIColor.scheme.main
        }
        
        static var end: UIColor {
            return UIColor.scheme.sub
        }
        
    }
    
    struct ARSquare {
        
        static var main: UIColor {
            return UIColor.scheme.main
        }
        
        static var light: UIColor {
            return UIColor.scheme.tint
        }
        
    }
    
    struct Unspun {
        
        static var textColor: UIColor {
            return UIColor.black
        }
        
        static var cancelButton: UIColor {
            return UIColor(rgb: 0xEEDBB5)
        }
        
        static var button: UIColor {
            return UIColor(rgb: 0xDD5636)
        }
        
        static var buttonText: UIColor {
            return UIColor.scheme.mainText
        }
        
        static var cancelTint: UIColor {
            return UIColor.black
        }
        
    }
    
    struct Chat {
        
        static var incoming: UIColor {
            return UIColor.scheme.mainText
        }
        
        static var outgoing: UIColor {
            return UIColor.scheme.tint
        }
        
    }
    
}
