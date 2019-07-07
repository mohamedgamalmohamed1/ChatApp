//
//  RoomNameCellTableViewCell.swift
//  IDEChat2019
//
//  Created by mohamed gamal mohamed on 6/16/19.
//  Copyright © 2019 mohamed gamal mohamed. All rights reserved.
//

import UIKit

class RoomNameCellTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
