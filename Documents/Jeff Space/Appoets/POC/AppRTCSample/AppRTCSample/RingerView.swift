//
//  RingerViewController.swift
//  AppRTCSample
//
//  Created by CSS on 26/03/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit


class RingerView: UIView{
    
    
    @IBOutlet private var labelName : UILabel!
    @IBOutlet private var labelType : UILabel!
    @IBOutlet private var imageViewUser : UIImageView!
    
    private var onCancel : (()->())!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageViewUser.makeRoundedCorner()
    }
   
    //MARK:- Set Values
    func set(frame : CGRect,type : Mime, name : String?, didCancel : @escaping (()->())){
        
        self.labelType.text = type == .audio ? "JWCHAT Voice Call" : "JWCHAT Video Call"
        self.labelName.text = name
        self.frame = frame
        self.onCancel = didCancel
        
    }
    
    
    //MARK:- OnEnd Button Click
    
    @IBAction private func endCallButtonClick(){
        
        self.onCancel()
        
    }
    
    

}
