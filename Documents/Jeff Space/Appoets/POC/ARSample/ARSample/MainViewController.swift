//
//  MainViewController.swift
//  ARSample
//
//  Created by CSS on 14/06/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

   @IBOutlet private var viewTransform : UIView!
   @IBOutlet private var viewBase : UIView!
   @IBOutlet private var viewInner : UIView!
    
   var isPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBase.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:))))
        print(viewBase.frame.size)
        self.setTransform(transform: CGAffineTransform(scaleX: 0, y: 0), alpha: 0)
    }

    @IBAction private func panAction(sender : UIPanGestureRecognizer) {
        
        guard !isPresented else {
            return
        }
        
        if sender.state == .began || sender.state == .changed {
            let point = sender.translation(in: self.view)
            print("point  ",point)
            let value = (abs(point.y)/viewBase.frame.height)
            UIView.animate(withDuration: 0.3) {
                self.setTransform(transform: CGAffineTransform(scaleX: value, y: value), alpha: value)
            }
            if value>0.8 {
                self.isPresented = true
                UIView.animate(withDuration: 0.3) {
                    self.setTransform(transform: .identity, alpha: 1)
                }
            }
            
            print("value  ",viewInner.center)
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                self.setTransform(transform: CGAffineTransform(scaleX: 0, y: 0), alpha: 0)
            }, completion: nil)
        }
        
    }
    
    
    private func setTransform(transform : CGAffineTransform, alpha : CGFloat) {
        
        self.viewInner.alpha = alpha
        self.viewInner.transform = transform
        self.viewInner.center = CGPoint(x: self.viewInner.frame.width/2, y: self.viewBase.frame.height-(self.viewInner.frame.height/2))
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
