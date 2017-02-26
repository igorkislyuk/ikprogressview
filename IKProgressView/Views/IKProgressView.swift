//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore

//todo: make pod
//todo: make carthage
//todo: generate doc

@IBDesignable
class IKProgressView: UIView, CAAnimationDelegate {

    /// Progress value [0, 100]
    @IBInspectable var progress: Int = 50 {
        didSet(newProgress) {
            setNeedsDisplay()
        }
    }
    
    /// Count of trapezoids
    @IBInspectable var elements: Int = 512
    
    /// Will use view height and width
    @IBInspectable var filledView: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Inner radius in circle
    @IBInspectable var interiorR: Int = 100 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// External radius in circle
    @IBInspectable var exteriorR: Int = 150 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Will gradient spinning
    public var animated: Bool = true {
        didSet {
            _timer.isPaused = !animated
        }
    }
    /// Times progress view will draw itself
    public var fps: Int = 240
    /// For neat visual experience with border
    public var scale: CGFloat = 0.99
    
    /// Set progress animated
    ///
    /// - Parameters:
    ///   - progress: new progress
    ///   - animated: animated flag
    public func setProgress(_ progress: Int, animated: Bool) {
        
    }

    // MARK: - private section
    
    private var _colors = [UIColor]()
    private var _timer: CADisplayLink!
    
    private var _progress: CGFloat {
        return CGFloat(progress) / CGFloat(100)
    }


    required override init(frame: CGRect) {
        super.init(frame: frame)
        enableAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        
        self.progress = aDecoder.decodeInteger(forKey: "progress")
        self.fps = aDecoder.decodeInteger(forKey: "fps")
        self.filledView = aDecoder.decodeBool(forKey: "filledView")
        self.interiorR = aDecoder.decodeInteger(forKey: "interiorR")
        self.exteriorR = aDecoder.decodeInteger(forKey: "exteriorR")
        
        super.init(coder: aDecoder)
        enableAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }

    func enableAnimation() {
        
        _timer = CADisplayLink(target: self, selector: #selector(self.animate))
        _timer.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        
        if #available(iOS 10, *) {
            _timer.preferredFramesPerSecond = fps
        } else {
            _timer.frameInterval = 60 / fps
        }
        
    }
    
    @objc private func animate() {
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        
        _colors = rotateColors(_colors)

        backgroundColor?.set()
        UIRectFill(bounds)

        var r, R: Int
        if filledView {
            let dim = Int(min(bounds.width, bounds.height))
            r = dim / 4
            R = dim / 2
        } else {
            r = interiorR
            R = exteriorR
        }

        let halfInteriorPerim = M_PI * Double(r)
        let halfExteriorPerim = M_PI * Double(R)

        let smallBase = halfInteriorPerim.divided(by: Double(elements))
        let largeBase = halfExteriorPerim.divided(by: Double(elements))

        let trapezoid = UIBezierPath()
        trapezoid.move(to: CGPoint(x: -smallBase.divided(by: 2.0), y: Double(r)))
        trapezoid.addLine(to: CGPoint(x: +smallBase.divided(by: 2.0), y: Double(r)))

        trapezoid.addLine(to: CGPoint(x: +largeBase.divided(by: 2.0), y: Double(R)))
        trapezoid.addLine(to: CGPoint(x: -largeBase.divided(by: 2.0), y: Double(R)))

        trapezoid.close()

        let increment: CGFloat = CGFloat(2.0 * M_PI) * _progress / CGFloat(elements)
        if let context = UIGraphicsGetCurrentContext() {

            context.translateBy(x: bounds.width.divided(by: 2.0), y: bounds.height.divided(by: 2))

            context.scaleBy(x: scale, y: scale)
            context.rotate(by: CGFloat(M_PI_2) * CGFloat(3.0)) //to start
            context.rotate(by: -increment / 2)

            for color in _colors {

                color.set()

                trapezoid.fill()
                trapezoid.stroke()
                context.rotate(by: -increment)

            }
        }

    }

    private func rotateColors(_ colors: [UIColor]) -> [UIColor] {

        var colors = colors

        guard colors.count == 0 else {
            return Array(colors.suffix(1) + colors.prefix(colors.count - 1))
        }

        for i in 0 ..< elements {

            let hueValue: CGFloat = CGFloat(i) / CGFloat(elements)
            let color = UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)

            colors.append(color)
        }

        return colors
    }

}

