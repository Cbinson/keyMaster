//
//  LogInViewController.swift
//  keyMaster
//
//  Created by robinson on 2017/3/19.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit
import LocalAuthentication

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var noteTxt: UILabel!
    
    var context = LAContext()
    
    @IBOutlet weak var touchImage: UIImageView!
    @IBOutlet weak var refresh: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    func updateUI() {
        var policy:LAPolicy?
        
        if #available(iOS 9.0, *) { //ios 9.0
            policy = .deviceOwnerAuthentication
        }else{  //ios 8.0
            context.localizedFallbackTitle = "Fuu!"
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            touchImage.image = UIImage(named: "TouchID_off")
            // Print the localized message received by the system
            noteTxt.text = err?.localizedDescription
            return
        }
        
        // Great! The user is able to use his/her Touch ID 👍
        touchImage.image = UIImage(named: "TouchID_on")
        noteTxt.text = "請使用touchID解鎖"
        
        self.loginProcess(policy: policy!)
    }
    
    private func loginProcess(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: "請使用touchID解鎖", reply: { (success, error) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.refresh.alpha = 1
                })
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.noteTxt.text = "There was a problem verifying your identity."
                    case LAError.userCancel:
                        self.noteTxt.text = "Authentication was canceled by user."
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        self.noteTxt.text = "The user tapped the fallback button (Fuu!)"
                    case LAError.systemCancel:
                        self.noteTxt.text = "Authentication was canceled by system."
                    case LAError.passcodeNotSet:
                        self.noteTxt.text = "Passcode is not set on the device."
                    case LAError.touchIDNotAvailable:
                        self.noteTxt.text = "Touch ID is not available on the device."
                    case LAError.touchIDNotEnrolled:
                        self.noteTxt.text = "Touch ID has no enrolled fingers."
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        self.noteTxt.text = "There were too many failed Touch ID attempts and Touch ID is now locked."
                    case LAError.appCancel:
                        self.noteTxt.text = "Authentication was canceled by application."
                    case LAError.invalidContext:
                        self.noteTxt.text = "LAContext passed to this call has been previously invalidated."
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        self.noteTxt.text = "Touch ID may not be configured"
                        break
                    }
                    return
                }
                
                // Good news! Everything went fine 👏
                self.noteTxt.text = "登入成功"
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func showUnexpectedErrorMessage() {
        touchImage.image = UIImage(named: "TouchID_off")
        noteTxt.text = "Unexpected error! 😱"
    }
    
    
    @IBAction func clickRefush(_ sender: UIButton) {
        context = LAContext()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.refresh.alpha = 0
        })
        
        updateUI()
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
