//
// Created by Igor on 21/02/2017.
// Copyright (c) 2017 Igor Kislyuk. All rights reserved.
//

import UIKit

class IKProgressView: UIView {

    private var progressLabel: UILabel
    private var progressLayer = CAShapeLayer()
    
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
        createProgressLayer()
        
        self.backgroundColor = UIColor.clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //todo: add functionality
    }
    
    // TODO: extract values for IB
    
    func createLabel() {
        
        progressLabel = UILabel(frame: CGRect(x:0.0, y:0.0, width:frame.width, height:60.0))
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        progressLabel.text = "Load content"
        progressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40.0)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: progressLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: progressLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    func createProgressLayer() {
        
        //create circle
        let layer = CAShapeLayer()
        
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = CGFloat(M_PI * 2)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let path = UIBezierPath(arcCenter: center, radius: 150 /*size of circle width*/, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
        
        layer.path = path
        layer.strokeColor = UIColor.red.cgColor
        layer.backgroundColor = nil
        layer.fillColor = nil
        layer.lineWidth = 30.0
//        layer.lineCap = kCALineCapRound

        layer.strokeStart = 0.001
        layer.strokeEnd = 0.002
        
        let layer2 = CAShapeLayer()
        
//        let startAngle: CGFloat = 0
//        let endAngle: CGFloat = CGFloat(M_PI * 2)
//        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
//        let path = UIBezierPath(arcCenter: center, radius: 150 /*size of circle width*/, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
        
        layer2.path = path
        layer2.strokeColor = UIColor.blue.cgColor
        layer2.backgroundColor = nil
        layer2.fillColor = nil
        layer2.lineWidth = 30.0
        //        layer.lineCap = kCALineCapRound
        
        layer2.strokeStart = 0.002
        layer2.strokeEnd = 0.003
//        layer.mask = maskLayer()
        
//        let layer = CAGradientLayer()
//        layer.frame = bounds
//        layer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
//        
//        let locations: [NSNumber] = [0.4, 0.8]
//        layer.locations = locations
        
        
        self.layer.addSublayer(layer)
        self.layer.addSublayer(layer2)
        
//        progressLayer = layer
        
//        let animation = CABasicAnimation(keyPath: "strokeColor")
//        animation.fromValue = UIColor.red.cgColor
//        animation.toValue = UIColor.blue.cgColor
//        
//        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
//        animation2.fromValue = NSNumber(value: 0.6)
//        animation2.toValue = NSNumber(value: 1.0)
//        
//        let animation3 = CABasicAnimation(keyPath: "strokeStart")
//        animation3.fromValue = NSNumber(value: 0.0)
//        animation3.toValue = NSNumber(value: 0.6)
//        
//        let group = CAAnimationGroup()
//        group.animations = [animation, animation2, animation3]
//        group.duration = 2.0
//        
//        layer.add(group, forKey: nil)
        
    }
    
    private func maskLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
//        let startAngle: CGFloat = 0
//        let endAngle: CGFloat = CGFloat(M_PI * 2)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let rect = CGRect(origin: center, size: CGSize(width: 100, height: 140))
        let path = UIBezierPath(rect: rect).cgPath
        
        layer.path = path
        
        return layer
    }
    


}
