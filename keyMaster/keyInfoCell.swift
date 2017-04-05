//
//  keyInfoCell.swift
//  keyMaster
//
//  Created by binsonchang on 2017/3/29.
//  Copyright © 2017年 robinson. All rights reserved.
//

import UIKit

class keyInfoCell: UITableViewCell {

    @IBOutlet weak var keyDescrption: UILabel!
    @IBOutlet weak var keyAccount: UILabel!
    @IBOutlet weak var keyIconImg: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.keyDescrption.text = nil
        self.keyAccount.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
