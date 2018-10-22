//
//  RTCVideoChatViewController.swift
//  Apprtc
//
//  Created by Mahabali on 9/6/15.
//  Copyright (c) 2015 Mahabali. All rights reserved.
//

import UIKit
import AVFoundation
import WebRTC
class RTCVideoChatViewController: UIViewController,RTCEAGLVideoViewDelegate,ARDAppClientDelegate {
 
  //Views, Labels, and Buttons
  @IBOutlet weak var remoteView:RTCEAGLVideoView?
  @IBOutlet weak var localView:RTCEAGLVideoView?
  @IBOutlet weak var buttonContainerView:UIView?
  @IBOutlet weak var audioButton:UIButton?
  @IBOutlet weak var videoButton:UIButton?
  @IBOutlet weak var hangupButton:UIButton?
  //Auto Layout Constraints used for animations
  @IBOutlet weak var remoteViewTopConstraint:NSLayoutConstraint?
  @IBOutlet weak var remoteViewRightConstraint:NSLayoutConstraint?
  @IBOutlet weak var remoteViewLeftConstraint:NSLayoutConstraint?
  @IBOutlet weak var remoteViewBottomConstraint:NSLayoutConstraint?
  @IBOutlet weak var localViewWidthConstraint:NSLayoutConstraint?
  @IBOutlet weak var localViewHeightConstraint:NSLayoutConstraint?
  @IBOutlet weak var  localViewRightConstraint:NSLayoutConstraint?
  @IBOutlet weak var  localViewBottomConstraint:NSLayoutConstraint?
  @IBOutlet weak var  footerViewBottomConstraint:NSLayoutConstraint?
  @IBOutlet weak var  buttonContainerViewLeftConstraint:NSLayoutConstraint?
    
  var   roomUrl:NSString?;
  var   client:ARDAppClient?;
  var   roomName:NSString?
  var   localVideoTrack:RTCVideoTrack?;
  var   remoteVideoTrack:RTCVideoTrack?;
  var   localVideoSize:CGSize?;
  var   remoteVideoSize:CGSize?;
  var   isZoom:Bool = false; //used for double tap remote view
  var   captureController:ARDCaptureController = ARDCaptureController()
    
