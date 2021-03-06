//
//  TableViewCellWithPage.swift
//  Phim24h
//
//  Created by Chung on 9/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class TableViewCellWithPage: UITableViewCell {
    
    @IBOutlet weak var imPlay: UIImageView!
    @IBOutlet weak var bgCell: UIView!
    
    @IBOutlet weak var imType: UIImageView!

    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var contentCell: UITextView!
   
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var titleCell: UILabel!
    
    @IBOutlet weak var totalViewCell: UILabel!
    
    @IBOutlet weak var ViewOfImage: UIView!
    
    @IBOutlet weak var typeCell: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        settingCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func settingCell() {
        ViewOfImage.layer.cornerRadius = 5.0
        ViewOfImage.layer.borderWidth = 1.0
        ViewOfImage.layer.borderColor = UIColor.clear.cgColor
        
        parentView.layer.cornerRadius = 8.0
        parentView.layer.borderWidth = 1.0
        parentView.layer.borderColor = UIColor.init(red: 99/255, green: 226/255, blue: 183/255, alpha: 1).cgColor

        drawCornerRadius(parentView, rectCorner: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: CGSize(width: 4, height: 4), borderColor: UIColor.red)
    }
    func drawCornerRadius(_ view : UIView, rectCorner : UIRectCorner, radius : CGSize, borderColor : UIColor) {
        
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.borderWidth = 1.0
        view.layer.mask = maskLayer
        
    }

    
}
