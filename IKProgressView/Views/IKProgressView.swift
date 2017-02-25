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
    
    @IBInspectable var fps: UInt = 120 {
        didSet {
            _fps = fps
        }
    }
    
    private var _fps: UInt = 120
    private var _progress: CGFloat = 0.5
    
    private var colors = [UIColor]()
    private var subdiv: Int = 512
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    func commonInit() {
        Timer.scheduledTimer(withTimeInterval: 1.0 / Double(_fps), repeats: true, block: {
            [weak self]
            (timer) in
            
            self?.setNeedsDisplay()
            
        })
    }
   
    override func draw(_ rect: CGRect) {
        
        colors = rotateColors(colors)
        
        UIColor.white.set()
        UIRectFill(bounds)
    
        let dim = min(bounds.width, bounds.height)
        
        let r = dim.divided(by: 4)
        let R = dim.divided(by: 2)
        
        let halfInteriorPerim = M_PI.multiplied(by: Double(r))
        let halfExteriorPerim = M_PI.multiplied(by: Double(R))
        
        let smallBase = halfInteriorPerim.divided(by: Double(subdiv))
        let largeBase = halfExteriorPerim.divided(by: Double(subdiv))
        
        let trapezoid = UIBezierPath()
        trapezoid.move(to: CGPoint(x: -smallBase.divided(by: 2.0), y: Double(r)))
        trapezoid.addLine(to: CGPoint(x: +smallBase.divided(by: 2.0), y: Double(r)))
        
        trapezoid.addLine(to: CGPoint(x: +largeBase.divided(by: 2.0), y: Double(R)))
        trapezoid.addLine(to: CGPoint(x: -largeBase.divided(by: 2.0), y: Double(R)))
        
        trapezoid.close()
        
        var increment:CGFloat = CGFloat(2.0 * M_PI) / CGFloat(subdiv)
        increment = increment * _progress
        if let context = UIGraphicsGetCurrentContext() {
            
            context.translateBy(x: bounds.width.divided(by: 2.0), y: bounds.height.divided(by: 2))
            
            context.scaleBy(x: 0.9, y: 0.9)
            context.rotate(by: CGFloat(M_PI_2) * CGFloat(3.0))
            
            for color in colors {
            
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

        for i in 0 ..< subdiv {

            let hueValue: CGFloat = CGFloat(i) / CGFloat(subdiv)
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
