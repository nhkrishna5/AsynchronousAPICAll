//
//  ViewController.swift
//  MVVMSample
//
//  Created by CSS on 15/02/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var tableView : UITableView!

    private var name : Bind<String>? = Bind(nil)
    
    private var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        name?.bind(listener: {
            
            print("Value --", $0 ?? "" )
            
        })
        
        json()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.tableView.setEditing(true, animated: true)
    }
    
    
    private func json(){
        
        let user = User(id: 0, name: nil, address: "Chennai")
        
        let data = try! JSONEncoder().encode(user)
        
        print(data)
        
        
        
    }
    
    
    

    
    @IBAction private func action(sender : Any){
        
       name?.value = "\(value)"
        
       value = value+1
        
    }
    
    
    @IBAction private func push(){
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController{
            
            vc.name = self.name
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    

}


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
}

