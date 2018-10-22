//
//  ViewController.swift
//  CallKitSample
//
//  Created by CSS on 29/03/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit
import JeffSamplePod

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(self.make), with: self, afterDelay: 5)
    }

    @IBAction private func make(){
        
        //CallKitHelper.shared.makeCall()
    }
    
    
    
    

}

