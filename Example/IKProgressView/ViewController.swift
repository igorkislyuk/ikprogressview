//
//  ViewController.swift
//  IKProgressBar
//
//  Created by Igor on 21/02/2017.
//  Copyright © 2017 Igor Kislyuk. All rights reserved.
//

import UIKit
import IKProgressView

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: IKProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            [weak self]
            in
            self?.animateProgress()
        }
    }
    
    func animateProgress() {
        let rand = arc4random_uniform(100)
        let progress = CGFloat(rand) / CGFloat(100)
        print(progress)
        progressView.setProgress(progress, animated: true, {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                [weak self] in
                self?.animateProgress()
            }
        })
        
    }
    
    @IBAction func actionValueChanged(_ sender: Any) {
        if let sw = sender as? UISwitch {
            progressView.animated = sw.isOn
        }
    }
    
    @IBAction func actionFilledChanged(_ sender: Any) {
        if let sw = sender as? UISwitch {
            progressView.filledView = sw.isOn
        }
    }
    
    @IBAction func actionOuterRChanged(_ sender: Any) {
        if let sl = sender as? UISlider {
            progressView.exteriorR = Int(sl.value)
        }
    }
    
    @IBAction func actionInnerRChanged(_ sender: Any) {
        if let sl = sender as? UISlider {
            progressView.interiorR = Int(sl.value)
        }
    }
    
}

