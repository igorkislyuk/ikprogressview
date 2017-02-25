//
//  ViewController.swift
//  IKProgressBar
//
//  Created by Igor on 21/02/2017.
//  Copyright © 2017 Igor Kislyuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let view = IKProgressView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        self.view.addSubview(view)
    }


}

