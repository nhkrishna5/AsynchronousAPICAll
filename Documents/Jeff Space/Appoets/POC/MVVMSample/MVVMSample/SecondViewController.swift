//
//  SecondViewController.swift
//  MVVMSample
//
//  Created by CSS on 15/02/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var name : Bind<String>?
    
    private var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    @IBAction private func action(sender : Any){
        
        name?.value = "\(value)"
        
        value = value+1
        
    }

}
