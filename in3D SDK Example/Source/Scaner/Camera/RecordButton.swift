/// states for record button
///
/// - ready: ready. not currently recording. shows full inner circle
/// - recording: currently recording. shows roumded square

import UIKit
import RxSwift

enum RecordButtonState {
    case ready, recording
    
    mutating func `switch`() {
        self = self == .ready ? .recording : .ready
    }
}

extension RecordButtonState {
    /// transform for button for state. full size when ready, shrunken when recording
    var transform: CATransform3D {
        switch self {
        case .ready: return CATransform3DIdentity
        case .recording: return CATransform3DMakeScale(0.6, 0.6, 0.6)
        }
    }
    
    /// inner view corner radius. half the height when ready (For full circle) and 8 for rounded square
    var buttonRadius: (CALayer) -> (CGFloat) {
        switch self {
        case .ready: return { layer in return layer.bounds.size.height/2 }
        case .recording: return { _ in return 8 }
        }
    }
}

class RecordButton: UIControl {
        
    // MARK: - Public properties
    var recordState = RecordButtonState.ready {
        didSet {
            guard let animatingLayer = animatingLayer else {
                return
            }
            
            // get old corner radius for initial animation value
            let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
            cornerRadiusAnimation.fromValue = recordState.buttonRadius(animatingLayer)
            
            // get old size for initial animation value
            let trasnformAnimation = CABasicAnimation(keyPath: "transform")
            trasnformAnimation.fromValue = oldValue.transform
            
            // set final new corner radius and transform animation values
            cornerRadiusAnimation.toValue = recordState.buttonRadius(animatingLayer)
            trasnformAnimation.toValue = recordState.transform
            
            // group the animations for smooth effect
            let group = CAAnimationGroup()
            group.animations = [cornerRadiusAnimation, trasnformAnimation]
            group.isRemovedOnCompletion = false
            group.fillMode = CAMediaTimingFillMode.forwards
            group.duration = 0.25
            
            animatingLayer.add(group, forKey: "all")
            
            if recordState == .recording {
                animatingLayer.backgroundColor = UIColor.Button.red.cgColor
            } else {
                animatingLayer.backgroundColor = UIColor.Button.white.cgColor
            }
        }
    }
    var isDark = false
    
    // MARK: - Private properties
    private var animatingLayer: CAShapeLayer? = nil
    private var ringWidth: CGFloat = 10
    fileprivate let tapSubject = PublishSubject<Void>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        addTap()
    }
    
    // MARK: - Lifecycle
    override func draw(_ rect: CGRect) {
        var outerColor = UIColor.Button.white
        var innerColor = UIColor.Button.dark
        if isDark {
            outerColor = UIColor.Button.dark
            innerColor = UIColor.Button.white
        }
        
        // set outer ring
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = ringWidth
        outerColor.setStroke()
        innerColor.setFill()
        path.fill()
        path.stroke()
        
        if animatingLayer == nil {
            // calculate size for inner circle w.r.t the outer ring
            let sizeDifference = ringWidth * 1.5
            let originDifference = sizeDifference / 2
            var insideRect = rect
            insideRect.size.height = rect.size.height - sizeDifference
            insideRect.size.width = rect.size.width - sizeDifference
            insideRect.origin.x = rect.origin.x + originDifference
            insideRect.origin.y = rect.origin.y + originDifference
            
            // create and set animating (inner red animating) layer properties
            animatingLayer = CAShapeLayer()
            animatingLayer?.frame = insideRect
            animatingLayer?.cornerRadius = insideRect.size.height/2.0
            animatingLayer?.backgroundColor = outerColor.cgColor
            layer.addSublayer(animatingLayer!)
        }
        
        layer.cornerRadius = rect.size.height/2
        layer.masksToBounds = true
    }
    
    // MARK: - Private methods
    private func addTap() {
        addTarget(self, action: #selector(processTap), for: .touchUpInside)
    }
    
    @objc private func processTap() {
        tapSubject.onNext(())
    }
    
}

extension Reactive where Base: RecordButton {
    
    var tap: Observable<Void> {
        return base.tapSubject
    }
    
}
