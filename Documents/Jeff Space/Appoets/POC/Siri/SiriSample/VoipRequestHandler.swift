//
//  VoipRequestHandler.swift
//  SampleSiri
//
//  Created by CSS on 08/07/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import Foundation
import Intents

class VoipRequestHandler : NSObject, INCallsDomainHandling {
    
    func handle(intent: INStartAudioCallIntent, completion: @escaping (INStartAudioCallIntentResponse) -> Void) {
        
        let response = INStartAudioCallIntentResponse(code: .continueInApp, userActivity: nil)
        completion(response)
    }
    
    func handle(intent: INStartVideoCallIntent, completion: @escaping (INStartVideoCallIntentResponse) -> Void) {
        let response = INStartVideoCallIntentResponse(code: .continueInApp, userActivity: nil)
        completion(response)
    }
    
    func handle(intent: INSearchCallHistoryIntent, completion: @escaping (INSearchCallHistoryIntentResponse) -> Void) {
        let response = INSearchCallHistoryIntentResponse(code: .continueInApp, userActivity: nil)
        completion(response)
    }
    
    
}
