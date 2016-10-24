//
//  CustomImageView.swift
//  Phim24h
//
//  Created by Chung on 10/19/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureImageView()
    }
    func configureImageView(){
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}