  private var currentUser : Int = 10
  private var ringerView : RingerView?
  private var callType : Mime!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.callType = .audio
    
    
    self.showRingerView()
    self.roomName = "300_chats_400_TEST"
    self.isZoom = false;
    self.audioButton?.layer.cornerRadius=20.0
    self.videoButton?.layer.cornerRadius=20.0
    self.hangupButton?.layer.cornerRadius=20.0
    let tapGestureRecognizer:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(RTCVideoChatViewController.toggleButtonContainer) )
    tapGestureRecognizer.numberOfTapsRequired=1
    self.view.addGestureRecognizer(tapGestureRecognizer)
    let zoomGestureRecognizer:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(RTCVideoChatViewController.zoomRemote) )
    zoomGestureRecognizer.numberOfTapsRequired=2
    self.view.addGestureRecognizer(zoomGestureRecognizer)
    self.remoteView?.delegate=self
    self.localView?.delegate=self
    NotificationCenter.default.addObserver(self, selector: #selector(RTCVideoChatViewController.orientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    self.localViewBottomConstraint?.constant=0.0
    self.localViewRightConstraint?.constant=0.0
    self.localViewHeightConstraint?.constant=self.view.frame.size.height
    self.localViewWidthConstraint?.constant=self.view.frame.size.width
    self.footerViewBottomConstraint?.constant=0.0
    self.disconnect()
    self.client=ARDAppClient(delegate: self)
    //self.client?.serverHostUrl="https://apprtc.appspot.com"
    let settingsModel = ARDSettingsModel()
    client!.connectToRoom(withId: self.roomName! as String!, settings: settingsModel, isLoopback: false, isAudioOnly: false, shouldMakeAecDump: false, shouldUseLevelControl: false)
    
  }
    
    
    //MARK:- Show Ringer View
    
    private func showRingerView(){
        
        self.ringerView = Bundle.main.loadNibNamed("RingerView", owner: self, options: [:])?.first as? RingerView
      
        if self.ringerView != nil {
            
            ringerView?.set(frame: self.view.frame, type: callType ,name: "\(self.currentUser)", didCancel: {
                self.removeRingerView()
            })
            
            self.ringerView?.show(with: .bottom, completion : nil)
            self.view.addSubview(ringerView!)
        }
        
    }
    
    //MARK:- Remove Ringer View
    
    private func removeRingerView(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.ringerView?.frame.origin.y = self.view.frame.height
            self.ringerView?.alpha = 0
        }, completion: { (bool) in
            self.ringerView?.removeFromSuperview()
            self.ringerView = nil
        })
        
    }
    
    
  
  override func  viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    NotificationCenter.default.removeObserver(self)
    self.disconnect()
  }
  
  override var  shouldAutorotate : Bool {
    return true
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.allButUpsideDown
  }
  
  func applicationWillResignActive(_ application:UIApplication){
    self.disconnect()
  }
  
    @objc func orientationChanged(_ notification:Notification){
    if let _ = self.localVideoSize {
      self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
    }
    if let _ = self.remoteVideoSize {
      self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
    }
  }
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func audioButtonPressed (_ sender:UIButton){
    sender.isSelected = !sender.isSelected
    self.client?.toggleAudioMute()
  }
  @IBAction func videoButtonPressed(_ sender:UIButton){
    sender.isSelected = !sender.isSelected
    self.client?.toggleVideoMute()
  }
  
  @IBAction func hangupButtonPressed(_ sender:UIButton){
    self.disconnect()
  }
  
  func disconnect(){
    if let _ = self.client{
      self.localVideoTrack?.remove(self.localView!)
      self.remoteVideoTrack?.remove(self.remoteView!)
      self.localView?.renderFrame(nil)
      self.remoteView?.renderFrame(nil)
      self.localVideoTrack=nil
      self.remoteVideoTrack=nil
      self.client?.disconnect()
    }
    
     self.popOrDismiss(animation: true)
  }
  
  func remoteDisconnected(){
    
    self.remoteVideoTrack?.remove(self.remoteView!)
    self.remoteView?.renderFrame(nil)
    if self.localVideoSize != nil {
      self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
    }
    
    self.popOrDismiss(animation: true)
    
  }
  
    @objc func toggleButtonContainer() {
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      if (self.buttonContainerViewLeftConstraint!.constant <= -40.0) {
        self.buttonContainerViewLeftConstraint!.constant=20.0
        self.buttonContainerView!.alpha=1.0;
      }
      else {
        self.buttonContainerViewLeftConstraint!.constant = -40.0;
        self.buttonContainerView!.alpha=0.0;
      }
      self.view.layoutIfNeeded();
    })
  }
  
    @objc func zoomRemote() {
    //Toggle Aspect Fill or Fit
    self.isZoom = !self.isZoom;
    self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
  }
  
 
    //MARK:- didChange
    
  func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
    switch (state) {
    case .connected:
      print("Client connected.");
    case .connecting:
      print("Client connecting.");
    case .disconnected:
      print("Client disconnected.");
      self.remoteDisconnected();
    }
  }
  
    //MARK:- ARDAppClient!, didError
    
  public func appClient(_ client: ARDAppClient!, didError error: Error!) {
   
    DispatchQueue.main.async {
        self.view.make(toast: error.localizedDescription, duration: 2)
        self.disconnect()
    }
    
  }
  
  func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
    self.localVideoTrack?.remove(self.localView!)
    self.localView?.renderFrame(nil)
    self.localVideoTrack=localVideoTrack
    self.localVideoTrack?.add(self.localView!)
    
  }

    public func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        let settingsModel = ARDSettingsModel()
        captureController = ARDCaptureController(capturer: localCapturer, settings: settingsModel)
        captureController.startCapture()
    }
    
  
  func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
    
    // MARK:- REMOVE RINGER VIEW
    
    self.removeRingerView() // Remove ringer view on remote connection 
    
    self.remoteVideoTrack=remoteVideoTrack
    self.remoteVideoTrack?.add(self.remoteView!)
    UIView.animate(withDuration: 0.4, animations: { () -> Void in
      self.localViewBottomConstraint?.constant=28.0
      self.localViewRightConstraint?.constant=28.0
      self.localViewHeightConstraint?.constant=self.view.frame.size.height/4
      self.localViewWidthConstraint?.constant=self.view.frame.size.width/4
      self.footerViewBottomConstraint?.constant = -80.0
    })
  }
 

    
  func appclient(_ client: ARDAppClient!, didRotateWithLocal localVideoTrack: RTCVideoTrack!, remoteVideoTrack: RTCVideoTrack!) {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(RTCVideoChatViewController.updateUIForRotation), object: nil)
    // Hack for rotation to get the right video size
    self.perform(#selector(RTCVideoChatViewController.updateUIForRotation), with: nil, afterDelay: 0.2)
  }
    
    public func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        
    }
    
    public func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        
    }
  
    @objc func updateUIForRotation(){
    let statusBarOrientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
    let deviceOrientation:UIDeviceOrientation  = UIDevice.current.orientation
    if (statusBarOrientation.rawValue==deviceOrientation.rawValue){
      if let  _ = self.localVideoSize {
      self.videoView(self.localView!, didChangeVideoSize: self.localVideoSize!)
      }
      if let _ = self.remoteVideoSize {
        self.videoView(self.remoteView!, didChangeVideoSize: self.remoteVideoSize!)
      }
    }
    else{
      print("Unknown orientation Skipped rotation");
    }
  }
  
  func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
    let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    UIView.animate(withDuration: 0.4, animations: { () -> Void in
      let containerWidth: CGFloat = self.view.frame.size.width
      let containerHeight: CGFloat = self.view.frame.size.height
      let defaultAspectRatio: CGSize = CGSize(width: 4, height: 3)
      if videoView == self.localView {
        self.localVideoSize = size
        let aspectRatio: CGSize = size.equalTo(CGSize.zero) ? defaultAspectRatio : size
        var videoRect: CGRect = self.view.bounds
        if (self.remoteVideoTrack != nil) {
          videoRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width / 4.0, height: self.view.frame.size.height / 4.0)
          if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
            videoRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.height / 4.0, height: self.view.frame.size.width / 4.0)
          }
        }
        let videoFrame: CGRect = AVMakeRect(aspectRatio: aspectRatio, insideRect: videoRect)
        self.localViewWidthConstraint!.constant = videoFrame.size.width
        self.localViewHeightConstraint!.constant = videoFrame.size.height
        if (self.remoteVideoTrack != nil) {
          self.localViewBottomConstraint!.constant = 28.0
          self.localViewRightConstraint!.constant = 28.0
        }
        else{
          self.localViewBottomConstraint!.constant = containerHeight/2.0 - videoFrame.size.height/2.0
          self.localViewRightConstraint!.constant = containerWidth/2.0 - videoFrame.size.width/2.0
        }
      }
      else if videoView == self.remoteView {
        self.remoteVideoSize = size
        let aspectRatio: CGSize = size.equalTo(CGSize.zero) ? defaultAspectRatio : size
        let videoRect: CGRect = self.view.bounds
        var videoFrame: CGRect = AVMakeRect(aspectRatio: aspectRatio, insideRect: videoRect)
        if self.isZoom {
          let scale: CGFloat = max(containerWidth / videoFrame.size.width, containerHeight / videoFrame.size.height)
          videoFrame.size.width *= scale
          videoFrame.size.height *= scale
        }
        self.remoteViewTopConstraint!.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
        self.remoteViewBottomConstraint!.constant = (containerHeight / 2.0 - videoFrame.size.height / 2.0)
        self.remoteViewLeftConstraint!.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
        self.remoteViewRightConstraint!.constant = (containerWidth / 2.0 - videoFrame.size.width / 2.0)
      }
      self.view.layoutIfNeeded()
    })
    
  }
}
