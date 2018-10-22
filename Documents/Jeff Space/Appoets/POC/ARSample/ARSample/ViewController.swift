//
//  ViewController.swift
//  ARSample
//
//  Created by CSS on 12/02/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let testResults = sceneView.hitTest(touch.location(in: sceneView), types: .featurePoint)
        
       // guard  let testResult = testResults.last else {return}
        
      //  let hitTransform = SCNMatrix
       //
      // let bundle = NSBundleResourceRequest(tags: <#T##Set<String>#>)
        
      //  bundle.beginAccessingResources(completionHandler: <#T##(Error?) -> Void#>)
        
        
//        typealias CurrentTemperatureCompletion = (String) -> String?
//        
//        func get(value : String, completion : CurrentTemperatureCompletion){
//            let valueProcessed = "Processed value \(value)"
//            
//            let completed = completion(valueProcessed) // Getting return value from completion block
//            
//            print("Finally ---  >>>", completed)
//            
//        }
//        
//        
//        get(value: "Jeff") { (completedValue) -> String? in
//            // Here you can use the value and also send to the previous block for reference
//            return "Hello \(completedValue)"
//            
//        }
        
        
        
        
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
