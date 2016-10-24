//
//  CellForMessage.swift
//  Phim24h
//
//  Created by Chung on 10/19/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CellForMessage: UITableViewCell {

    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var contentCell: UILabel!
    
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageCell.layoutIfNeeded()
        self.imageCell.layer.cornerRadius = self.imageCell.bounds.size.height / 2
        self.imageCell.clipsToBounds = true
        self.imageCell.layer.borderWidth = 1
        self.imageCell.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
