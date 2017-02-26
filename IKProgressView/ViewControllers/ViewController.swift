//
//  ViewController.swift
//  IKProgressBar
//
//  Created by Igor on 21/02/2017.
//  Copyright © 2017 Igor Kislyuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: IKProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let delta = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delta) {
            self.progressView.progress = 50
            DispatchQueue.main.asyncAfter(deadline: .now() + delta, execute: {
                self.progressView.progress = 73
                DispatchQueue.main.asyncAfter(deadline: .now() + delta, execute: {
                    self.progressView.progress = 100
                })
            })
        }
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
    
    @IBAction func actionElementsChanged(_ sender: Any) {
        if let sl = sender as? UISlider {
            print("Elements: " + String(sl.value))
            progressView.elements = Int(sl.value)
        }
    }
    
    @IBAction func actionProgressChanged(_ sender: Any) {
        if let sl = sender as? UISlider {
            print("Progress: " + String(sl.value))
            progressView.progress = Int(sl.value)
        }
    }
    
    

}

