//
//  CallKitHelper.swift
//  CallKitSample
//
//  Created by CSS on 29/03/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import Foundation
import CallKit
import UIKit

/*

class ProviderDelegate: NSObject {
    
    fileprivate let callManager: CallManager
    fileprivate let provider: CXProvider
    
    init(callManager: CallManager) {
        self.callManager = callManager
        
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
    
    // 4.
    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")
        
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        return providerConfiguration
    }
    
    
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        // 1.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        // 2.
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                // 3.
                let call = Call(uuid: uuid, handle: handle)
                self.callManager.add(call: call)
            }
            
            // 4.
            completion?(error as? NSError)
        }
    }
}

extension ProviderDelegate: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
        stopAudio()
        
        for call in callManager.calls {
            call.end()
        }
        
        callManager.removeAllCalls()
    }
} */


class CallKitHelper : NSObject {
    
    static let shared = CallKitHelper()
    
    private var provider : CXProvider!
    
    private let uuid = "usfjkdsnksd"
    private let handle = "handle"
    
    
    private func initProvider(){
        
        
        let providerConfig = CXProviderConfiguration(localizedName: "CallKit Sample")
        providerConfig.supportsVideo = false
        providerConfig.maximumCallsPerCallGroup = 1
        providerConfig.supportedHandleTypes = [.phoneNumber]
        providerConfig.iconTemplateImageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "profile"))
        providerConfig.ringtoneSound = "Ringtone.caf"
        
        
        
        self.provider =  CXProvider(configuration: providerConfig)
        self.provider.setDelegate(self, queue: nil)
        
    }
    
    
    
    func makeCall(){
        
        self.initProvider()
        
        let update = CXCallUpdate()
        update.hasVideo = true
        update.remoteHandle = CXHandle(type: .phoneNumber, value: "String")
        
        provider.reportNewIncomingCall(with: UUID(), update: update) { (error) in
            
            if error != nil {
                
                print("Error   \(error!.localizedDescription)")
            }
        }
        
    }
    
    
}

extension CallKitHelper : CXProviderDelegate {
   
    
    func providerDidReset(_ provider: CXProvider) {
        
        
        
    }
    
    
}









