//
//  ViewController.swift
//  SampleFlip
//
//  Created by CSS on 02/02/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet private var  viewFlip : UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewFlip.isUserInteractionEnabled  = true
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipe.direction = .up
        viewFlip.addGestureRecognizer(swipe)

    }


    
//
//    var firstView: UIView!
//    var secondView: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
////        firstView = UIView(frame: CGRect(x: 32, y: 32, width: 128, height: 128))
////        secondView = UIView(frame: CGRect(x: 32, y: 32, width: 128, height: 128))
////
////        firstView.backgroundColor = UIColor.red
////        secondView.backgroundColor = UIColor.blue
////
////        secondView.isHidden = true
////
////        view.addSubview(firstView)
////        view.addSubview(secondView)
////
////        perform(#selector(flip), with: nil, afterDelay: 2)
//    }
    
    

    
    
    @IBAction private func swipeAction(sender : UISwipeGestureRecognizer){
        
        var t = CATransform3DIdentity
        t.m34 = -1.0/1000 //Adds depth to the animation
        t = CATransform3DRotate(t, (.pi * 0.3), 1.0, 0, 0)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        
        UIView.animate(withDuration: 0.5) {
            sender.view?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            sender.view?.layer.transform = t
        }
        
        sender.view?.layer.transform = CATransform3DIdentity
        sender.view?.backgroundColor = .red
        CATransaction.commit()
        
    }
    


}

