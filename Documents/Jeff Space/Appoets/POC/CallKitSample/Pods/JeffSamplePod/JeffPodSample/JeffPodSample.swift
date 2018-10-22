//
//  JeffPodSample.swift
//  JeffPodSample
//
//  Created by CSS on 11/08/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import Foundation
import UIKit
public class Framework : NSObject {
    public func get()->String {
        return "Hello"
    }
    
public class func setFont(to field :Any, isTitle : Bool = false, size : CGFloat = 0) {
        
        let customSize = size > 0 ? size : (isTitle ? 18 : 16)
        let font = UIFont.systemFont(ofSize: customSize)
        switch (field.self) {
        case is UITextField:
            (field as? UITextField)?.font = font
        case is UILabel:
            (field as? UILabel)?.font = font//UIFont(name: isTitle ? FontCustom.avenier_Heavy.rawValue : FontCustom.avenier_Medium.rawValue, size: customSize)
        case is UIButton:
            (field as? UIButton)?.titleLabel?.font = font//UIFont(name: isTitle ? FontCustom.avenier_Heavy.rawValue : FontCustom.avenier_Medium.rawValue, size: customSize)
        case is UITextView:
            (field as? UITextView)?.font = font//UIFont(name: isTitle ? FontCustom.avenier_Heavy.rawValue : FontCustom.avenier_Medium.rawValue, size: customSize)
        default:
            break
        }
    }
}


