//
//  DataTableViewCell.swift
//  Phim24h
//
//  Created by Chung on 9/20/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

struct DataTableViewCellData {
    
    init(imageUrl: String, text: String) {
        self.imageUrl = imageUrl
        self.text = text
    }
    var imageUrl: String
    var text: String
}

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var nameCell: UILabel!
    
    @IBOutlet weak var iconCell: UIImageView!
    
    override func awakeFromNib() {
        self.nameCell?.font = UIFont.systemFont(ofSize: 18)
        self.nameCell?.textColor = UIColor.white
//        self.backgroundColor = UIColor.menu
    }
    
    class func height() -> CGFloat {
        return 80
    }
    
    func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellData {
            self.iconCell.image = UIImage(named: data.imageUrl)
            self.nameCell.text = data.text
        }
    }
    
}
