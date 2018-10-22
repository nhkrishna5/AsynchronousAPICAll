//
//  UIView+AnimationView.h
//  WalkThroughObjc
//
//  Created by CSS on 13/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AnimationView)

@property (nonatomic) IBInspectable NSInteger Animation_Type;

@property (nonatomic) IBInspectable float Animation_Duration;

@property (nonatomic) IBInspectable float Animation_Delay;

typedef NS_ENUM(NSInteger, animationType) {
    
    BounceLeft,     //1
    BounceRight,    //2
    BounceDown,     //3
    BounceTop,      //4
    FadeIn,         //5
    FadeOut,        //6
    FadeInLeft,     //7
    FadeInRight,    //8
    FadeInTop,      //9
    FadeInBottom,   //10
    SlideLeft,      //12
    SlideRight,     //13
    SlideTop,       //14
    SlideBottom,    //15
    Pop,            //16
    Morph,          //17
    Flash,          //18
    Shake,          //19
    ZoomIn,         //20
    ZoomOut,        //21
    
};

typedef NS_ENUM(NSInteger, State)
{
    Top,        //1
    Bottom,     //2
    Left,       //3
    Right       //4
};

@end
