//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import QuartzCore

// todo: README
// todo: license
// todo: travis
// todo: IBDesignable
// todo: reposition

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

//        testColors()
        createProgressLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //todo: add functionality
    }

    func createLabel() {

        progressLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: 60.0))
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        progressLabel.text = "Load content"
        progressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40.0)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)

        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: progressLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: progressLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    func createShape(with path: CGPath, from: (start: Float, end: Float), color: CGColor) -> CAShapeLayer {
    
        let layer = CAShapeLayer()
        
        layer.path = path
        layer.strokeColor = color
        layer.backgroundColor = nil
        layer.fillColor = nil
        layer.lineWidth = 30.0
        
        layer.strokeStart = from.start.cgFloat
        layer.strokeEnd = from.end.cgFloat
        
        return layer
    }

    func createProgressLayer() {
        
        colors = rotateColors(colors)
        
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = CGFloat(M_PI * 2)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let path = UIBezierPath(arcCenter: center, radius: 150, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
        
        let size = 0.006.float
        
        for (index, color) in colors.enumerated() {
            
            let start = index.float.multiplied(by: size)
            let end = (index + 1).float.multiplied(by: size)
            
            let shape = createShape(with: path, from: (start, end), color: color)
            
            layer.addSublayer(shape)
            
            layers.append(shape)
        }
        
        performAnimation()

    }

    func testColors() {

        colors = rotateColors(colors)

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        layer.addSublayer(gradient)
        
        self.gradient = gradient
        
        performAnimation()

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
            
            if (index == layers.endIndex) {
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

    private func maskLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let rect = CGRect(origin: center, size: CGSize(width: 100, height: 140))
        let path = UIBezierPath(rect: rect).cgPath

        layer.path = path

        return layer
    }


}

extension Double {
    var float: Float {
        return Float(self)
    }
}

extension Int {
    var float: Float {
        return Float(self)
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
