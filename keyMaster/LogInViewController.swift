//
//  LogInViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/19.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    let test:String = "00180"
    
    @IBOutlet weak var psdTxtFild: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.psdTxtFild.isSecureTextEntry = true
//        self.psdTxtFild.keyboardType = UIKeyboardType.numberPad
    }
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let password = textField.text {
            print("text:\(password)")
            if self.checkPassword(psd: self.psdTxtFild.text) {
                self.dismiss(animated: true, completion: nil)
            }else{
                
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func clickEnterBtn(_ sender: UIButton) {
        self.psdTxtFild.resignFirstResponder()
        
        if self.checkPassword(psd: self.psdTxtFild.text) {
            self.dismiss(animated: true, completion: nil)
        }else{
            
        }
        
    }
    
    
    func checkPassword(psd:String?) -> Bool {
        var result:Bool = false
        
        if let psdStr = psd {
            if psdStr == self.test {
                result = true
            }
        }
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
