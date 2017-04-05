//
//  AccountCell.swift
//  keyMaster
//
//  Created by robinson on 2017/3/26.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var accountTxtField: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accountTxtField.delegate = self
        self.accountTxtField.returnKeyType = .done
        self.accountTxtField.placeholder = "請輸入帳號"

        self.resignFirstResponder()
    }


    //MARK: textfield delegate
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.accountTxtField.text = textField.text
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
