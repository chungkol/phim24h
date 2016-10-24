//
//  CustomTextView.swift
//  Phim24h
//
//  Created by Chung on 10/18/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTextView()
    }
    func configureTextView(){
        
        layer.cornerRadius = 8.0
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }

}
