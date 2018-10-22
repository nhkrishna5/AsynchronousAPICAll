//
//  ViewController.swift
//  SocketSample
//
//  Created by CSS on 12/08/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit
import SocketIO
class ViewController: UIViewController {

    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
    //let socket = SocketIOClient(manager: manager, nsp: "/")
    var socket : SocketIOClient?
    var widthCont : NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeView()
        manager.config = SocketIOClientConfiguration(arrayLiteral: .secure(false))
        socket = SocketIOClient(manager: manager, nsp: "/")
//        socket.on(clientEvent: .connect) { (_, _) in
//            print("Connected")
//            socket.emit("location", "Hei")
//        }
        socket?.on("connect") { _, _ in
            print("socket connected")
            self.socket?.emit("ping", "data")
        }
        
        socket?.on("value", callback: { (data, _) in
            print("value  ",data)
        })
        
        socket?.connect()
        
//        socket.defaultSocket.connect(timeoutAfter: 0) {
//            self.socket.defaultSocket.emit("location", self.socket.socketURL.absoluteString)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func makeView() {
        let viewSmall = UIView()
        viewSmall.backgroundColor = .red
        viewSmall.accessibilityIdentifier = "New"
        self.view.addSubview(viewSmall)
        viewSmall.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = viewSmall.heightAnchor.constraint(equalToConstant: 70)
        widthCont = viewSmall.widthAnchor.constraint(equalToConstant: 40)
        let centerX = self.view.centerXAnchor.constraint(equalTo: viewSmall.centerXAnchor)
        let centerY = self.view.centerYAnchor.constraint(equalTo: viewSmall.centerYAnchor)
        self.perform(#selector(self.timer), with: self, afterDelay: 10)
        self.view.addConstraints([heightConstraint,widthCont!,centerX,centerY])
    }
    
    @IBAction func timer() {
        self.widthCont?.constant = (self.widthCont?.constant ?? 30)*3
        self.view.layoutIfNeeded()
    }
    
    

}

