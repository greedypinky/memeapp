//
//  ViewController.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-10-21.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
//    @IBAction func experiment() {
//        let image = UIImage()
//
//        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//        present(activityController, animated: true, completion: nil)
//
//
//    }
    
    @IBAction func experiment() {


        let alertController = UIAlertController()
        alertController.title = "Hello world"
        alertController.message = "click OK to dismiss!"
     
        let alertAction = UIAlertAction(title:"Cancel", style: UIAlertAction.Style.default) {
            action in self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertAction)
        //alertController.title = "hello world"
        //alertController.message = "what the fuck!"
        present(alertController, animated: true, completion: nil)
        // dismiss(animated: true, completion:nil)
        
    }

}

