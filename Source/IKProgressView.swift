//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore


/// Neat radial progress view
@IBDesignable public class IKProgressView: UIView {

    /// Progress value within range [0, 1]
    @IBInspectable public var progress: CGFloat = 0.5 {
        didSet(newProgress) {
            setNeedsDisplay()
        }
    }
    
    /// Specify true if you want that view will autofill itself in bounds
    @IBInspectable public var filledView: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Inner radius in circle
    @IBInspectable public var interiorR: Int = 100 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// External radius in circle
    @IBInspectable public var exteriorR: Int = 150 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Active spinning or simple static image
    public var animated: Bool = true {
        didSet {
            _timer.isPaused = !animated
        }
    }
    
    /// Rotated colors per one draw call. Must be lower than elements count
    public var colorsSpeed: Int = 10
    
    /// For neat visual experience with border
    public var scale: CGFloat = 0.99
    
    /// Set progress animated
    ///
    /// - Parameters:
    ///   - progress: new progress
    ///   - animated: animated flag
    ///   - completion: required function because of cg drawing. Use to set next progress
    public func setProgress(_ progress: CGFloat, animated: Bool, _ completion: @escaping (() -> ()) ) {
        guard animated else {
            _newProgress = nil
            self.progress = progress
            completion()
            return
        }
        
        _newProgress = progress
        _completion = completion
        
    }

    // MARK: - private section
    
    /// Count of trapezoids
    private var elements: Int = 512
    
    private var _colors = [UIColor]()
    private var _timer: CADisplayLink!
    private var _newProgress: CGFloat?
    private var _countedDelta: CGFloat?
    private var _completion: (() -> ())?

    /// Init for code
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        enableAnimation()
    }

    /// Init for IB
    public required init?(coder aDecoder: NSCoder) {
        
        self.progress = CGFloat(aDecoder.decodeFloat(forKey: "progress"))
        self.filledView = aDecoder.decodeBool(forKey: "filledView")
        self.interiorR = aDecoder.decodeInteger(forKey: "interiorR")
        self.exteriorR = aDecoder.decodeInteger(forKey: "exteriorR")
        
        super.init(coder: aDecoder)
        enableAnimation()
    }

    /// Overridden from super
    public override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }

    /// Create CADisplayLink
    private func enableAnimation() {
        
        _timer = CADisplayLink(target: self, selector: #selector(self.animate))
        _timer.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        
    }
    
    /// Calls each redraw cycle from displayLink
    @objc private func animate() {
        
        if let countedDelta = _countedDelta {
            
            let roundedProgress = CGFloat(round(100*progress)/100)
            
            if let newProgress = _newProgress, roundedProgress != newProgress {
                progress += countedDelta
            } else {
                _countedDelta = nil
                _newProgress = nil
                if let handler = _completion {
                    handler()
                    _completion = nil
                }
            }
        } else {
            
            if let newProgress = _newProgress {
                
                let delta = (newProgress - progress) / 60.0
                _countedDelta = delta
            }
        }
        
        self.setNeedsDisplay()
    }

    /// Main method for drawing
    override public func draw(_ rect: CGRect) {
        
        let progress = self.progress
        
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

        let increment: CGFloat = CGFloat(2.0 * M_PI) * progress / CGFloat(elements)
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

    /// Rotate colors in array
    private func rotateColors(_ colors: [UIColor]) -> [UIColor] {

        var colors = colors

        guard colors.count == 0 else {
            return Array(colors.suffix(colorsSpeed) + colors.prefix(colors.count - colorsSpeed))
        }

        for i in 0 ..< elements {

            let hueValue: CGFloat = CGFloat(i) / CGFloat(elements)
            let color = UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)

            colors.append(color)
        }

        return colors
    }

}

