//
//  ViewController.swift
//  SampleTemp
//
//  Created by CSS on 27/03/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let urlString = "https://valuecartdevbucket.s3.eu-central-1.amazonaws.com/product_images/1532602204531_3.jpg"
    
    @IBOutlet private weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        /*if let data = NSCache<AnyObject, AnyObject>().object(forKey: urlString as AnyObject) as? Data {
            print("-->>Cache")
            self.setImage(with: data)
        } else {
            print("-->>Server")
            URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, reponse, error) in
                guard let data = data, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                NSCache<AnyObject, AnyObject>().setObject(data as AnyObject, forKey: self.urlString as AnyObject)
                self.setImage(with: data)
                }.resume()
        }*/
    
    }
    
    private func setImage(with imageData : Data) {
        DispatchQueue.main.async {
            let imageView = UIImageView(frame: CGRect(x: 30, y: 50, width: 100, height: 100))
            imageView.image = UIImage(data: imageData)
            self.view.addSubview(imageView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "reusable", for: indexPath) as! TableCell
        let size = tableCell.textViewCell.sizeThatFits(CGSize(width: 30, height: 200))
        print(size)
        return tableCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


class TableCell : UITableViewCell {
    
    @IBOutlet var textViewCell : UITextView!
    
}
