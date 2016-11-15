//
//  CustomIM.swift
//  Phim24h
//
//  Created by Chung on 11/14/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
class CustomIM: UIImageView {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureImageView()
    }
    func configureImageView(){
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor

    }
}
