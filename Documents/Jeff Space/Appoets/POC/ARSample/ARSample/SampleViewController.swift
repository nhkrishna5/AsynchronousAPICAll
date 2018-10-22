//
//  SampleViewController.swift
//  ARSample
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {
    
    @IBOutlet private weak var viewCentre : UIView!
    
    @IBOutlet private weak var viewTop : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.viewCentre.isHidden = true
//        let pulsing = CAShapeLayer()
//        pulsing.path = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.maxX/2, y: self.view.frame.maxY/2), radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
//        //let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        pulsing.backgroundColor = UIColor.blue.cgColor
//        pulsing.strokeColor = UIColor.lightGray.cgColor
//        pulsing.lineWidth = 5
//        pulsing.fillColor = UIColor.yellow.cgColor
//        pulsing.lineCap = kCALineCapRound
//        pulsing.position = self.view.center
//        self.view.layer.addSublayer(pulsing)
//        print(pulsing.debugDescription)
        
        
        setupCircleLayers(view: self.viewCentre)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            self.viewChange()
//        }
    }

    private func viewChange() {
        
        let viewCenterY = ((viewCentre.bounds.height/2)-(viewCentre.center.y))+20
        
        print(self.viewCentre.frame)
        
        UIView.animate(withDuration: 1.5, animations: {
             self.viewCentre.transform  = CGAffineTransform(translationX: 0, y: viewCenterY).scaledBy(x: 0.7, y: 0.7)
             self.viewCentre.backgroundColor = .blue
            //transform //CGAffineTransform(translationX: 100, y: 100)
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                UIView.animate(withDuration: 1.5, animations: {
                    self.viewCentre.transform = .identity
                    self.viewCentre.backgroundColor = .yellow
                })
            })
        }
        
    }
   
}


//
//  Global.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Foundation


var currentBundle : Bundle!

var pulsatingLayer  = CAShapeLayer()
var shapeLayer: CAShapeLayer!

var animationGroup = CAAnimationGroup()

var initialPulseScale:Float = 0
var nextPulseAfter:TimeInterval = 0
var animationDuration:TimeInterval = 1.5
var radius:CGFloat = 200
var numberOfPulses:Float = Float.infinity



//MARK:- ShowLoader

internal func createActivityIndicator(_ uiView : UIView)->UIView{
    
    let container: UIView = UIView(frame: CGRect.zero)
    container.layer.frame.size = uiView.frame.size
    container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
    container.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = container.center
    loadingView.backgroundColor = UIColor(white:0.1, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.layer.shadowRadius = 5
    loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
    loadingView.layer.opacity = 2
    loadingView.layer.masksToBounds = false
    loadingView.layer.shadowColor = UIColor.primary.cgColor
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    actInd.clipsToBounds = true
    actInd.activityIndicatorViewStyle = .whiteLarge
    
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    container.isHidden = true
    uiView.addSubview(container)
    actInd.startAnimating()
    
    return container
    
}



func toastSuccess(_ view:UIView,message:NSString,smallFont:Bool,isPhoneX:Bool, color:UIColor){
    var labelView = UIView()
    if(isPhoneX){
        labelView = UILabel(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height: 84))
    }else{
        labelView = UILabel(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height: 84))
    }
    labelView.backgroundColor = color
    
    //UIColor(red: 35/255, green: 86/255, blue: 142/255, alpha: 1)
    
    
    let  toastLabel = UILabel(frame: CGRect(x: 0,y:(labelView.frame.size.height/2)-20,width:view.frame.size.width, height: labelView.frame.size.height/2))
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center
    toastLabel.numberOfLines = 2
    if(smallFont){
        // toastLabel.font = UIFont.boldSystemFont(ofSize: 10)
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
    }else{
        // toastLabel.font = toastLabel.font.withSize(14)
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
    }
    
    labelView.addSubview(toastLabel)
    view.addSubview(labelView)
    toastLabel.text = message as String
    labelView.alpha = 1.0
    let deadlineTime = DispatchTime.now() + .seconds(2)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        labelView.alpha = 0.0
        labelView.removeFromSuperview()
    }
}




