//
//  CustomButtonWithBoderGray.swift
//  Phim24h
//
//  Created by Chung on 10/18/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CustomButtonWithBoderGray: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    func configureButton(){
        
        layer.cornerRadius = 8.0
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.setTitleColor(UIColor.black, for: UIControlState())
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }

}
