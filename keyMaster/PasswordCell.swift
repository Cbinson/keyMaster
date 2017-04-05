//
//  PasswordCell.swift
//  keyMaster
//
//  Created by robinson on 2017/3/26.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class PasswordCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var passwordTxtField: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.passwordTxtField.delegate = self
        self.passwordTxtField.returnKeyType = .done
        self.passwordTxtField.placeholder = "請輸入密碼"

        self.resignFirstResponder()
    }


    //MARK: textfield delegate
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.passwordTxtField.text = textField.text
    }


    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
