//
//  CollectionViewPeople.swift
//  Phim24h
//
//  Created by Chung on 10/3/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CollectionViewPeople: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!

    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbChar: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
