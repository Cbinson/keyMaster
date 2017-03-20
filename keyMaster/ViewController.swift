//
//  ViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/19.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let loginQueue = DispatchQueue(label: "binson.keyMaster.queue")
        loginQueue.async { 
            let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC")
            self.present(logInVC!, animated: true, completion: nil)
        }
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

