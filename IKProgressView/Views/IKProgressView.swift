//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class IKProgressView: UIView, CAAnimationDelegate {

    @IBInspectable var progress: UInt = 50 {
        didSet {
            let temp = progress > 100 ? 100 : progress
            _progress = CGFloat(temp) / CGFloat(100)
            setNeedsDisplay()
        }
    }

    @IBInspectable var animated: Bool = true {
        didSet {
//            _animated = animated
            setNeedsDisplay()
        }
    }

    @IBInspectable var fps: UInt = 120 {
        didSet {
            _fps = fps
        }
    }

    /// Will use view height and width
    @IBInspectable var fitView: Bool = true {
        didSet {
            _fitView = fitView
            setNeedsDisplay()
        }
    }

    @IBInspectable var interiorR: UInt = 200 {
        didSet {
            _r = interiorR
            setNeedsDisplay()
        }
    }

    @IBInspectable var exteriorR: UInt = 200 {
        didSet {
            _R = exteriorR
            setNeedsDisplay()
        }
    }

    /// For neat visual experience with border
    public var scale: CGFloat = 0.99

//    private var _animated: Bool = true
    private var _progress: CGFloat = 0.5
    private var _fps: UInt = 120

    private var _fitView: Bool = true
    private var _r: UInt = 100
    private var _R: UInt = 200

    private var _colors = [UIColor]()
    private var _elementsCount: Int = 512

    private var _timer: Timer?


    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupTimer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

        _timer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(_fps), repeats: true, block: {
            [weak self]
            (timer) in

            self?.setNeedsDisplay()

        })
    }

    override func draw(_ rect: CGRect) {

        _colors = rotateColors(_colors)

        UIColor.white.set()
        UIRectFill(bounds)

        var r, R: UInt
        if _fitView {
            let dim = UInt(max(bounds.width, bounds.height))
            r = dim / 4
            R = dim / 2
        } else {
            r = _r
            R = _R
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
