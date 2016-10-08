//
//  CustomButton.swift
//  Phim24h
//
//  Created by Chung on 10/5/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    func configureButton(){
        
        layer.cornerRadius = 8.0
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }


}
