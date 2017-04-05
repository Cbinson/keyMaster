//
//  DescrptionCell.swift
//  keyMaster
//
//  Created by robinson on 2017/3/26.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class DescrptionCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var descriptionTxtField: UITextField!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.descriptionTxtField.delegate = self
        self.descriptionTxtField.returnKeyType = .done
        self.descriptionTxtField.placeholder = "請輸入敘述"

        self.resignFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    //MARK: textfield delegate
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.descriptionTxtField.text = textField.text
    }


    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

}