//MARK:- set circle animation for request screen

func setCircleAnimation(view: UIView, toVlaue : Float){
    let shapeLayer = CAShapeLayer()
    
    let center = view.center
    
    // create my track layer
    let trackLayer = CAShapeLayer()
    
    let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
    trackLayer.path = circularPath.cgPath
    
    trackLayer.strokeColor = UIColor.lightGray.cgColor
    trackLayer.lineWidth = 5
    //trackLayer.fillColor = UIColor.clear.cgColor
    //trackLayer.lineCap = kCALineCapRound
    view.layer.addSublayer(trackLayer)
    //let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
    shapeLayer.path = circularPath.cgPath
    
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 5
    shapeLayer.fillColor = UIColor.black.cgColor
    shapeLayer.lineCap = kCALineCapRound
    
    shapeLayer.strokeEnd = 0
    
    view.layer.addSublayer(shapeLayer)
    
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.toValue = toVlaue
    basicAnimation.fromValue = 0
    basicAnimation.duration = 1
    //basicAnimation.repeatCount = 1
    //basicAnimation.repeatDuration = 60
    
    basicAnimation.fillMode = kCAFillModeForwards
    basicAnimation.isRemovedOnCompletion = false
    
    shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    
    
    
}

//MARK:- add blur effect to UIview

func addBlurEffectToView(view: UIView, blurEffect: UIBlurEffectStyle, backGroundColor: UIColor){
    
    let blurView = UIBlurEffect(style: blurEffect)
    let visualEffectView = UIVisualEffectView(effect: blurView)
    visualEffectView.frame = view.bounds
    visualEffectView.backgroundColor = backGroundColor
    
}



private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, view: UIView) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let circularPath = UIBezierPath(arcCenter: .zero, radius: view.bounds.width/2, startAngle: 0, endAngle: CGFloat.pi*2 , clockwise: true)
    layer.path = circularPath.cgPath
    layer.strokeColor = strokeColor.cgColor
    layer.lineWidth = 20
    layer.fillColor = fillColor.cgColor
    layer.lineCap = kCALineCapRound
    layer.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
    return layer
}


func setupCircleLayers(view: UIView) {
    
    pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor, view: view)
    //pulsatingLayer.position = CGPoint(x: view.bounds.maxX/2, y: view.bounds.maxY/2)
    view.layer.insertSublayer(pulsatingLayer, above: view.layer)
   _ = animatePulsatingLayer()
    
//    let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor, view: view)
//    view.layer.addSublayer(trackLayer)
    
//    shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear, view: view)
//
//    shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
//    shapeLayer.strokeEnd = 0
//    view.layer.addSublayer(shapeLayer)
}

func animatePulsatingLayer()-> CABasicAnimation {
    
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.toValue = 2
    animation.duration = animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.autoreverses = false
    animation.repeatCount = .infinity
    
    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.duration = animationDuration
    opacityAnimation.values = [0.4, 0.8, 0]
    opacityAnimation.keyTimes = [0, 0.2, 1]
   
    opacityAnimation.repeatCount = .greatestFiniteMagnitude
    pulsatingLayer.fillColor = UIColor.red.cgColor
    
    
    let time : TimeInterval = 30
    let warn : TimeInterval = 20
    let deadLine : TimeInterval = 10
    print("Called")
    
    let timer = Timer.scheduledTimer(withTimeInterval: (time-10), repeats: true) { (timer) in
        pulsatingLayer.fillColor = UIColor.red.cgColor
        print("Color Modified")
        timer.invalidate()
    }
    timer.fire()
    
    DispatchQueue.main.asyncAfter(deadline: (.now()+time)-deadLine, execute: {
        pulsatingLayer.fillColor = UIColor.red.cgColor
        print("Color Modified")
    })
    
    DispatchQueue.main.asyncAfter(deadline: (.now()+time)-warn, execute: {
        pulsatingLayer.fillColor = UIColor.yellow.cgColor
        print("Color Modified")
    })
    
    pulsatingLayer.add(animation, forKey: "pulsing")
    pulsatingLayer.add(opacityAnimation, forKey: "opacity")
    
    return animation
}

