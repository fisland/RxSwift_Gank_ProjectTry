//
//  GViewCell.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit
import Reusable

class GViewCell: UITableViewCell,NibReusable {

    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension GViewCell {
    static func cellHeigh() -> CGFloat {
        return 240
    }
}
