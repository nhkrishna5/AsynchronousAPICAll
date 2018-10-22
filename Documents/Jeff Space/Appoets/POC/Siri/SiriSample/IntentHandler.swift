import Intents
import UIKit

class IntentHandler: INExtension {
   
    override func handler(for intent: INIntent) -> Any? {
        
        print(intent)
        
        if intent is INRequestRideIntent {
            return RideRequestHandler()
        } else if intent is INStartAudioCallIntentHandling {
            return VoipRequestHandler()
        }
        return .none
    }

}


public extension UIImage {
    public var inImage: INImage {
        return INImage(imageData: UIImagePNGRepresentation(self)!)
    }
}
