//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore

class IKProgressView: UIView, CAAnimationDelegate {

    private var progressLabel: UILabel
    private var progressLayer = CAShapeLayer()

    private var gradient: CAGradientLayer?
    private var colors = [CGColor]()
    
    private var layers = [CAShapeLayer]()
    private var finished = false

    override class var layerClass: AnyClass {
        get {
            return CAShapeLayer.self
        }
    }


    required init?(coder aDecoder: NSCoder) {
        progressLabel = UILabel()
        super.init(coder: aDecoder)

        commonInit()
    }

    override init(frame: CGRect) {
        progressLabel = UILabel()
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        self.backgroundColor = UIColor.clear

        createProgressLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //todo: add functionality
    }

    func createShape(with path: CGPath, color: CGColor) -> CAShapeLayer {
    
        let layer = CAShapeLayer()
        
        layer.path = path
        layer.strokeColor = colors.first!
        
        layer.backgroundColor = nil
        layer.fillColor = nil
        layer.lineWidth = 30.0
        layer.borderWidth = 0.0
        
        return layer
    }

    func createProgressLayer() {
        
        colors = rotateColors(colors)
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = 150
        var path: CGPath
        
        
        
        
        for index in 0..<colors.count {
            
            let color = colors[index]
            
            let sector = sectorAngles(for: index)
            
            path = UIBezierPath(arcCenter: center, radius: radius.cgFloat, startAngle: sector.start - 0.05, endAngle: sector.end - 0.05, clockwise: false).cgPath
            
            let shape = createShape(with: path, color: color)
            
            layer.addSublayer(shape)
            
            layers.append(shape)
        }



        
        performAnimation()

    }
    
    func sectorAngles(for index: Int) -> (start: CGFloat, end:CGFloat) {
        
        let circleRad = M_PI.multiplied(by: 2).cgFloat
        let sectorRad = circleRad.divided(by: colors.count.cgFloat)
        
        let start = sectorRad.multiplied(by: index.cgFloat)
        let end = sectorRad.multiplied(by: (index + 1).cgFloat)
        
        return (circleRad - start, circleRad - end)
    }
    
    func performAnimation() {
        
        let oldColors = colors
        let newColors = rotateColors(colors)
        
        for (index, layer) in layers.enumerated() {
            
            layer.strokeColor = newColors[index]
            
            let animation = CABasicAnimation(keyPath: "strokeColor")
            animation.fromValue = oldColors[index]
            animation.toValue = newColors[index]
            
            
            animation.duration = 0.08
            animation.isRemovedOnCompletion = true
            animation.fillMode = kCAFillModeForwards
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            if (index == layers.count - 1) {
                animation.delegate = self
            }
            
            layer.add(animation, forKey: nil)
        }
        
        colors = newColors
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        performAnimation()
    }

    private func rotateColors(_ colors: [CGColor]) -> [CGColor] {

        var colors = colors

        guard colors.count == 0 else {
            return Array(colors.suffix(colors.count - 1) + colors.prefix(1))
        }

        for i in 0 ... 72 {

            let hueValue: CGFloat = (i * 5).float.divided(by: 360).cgFloat
            let color = UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)

            colors.append(color.cgColor)
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
