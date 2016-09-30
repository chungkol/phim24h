//
//  CellGenre.swift
//  Phim24h
//
//  Created by Chung on 9/28/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CellGenre: UITableViewCell {


    @IBOutlet weak var imageCell: UIImageView!
   
    @IBOutlet weak var titleCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
