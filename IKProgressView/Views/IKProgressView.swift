//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore

class IKProgressView: UIView, CAAnimationDelegate {

    private var colors = [UIColor]()
    
    public var progress = 0.3
    
    private let subdiv = 512
    
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
        Timer.scheduledTimer(withTimeInterval: 1.0.divided(by: 120.0), repeats: true, block: {
            [weak self]
            (timer) in
            
//            self?.setNeedsDisplay()
            
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
        
        let cell = UIBezierPath()
        cell.move(to: CGPoint(x: -smallBase.divided(by: 2.0), y: Double(r)))
        cell.addLine(to: CGPoint(x: +smallBase.divided(by: 2.0), y: Double(r)))
        
        cell.addLine(to: CGPoint(x: +largeBase.divided(by: 2.0), y: Double(R)))
        cell.addLine(to: CGPoint(x: -largeBase.divided(by: 2.0), y: Double(R)))
        
        cell.close()
        
        let incr = M_PI.divided(by: Double(subdiv)).multiplied(by: 2.0)
        if let context = UIGraphicsGetCurrentContext() {
            
            context.translateBy(x: bounds.width.divided(by: 2.0), y: bounds.height.divided(by: 2))
            
            context.scaleBy(x: 0.9, y: 0.9)
//            context.rotate(by: M_PI.divided(by: 2).cgFloat)
//            context.rotate(by: incr.divided(by: 2).cgFloat)
            
            for color in colors {
            
                color.set()
                
                cell.fill()
                cell.stroke()
                context.rotate(by: incr.cgFloat)
                
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

extension Double {
    var float: Float {
        return Float(self)
    }
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Int {
    var float: Float {
        return Float(self)
    }
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    var double: Double {
        return Double(self)
    }
}

extension Float {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba
    }
}