//Shadow View:
func shadowApply(view:UIView) -> UIView{
    
    let shadowSize : CGFloat = 0.3
    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2, y: -shadowSize / 2, width: view.frame.size.width + shadowSize, height: view.frame.size.height + shadowSize))
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.layer.shadowOpacity = 0.5
    view.layer.shadowPath = shadowPath.cgPath
    return view
}


func createOpacityAnimation() -> CAKeyframeAnimation {
    
    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.duration = animationDuration
    opacityAnimation.values = [0.4, 0.8, 0]
    opacityAnimation.keyTimes = [0, 0.2, 1]
    
    
    return opacityAnimation
}

func setupAnimationGroup() {
    /*animationGroup = CAAnimationGroup()
     animationGroup.duration = animationDuration + nextPulseAfter
     animationGroup.repeatCount = numberOfPulses
     
     let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
     animationGroup.timingFunction = defaultCurve
     
     animationGroup.animations = [animatePulsatingLayer(),createOpacityAnimation()] */
    
    
}


//setCommonFont

func setFont(TextField : UITextField?, label : UILabel?, Button: UIButton?, size: CGFloat?) {
    switch (TextField ,label, Button) {
    case (let TextFields, let labels, let Buttons) where TextField != nil :
        print("textfield")
        TextField?.font = UIFont(name: "Raleway-Medium", size: 16)
        if size != nil {
            TextField?.font = UIFont(name: "Raleway-Medium", size: size as! CGFloat)
        }
        break
    case (let TextFields, let labels, let Buttons) where  label != nil:
        print("label")
        label?.font = UIFont(name: "Raleway-Medium", size: 14)
        if size != nil {
            label?.font = UIFont(name: "Raleway-Medium", size: size as! CGFloat)
        }
        break
    case (let TextFields, let labels, let Buttons) where Button != nil:
        print("button")
        Button?.titleLabel?.font = UIFont(name: "Raleway-Medium", size: 17)
        if size != nil {
            Button?.titleLabel?.font = UIFont(name: "Raleway-Medium", size: size as! CGFloat)
        }
        break
    default:
        print("default")
    }
}


func converteMinToSec(Min: Int)-> (Int){
    return (Min * 60)
}

func convertMinToHour(minutes : Int) -> (Int) {
    return (minutes * 3600)
}



//
//  Colors.swift
//  User
//
//  Created by imac on 12/22/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

enum Color : Int {
    
    case primary = 1
    case secondary = 2
    case lightBlue = 3
    case brightBlue = 4
    
    
    static func valueFor(id : Int)->UIColor?{
        
        switch id {
        case self.primary.rawValue:
            return .primary
            
        case self.secondary.rawValue:
            return .secondary
            
        case self.lightBlue.rawValue:
            return .lightBlue
            
        case self.brightBlue.rawValue:
            return .brightBlue
            
        default:
            return nil
        }
        
        
    }
    
    
}

extension UIColor {
    
    // Primary Color
    static var primary : UIColor {
        return UIColor(red: 149/255, green: 116/255, blue: 205/255, alpha: 1)
    }
    
    // Secondary Color
    static var secondary : UIColor {
        return UIColor(red: 238/255, green: 98/255, blue: 145/255, alpha: 1)
    }
    
    // Secondary Color
    static var lightBlue : UIColor {
        return UIColor(red: 38/255, green: 118/255, blue: 188/255, alpha: 1)
    }
    
    //Gradient Start Color
    
    static var startGradient : UIColor {
        return UIColor(red: 83/255, green: 173/255, blue: 46/255, alpha: 1)
    }
    
    //Gradient End Color
    
    static var endGradient : UIColor {
        return UIColor(red: 158/255, green: 178/255, blue: 45/255, alpha: 1)
    }
    
    // Blue Color
    
    static var brightBlue : UIColor {
        return UIColor(red: 40/255, green: 25/255, blue: 255/255, alpha: 1)
    }
    
    
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
    
}



