//
//  ViewController.swift
//  HealthKitSample
//
//  Created by CSS on 30/06/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI

class ViewController: UIViewController {

    let healthKit = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHealthKit()
    }
    
    
    private func initHealthKit() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!])
            healthKit.requestAuthorization(toShare: allTypes, read: allTypes) { (isGranted, error) in
                
                print(isGranted, error)
                
            }
            
            let ringView = HKActivityRingView(frame: CGRect(origin: self.view.center, size: CGSize(width: 100, height: 100)))
            self.view.addSubview(ringView)
            
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

