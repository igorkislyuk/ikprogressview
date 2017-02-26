//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore

//todo: deal with setting from IB
//todo: deal with background from view

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
    
    /// Is gradient will spinning
    @IBInspectable var animated: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
    
    /// Times progress view will draw itself
    public var fps: Int = 120
    /// For neat visual experience with border
    public var scale: CGFloat = 0.99

    // MARK: - private section
    
    private var _colors = [UIColor]()
    private var _elementsCount: Int {
        return progress * 5 + 12
    }

    private var _timer: Timer?
    
    private var _progress: CGFloat {
        return CGFloat(progress) / CGFloat(100)
    }


    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupTimer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.animated = aDecoder.decodeBool(forKey: "animated")
        self.progress = aDecoder.decodeInteger(forKey: "progress")
        self.fps = aDecoder.decodeInteger(forKey: "fps")
        self.filledView = aDecoder.decodeBool(forKey: "filledView")
        self.interiorR = aDecoder.decodeInteger(forKey: "interiorR")
        self.exteriorR = aDecoder.decodeInteger(forKey: "exteriorR")
        
        setupTimer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }

    func setupTimer() {

        _timer?.invalidate()
        
        if !animated {
            return
        }

        _timer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(fps), repeats: true, block: {
            [weak self]
            (timer) in

            self?.setNeedsDisplay()

        })
    }

    override func draw(_ rect: CGRect) {

        _colors = rotateColors(_colors)

        UIColor.white.set()
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

        let smallBase = halfInteriorPerim.divided(by: Double(_elementsCount))
        let largeBase = halfExteriorPerim.divided(by: Double(_elementsCount))

        let trapezoid = UIBezierPath()
        trapezoid.move(to: CGPoint(x: -smallBase.divided(by: 2.0), y: Double(r)))
        trapezoid.addLine(to: CGPoint(x: +smallBase.divided(by: 2.0), y: Double(r)))

        trapezoid.addLine(to: CGPoint(x: +largeBase.divided(by: 2.0), y: Double(R)))
        trapezoid.addLine(to: CGPoint(x: -largeBase.divided(by: 2.0), y: Double(R)))

        trapezoid.close()

        var increment: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(_elementsCount)
        increment = increment * _progress
        if let context = UIGraphicsGetCurrentContext() {

            context.translateBy(x: bounds.width.divided(by: 2.0), y: bounds.height.divided(by: 2))

            context.scaleBy(x: scale, y: scale)
            context.rotate(by: CGFloat(M_PI_2) * CGFloat(3.0))

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

        for i in 0 ..< _elementsCount {

            let hueValue: CGFloat = CGFloat(i) / CGFloat(_elementsCount)
            let color = UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)

            colors.append(color)
        }

        return colors
    }

}

extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba
    }
}
